---
comments: true
date: 2010-02-25 10:40:42
layout: post
slug: mac-os-x-like-alt-tab-mouse-selection-in-ubuntu
title: Mac OS X like Alt-Tab Mouse Selection in Ubuntu
wordpress_id: 766
categories:
- osx
- ubuntu
---

I like how in OS X when I Alt-Tab I can pick a window or icon with a mouse click. I recently figured out how do get Ubuntu to perform in a similar fashion. First we need to install the **CompizConfig Settings Manager** (yes, you will need to be using compiz for this):


    
    
    sudo apt-get install compizconfig-settings-manager
    



Next navigate the system menu to **System -> Preferences -> CompizConfig Settings Manager**. The app should start so next scroll down to the **Window Management** section and click on **Static Application Switcher**. Next click the **Behavior** tab and the last option will be '**Allow Mouse Selection**'. Enable that check-box and exit the application.

It's not quite as nice as OS X - you can only select by clicking, just mousing over won't make each item the active target, but it's better than nothing!
