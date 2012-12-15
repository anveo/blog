---
comments: true
date: 2009-10-21 23:24:15
layout: post
slug: rails-2-3-4-and-swfupload-rack-middleware-for-flash-uploads-that-degrade-gracefully
title: Rails 2.3.4 and SWFUpload - Rack Middleware for Flash Uploads that Degrade
  Gracefully
wordpress_id: 523
categories:
- javascript
- rails
- ruby
tags:
- rack
- rails
- swfobject
- swfupload
---

Browser upload controls have been pretty much the same for years. They are very difficult to style, and do not look consistent across browsers. Perhaps the biggest issue with them is they provide no feedback to the user about how long the submission will take. One alternative is to use Flash for the uploads. There are numerous libraries available, I like [SWFUpload](http://swfupload.org/). Since the reason you are here is probably because you can't get it working in Rails, I'm going to try and help you deal with the quirks associated with using Flash and Rails together.

It used to be you would monkeypatch the CGI class to get Flash uploaders to work due to issues with Flash. With the introduction of [Rack](http://rack.rubyforge.org/) in Rails 2.3 things now work quite differently. What we will do is create some rack middleware to intercept traffic from Flash to deal with it's quirks. I have created a small example application of an mp3 player and uploader. You will probably want to download it, as it contains a few files not displayed in this article. You can clone it from the [github project page](http://github.com/anveo/swfupload_demo).

First lets create a simple Song model:

    
    
    ./script generate model Song title:string artist:string length_in_seceonds:integer track_file_name:string track_content_type:string track_file_size:integer
    



_title_, _artist_, and _length_in_seconds_ are meta-data we will pull from the ID3 tags of the uploaded mp3 file, and the rest will be used by [Paperclip](http://www.thoughtbot.com/projects/paperclip) to handle the attachment. Lets add the paperclip attachment and a few simple validations to our new Song model:


    
    
    class Song < ActiveRecord::Base
    
      has_attached_file :track,
                        :path => ":rails_root/public/assets/:attachment/:id_partition/:id/:style/:basename.:extension",
                        :url => "/assets/:attachment/:id_partition/:id/:style/:basename.:extension"
    
      validates_presence_of :title, :artist, :length_in_seconds
      validates_attachment_presence :track
      validates_attachment_content_type :track, :content_type => [ 'application/mp3', 'application/x-mp3', 'audio/mpeg', 'audio/mp3' ]
      validates_attachment_size :track, :less_than => 20.megabytes
    
      attr_accessible :title, :artist, :length_in_seconds
    
      def convert_seconds_to_time
        total_minutes = length_in_seconds / 1.minutes
        seconds_in_last_minute = length_in_seconds - total_minutes.minutes.seconds
        "#{total_minutes}m #{seconds_in_last_minute}s"
      end
    end
    



Next comes an upload form and some containers to hold the SWFUploader:


    
    
    - form_tag songs_path, :multipart => true do
      #swfupload_degraded_container
        %noscript= "You should have Javascript enabled for a nicer upload experience"
        = file_field_tag :Filedata
        = submit_tag "Add Song"
      #swfupload_container{ :style => "display: none" }
        %span#spanButtonPlaceholder
      #divFileProgressContainer
    
    



The container that holds the SWFUploader will be hidden until we know the user can support it. Initially a standard file upload form will display. A number of things can go wrong, so we need to think about a few levels of degradation here. The user might not have flash installed, the user might have an outdated version of flash, he might not have javascript installed or enabled(which is needed to load the flash), and there may be a problem downloading the flash swf file. Yikes. Luckily using the [swfobject](http://code.google.com/p/swfobject/) library we can easily handle all these potential issues.

If the user is missing javascript, he will see the message in the **noscript** tag and be presented a standard upload control.

If the user is missing flash or it is outdated, he will be presented a dialog with an upgrade link. Otherwise he can use the standard upload control.

If  everything goes okey-dokey, then some function handlers we write will hide the the degradation container, and display the flash container.

_Oh, and just so you know the current version of Flash Player for linux do not fire the event that monitors upload progress, so you will not get the status bar until the upload finishes. No work around for that right now._

So lets initialize the SWFUpload via some javascript. Many tutorials out there seem to put the authentication token and session information in the URL, but there are some options with current version of SWFUpload to POST and avoid that.


    
    
    :javascript
      SWFUpload.onload = function() {
        var swf_settings = {
    
          // SWFObject settings
          minimum_flash_version: "9.0.28",
          swfupload_pre_load_handler: function() {
            $('#swfupload_degraded_container').hide();
            $('#swfupload_container').show();
          },
          swfupload_load_failed_handler: function() {
          },
    
          post_params: {
            "#{session_key_name}": "#{cookies[session_key_name]}",
            "authenticity_token": "#{form_authenticity_token}",
          },
    
          upload_url: "#{songs_path}",
          flash_url: '/flash/swfupload/swfupload.swf',
    
          file_types: "*.mp3",
          file_types_description: "mp3 Files",
          file_size_limit: "20 MB",
    
          button_placeholder_id: "spanButtonPlaceholder",
          button_width: 380,
          button_height: 32,
          button_text : '<span class="button">Select Files <span class="buttonSmall">(20 MB Max)</span></span>',
          button_text_style : '.button { font-family: Helvetica, Arial, sans-serif; font-size: 24pt; } .buttonSmall { font-size: 18pt; }',
          button_text_top_padding: 0,
          button_text_left_padding: 18,
          button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
          button_cursor: SWFUpload.CURSOR.HAND,
          file_queue_error_handler : fileQueueError,
          file_dialog_complete_handler : fileDialogComplete,
          upload_progress_handler : uploadProgress,
          upload_error_handler : uploadError,
          upload_success_handler : uploadSuccess,
          upload_complete_handler : uploadComplete,
    
          custom_settings : {
            upload_target: "divFileProgressContainer"
          }
        }
        var swf_upload = new SWFUpload(swf_settings);
      };
    



You will want to check out the [official SWFUpload docs](http://demo.swfupload.org/Documentation/#settingsobject) to understand what all of these variable do. There are [many handlers](http://github.com/anveo/swfupload_demo/blob/master/public/javascripts/swfupload/handlers.js) we have to define to handle various events, and if you clone the project you can review them in detail.

We also need to set styles for the containers that will be generated. You can see the Sass file I created for SWFUpload [here](http://github.com/anveo/swfupload_demo/blob/master/app/stylesheets/swfupload.sass), and [another one](http://github.com/anveo/swfupload_demo/blob/master/app/stylesheets/nifty.sass) for Ryan Bates [nifty_generators](http://github.com/ryanb/nifty-generators).

Another quirk we have to be aware of when dealing with flash uploads is that everything gets a content-type of an octet stream. We will use the [mime-types](http://mime-types.rubyforge.org/) library to identify it for validation. Keep in mind it only uses the extension to determine the file type. (_I haven't tested it yet, but I believe [mimetype-fu](http://github.com/mattetti/mimetype-fu) will actually check file-data and magic numbers_). By default SWFUpload calls the file parameter 'Filedata'.


    
    
      def create
        require 'mp3info'
    
        mp3_info = Mp3Info.new(params[:Filedata].path)
    
        song = Song.new
        song.artist = mp3_info.tag.artist
        song.title = mp3_info.tag.title
        song.length_in_seconds = mp3_info.length.to_i
    
        params[:Filedata].content_type = MIME::Types.type_for(params[:Filedata].original_filename).to_s
        song.track = params[:Filedata]
        song.save
    
        render :text => [song.artist, song.title, song.convert_seconds_to_time].join(" - ")
      rescue Mp3InfoError => e
        render :text => "File error"
      rescue Exception => e
        render :text => e.message
      end
    



Another annoyance with flash uploads is that it doesn't send cookie data. That is why we are sending the session information in the POST data. We will intercept requests from Flash, check for the session key, and if so inject it into the cookie header. We can do this with some pretty simple middleware.


    
    
    require 'rack/utils'
    
    class FlashSessionCookieMiddleware
      def initialize(app, session_key = '_session_id')
        @app = app
        @session_key = session_key
      end
    
      def call(env)
        if env['HTTP_USER_AGENT'] =~ /^(Adobe|Shockwave) Flash/
          params = ::Rack::Request.new(env).params
          env['HTTP_COOKIE'] = [ @session_key, params[@session_key] ].join('=').freeze unless params[@session_key].nil?
        end
        @app.call(env)
      end
    end
    



This is a modified version from code the appears in a few tutorials about flash uploads. It will allow the session information to be in the query string *or* POST data. Next we have to make sure this middleware gets put to use so in _config/initializers/session_store.rb_ add:


    
    
    ActionController::Dispatcher.middleware.insert_before(ActionController::Base.session_store, FlashSessionCookieMiddleware, ActionController::Base.session_options[:key])
    



And that's, uhh, all there is too it. Again, I really suggest you [checkout the example project](http://github.com/anveo/swfupload_demo). It also uses the nifty Wordpress Audio Player flash control to play the music you upload!

![](http://jetpackweb.com/blog/wp-content/uploads/2009/10/Picture-21.png)
![](http://jetpackweb.com/blog/wp-content/uploads/2009/10/Picture-11.png)

