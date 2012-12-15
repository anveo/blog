---
comments: true
date: 2010-01-08 20:17:09
layout: post
slug: pimp-your-ps1-with-source-control-information
title: Pimp your $PS1 with source control information
wordpress_id: 623
categories:
- bash
- linux
tags:
- bash
- cvs
- git
- hg
- mercurial
- svn
- zsh
---

I recently found a useful tip of appending source control information of the current working directory to your shell's $PS1 line. It might look something like the following image:

![](http://jetpackweb.com/blog/wp-content/uploads/2010/01/Screenshot-Terminal.png)

 The method I saw suggested using [vcprompt](http://vc.gerg.ca/hg/vcprompt/), a small program that outputs a short string basic version control info. Although it worked well, there were a couple issues I had with it. First, it's subversion support was somewhat lacking. Second, it was written in C which made it more of a pain to modify, and I wasn't a huge fan of keeping the binary in version control. 

After a little searching I stumbled across [vcprompt.py](http://github.com/xvzf/vcprompt), a python script that did the same thing. This version also had wider support for source control systems, and being a standard python text script it was something I could easily modify and put into my [dotfiles](http://github.com/anveo/dotfiles) git repo. I wasn't happy with how this one displayed subversion information either(just a revision number which I didn't find very helpful), so I [**made my own modification**](http://github.com/anveo/dotfiles/blob/master/scripts/vcprompt.py) to display the branch you are in. Please pardon my lacking Python skills. 

Anyway, on to pimping your prompt. Before we modify the PS1 variable, we need to make sure the vcprompt.py is in your $PATH. I like to put scripts like this in a custom  _bin_ directory in my homedir. One way to accomplish that might be the following:


    
    
    $ mkdir -p ~/bin
    $ cd ~/bin
    $ wget http://github.com/anveo/dotfiles/raw/master/scripts/vcprompt.py
    $ chmod +x vcprompt.py
    $ export PATH=~/bin:$PATH
    



Displayed next is the PS1 line I use - it takes up two lines: the first line contains the current user, hostname,  current working directory, and possibly version control info, and the second is just a nice looking arrow for my input. Your terminal will need to support Unicode if you want to use that symbol.


    
    
    # .bashrc
    PS1="\n\u@\h:\w \[\e[1;30m\]$(vcprompt)\[\e[0m\] \n→"
    
    # If you are using zsh you may also need the following in .zshrc
    setopt prompt_subst
    


If you use the colors specified, you may need to [define those too](http://github.com/anveo/dotfiles/blob/master/bash/config).

You should now have a prompt similar to the image above! For more shell customizations checkout the rest of my [dotfiles](http://github.com/anveo/dotfiles), and consider buying Peepcode's [Advanced Command Line screencasts](http://peepcode.com/products/advanced-command-line) for more productive tips!

