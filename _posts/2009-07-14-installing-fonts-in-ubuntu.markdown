---
comments: true
date: 2009-07-14 12:05:01
layout: post
slug: installing-fonts-in-ubuntu
title: Installing fonts in Ubuntu
wordpress_id: 42
categories:
- desktop
- linux
---

Recently I wanted to add some Mac-style fonts to my Ubuntu system. Although it requires slightly more work than just dragging the font files into a folder, it is still quite simple.

If you have full root or sudo access and you would like the font to be shared with all users of the system, you may want to put the files in **/usr/local/share/fonts/truetype**. An easy way to navigate to that location with root privileges is to press **Alt+F2** and type:

    
    gksudo nautilus /usr/local/share/fonts/truetype


You can then create a new directory and place your fonts into it.

Alternatively you may place the fonts in a directory inside your home folder. The files get placed in a hidden directory called _.fonts_. You may have to create this directory. Only you will be able to access these fonts.

    
    mkdir ~/.fonts


Whichever you choose, you will need to reset the font cache . You can reset the cache with the following command:

    
    sudo fc-cache -f -v


And for anyone interested, here are a nice set of free MacOS font alternatives to use in Windows or Linux

[Mac-Fonts](http://jetpackweb.com/blog/wp-content/uploads/2009/07/Mac-Fonts.zip) - this includes AppleGaramond, Aquabase, LITHOGRL, Lucida Grande, Lucida Mac, Lucon, MacGrand. I downloaded these from [this site](http://www.osx-e.com/downloads/misc/macfonts.html), however you need to go through multiple pages of referral sign-ups to access the file.

[Monaco Linux](http://jetpackweb.com/blog/wp-content/uploads/2009/07/Monaco_Linux.ttf) - This is the font I use in vim, it looks great.

[Inconsolata](http://www.levien.com/type/myfonts/Inconsolata.otf) - This is a variation of Luc(as) de Groot's Consolas font, which is another nice mono-spaced programming font featured in Windows Vista. Read more about it at the [authors webpage](http://www.levien.com/type/myfonts/inconsolata.html).

You may also want to install the Miscrosoft Web Fonts(msttcorefonts):


    
    sudo aptitude install msttcorefonts
