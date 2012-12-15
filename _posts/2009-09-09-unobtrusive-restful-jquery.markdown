---
comments: true
date: 2009-09-09 10:42:32
layout: post
slug: unobtrusive-restful-jquery
title: Unobtrusive RESTful jQuery
wordpress_id: 347
categories:
- jquery
- rails
- ruby
tags:
- javascript
- jquery
- rails
- rest
---

Many Rails(and non-Rails) web applications these days strive to create [RESTful](http://en.wikipedia.org/wiki/Representational_State_Transfer) interfaces for their application design. When dealing with Ajax updates through jQuery, this can become somewhat tricky. Since most browsers only implement GET and POST requests, we have to fake it in Rails by sending a parameter called **_methd** for all PUT and DELETE requests. To make things even more complicated, we need to include a token to prevent [CSRF](http://en.wikipedia.org/wiki/Cross-site_request_forgery) attacks.

In Rails 2.x, the default way it generates the javascript to send a a RESTful command via POST request looks something like this:


    
    
    <a href="/foos/1" onclick="if (confirm('Are you sure?')) { var f = document.createElement('form'); f.style.display = 'none'; this.parentNode.appendChild(f); f.method = 'POST'; f.action = this.href;var m = document.createElement('input'); m.setAttribute('type', 'hidden'); m.setAttribute('name', '_method'); m.setAttribute('value', 'delete'); f.appendChild(m);var s = document.createElement('input'); s.setAttribute('type', 'hidden'); s.setAttribute('name', 'authenticity_token'); s.setAttribute('value', 'VGcSbbdenz7ZCMDWl7LugKC2KFldp7oKdgdvjGyb4Zo='); f.appendChild(s);f.submit(); };return false;">Destroy</a> |
    



Yuck. It's creating a new form, setting a hidden input fields for the submission method and csrf token, and then submitting it. Not only is it obtrusive, that gets inserted at every location there is a delete or update link. 

First lets extend jquery with PUT and DELETE methods. Well call this **jquery.rest.js**:


    
    
    ;(function($){
      $.put = $.update = function(uri, data, callback, type = 'json') {
        if ($.isFunction(data)) callback = data, data = {}
        return $.post(uri, $.extend(data, { _method: 'put' }), callback, type)
      }
      
      $.delete = $.del = $.destroy = function(uri, data, callback, type = 'json') {
        if ($.isFunction(data)) callback = data, data = {}
        return $.post(uri, $.extend(data, { _method: 'delete' }), callback, type)
      }
    {)(jQuery)
    



The previous code will **POST** data while always including a '_method' parameter. Using this code is as simple as a normal jQuery ajax call:


    
    
    $('.deletable').click(function() {
      $.delete('/videos/delete', {
        'video_id': $(this).attr('id');
      });
    });
    



That example might iterate through all elements with the deletable class, and then sent the **DELETE** method when clicked.

 Now in a Rails app we also need to include the CSRF token in all POST, PUT, and DELETE requests. The way I go about this is to put this at the bottom of my applications layout:


    
    
    $(document).ready(function() {
      window.AUTH_TOKEN = '#{form_authenticity_token}';
      $(document).ajaxSend(function(event, request, settings) {
        if (typeof(window.AUTH_TOKEN) == "undefined") return;
        // IE6 fix for http://dev.jquery.com/ticket/3155
        if (settings.type == 'GET' || settings.type == 'get') return;
        settings.data = settings.data || "";
        settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(window.AUTH_TOKEN);
      });
    });
    



This will extend the parameters of any ajax request with the authenticity token. I hope this short guide gives you a better idea how to do REST in an unobtrusive way.
