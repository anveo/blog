---
comments: true
date: 2009-09-23 13:13:30
layout: post
slug: pbcopy-in-ubuntu-command-line-clipboard
title: pbcopy / pbpaste in Ubuntu (command line clipboard)
wordpress_id: 401
categories:
- linux
tags:
- pbcopy
- ubuntu
---

OS X has a neat command-line tool called pbcopy which takes the standard input and places it in the clipboard to paste into other applications.

In Ubuntu(or any Linux distro with Xwindows), a similar tool is **xclip**. I like to make this alias:


    
    
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'
    



or the following also works if you would rather use **xsel**:


    
    
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'
    



Now you can pipe any text to **pbcopy**


    
    
    $ cat ~/.ssh/id_dsa.pub | pbcopy
    



Your public ssh key is transferred to your clipboard and is ready to be pasted(perhaps with pbpaste).
