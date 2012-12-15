---
comments: true
date: 2009-09-02 20:23:47
layout: post
slug: jquery-sortables-getting-element-position-for-an-efficient-ajax-update-in-rails
title: 'jQuery Sortables: Getting DOM element position for an efficient ajax update
  in Rails'
wordpress_id: 308
categories:
- jquery
- rails
- ruby
tags:
- act_as_list
- haml
- jquery
- rails
---

The jQuery UI library has some excellent interaction functionality, especially 'sortables' to make cool things like rearrangeable lists. Although there are lots of tutorials on sortable lists, one problem I have with them is the amount of database queries a single update can generate. They generally make use of the [Sortable.serialize](http://jqueryui.com/demos/sortable/#method-serialize) method, send *all* the elements back to the server, and update each element with something like ActiveRecord's [update_all](http://apidock.com/rails/ActiveRecord/Base/update_all/class)(which can be smart), or worse, separate SQL queries for each list element.

What we can do instead is just send the id and position of the single element that has moved, and use **acts_as_list** to adjust the positions in the database. Lets say we have an _unordered list_ of Video models _(I am using [HAML](http://haml-lang.com) in this example)_:


    
    
    %h3= "Videos"
    %ul(class="sortable")
      - @videos.each do |video|
        %li{ :id => "video_#{video.id}" }= video.title
    



That might output something like this:


    
    
    <h3>Videos</h3>
    <ul class="sortable">
      <li id="video_5">Batman Begins</li>
      <li id="video_6">Ghostbusters</li>
      <li id="video_7">Indiana Jones and the Temple of Doom</li>
     </ul>
    



We have the video's database id's in each of the element id's, and we have given the **ul** element the _sortable_ class so we can select it later. Now lets select that **ul** element and make it 'sortable':


    
    
    $(function() {
      $('.sortable').sortable();
    }
    



With that we can now drag each list item around. Now comes the important part. When we finish dragging a single list element we will send a single ajax request to the server that contains the numeric value of the element's id, and it's position in the list:


    
    
      $(function() {
        $('.sortable').sortable({
          stop: function(event, ui) {
            $(ui.item).effect("highlight");
            var video_id = $(ui.item).attr('id').replace(/[^\d]+/g, ''))
            var position = ui.item.prevAll().length;
            $.post('/videos/update_position', {
              'video_id': video_id,
              'position': position
             });
             $(ui.item).effect("highlight");
          }
        });
      })
    



Couple of notes:



**ui.item** is the DOM element we are dragging




**$(ui.item).attr('id').replace(/[^\d+]+/g, ''))** is pulling out the list item's DOM id and removing anything that isn't numeric, so we are left with the model's ID




**ui.item.prevAll().length** is what gives us the list item's position in relation to it's parent **ul**

Now our controller action can be as simple as:


    
    
    Video.find(params[:video_id]).insert_at(params[:position])
    



Again this requires **acts_as_list**.  I believe this should never do more that 4 queries: One to find the model, one to update it's position, and possibly two more to shift what was above and below it previously. Hopefully this saves you some SQL queries on larger lists.

 


