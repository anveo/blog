---
comments: true
date: 2009-10-02 16:33:10
layout: post
slug: rails-autocompletion-in-macvim-when-using-macports
title: Rails autocompletion in MacVim when using Macports
wordpress_id: 439
categories:
- osx
- rails
- ruby
- vim
---

In moving much of my development over to OS X, I started receiving errors when trying to use vim's omnicompletion in Rails projects. An excerpt from my vim config to enable that functionality looks like this:


    
    
    " Turn on language specific omnifuncs
    autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
    autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
    autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
    autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
    autocmd FileType ruby,eruby let g:rubycomplete_include_object = 1
    autocmd FileType ruby,eruby let g:rubycomplete_include_objectspace = 1
    



When I tried to auto-complete something(Ctrl^X^O), I would receive the following error:


    
    
    "-- Omni completion (^O^N^P) -- Searching...Rails requires RubyGems >= 1.3.5 (you have 1.0.1). Please `gem update --system` and try again. Error loading rails environment"
    



Long story short, I was using MacPort's ruby/gem packages, but a binary snapshot of MacVim that I downloaded off their website was using the libraries that come with OSX. There is not really a clean workaround for that, but luckily it turns out macport's macvim builds the latest snapshot. So all you need to is to install macvim with ruby support:


    
    
    sudo port install macvim +ruby
    



And you will get nice auto-completion:

[![macvim_omnicomplete](http://jetpackweb.com/blog/wp-content/uploads/2009/10/macvim_omnicomplete-300x221.png)](http://jetpackweb.com/blog/wp-content/uploads/2009/10/macvim_omnicomplete.png)


