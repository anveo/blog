---
comments: true
date: 2011-01-20 16:07:44
layout: post
slug: pretty-paging-in-rails-console
title: Pretty Paging in Rails Console
wordpress_id: 859
categories:
- bash
- linux
- rails
- ruby
---

When using irb or Rails console I use the [awesome_print](https://github.com/michaeldv/awesome_print) gem to get nicer colorized output. I also like to use [looksee](https://github.com/oggy/looksee) to examine method lookup paths which the gem colorizes nicely. For large objects looksee can produce a lot of output and if there is more output than your terminal can display at once it will get handed off to your system's pager (probably [less](http://en.wikipedia.org/wiki/Less_(Unix))). I was having an issue while in Rails console when the output got paged it would show the ANSI color escape codes rather than colorized text (this didn't happen in irb for whatever reason).

Luckily _less_ has a flag that will repaint the screen when paging. To make it a default you need to export a LESS variable to your shell's environment. Something like this:

    
    export LESS="-R"


Just throw that in your ~/.bashrc or [dotfiles](https://github.com/anveo/dotfiles/commit/db1f89cd9b8e50525bca3901bcf7f121cab41ce8#L0R3) and you're all set!

![](http://jetpackweb.com/blog/wp-content/uploads/2011/01/Screenshot-Terminal-1024x550.png)
