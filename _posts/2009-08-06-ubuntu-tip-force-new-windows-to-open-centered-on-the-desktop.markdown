---
comments: true
date: 2009-08-06 09:57:15
layout: post
slug: ubuntu-tip-force-new-windows-to-open-centered-on-the-desktop
title: 'Ubuntu Tip: Force new windows to start centered on the desktop'
wordpress_id: 207
categories:
- desktop
- linux
tags:
- compiz
- metacity
- ubuntu
---

I use a pretty generic Gnome + Compiz desktop setup in Ubuntu, but one thing that really irks me is my applications always seem to start snapped to a corner. What I really want is for them to open centered on my desktop. You can achieve this by doing a little registry modification(I'm pretty sure there is a nice GUI app to adjust these settings, but I don't believe it is installed by default).



Press **Alt+F2** and enter **gconf-config**. This will open up Gnome's registry editor.

Set the following two values:
**Key:** /apps/metacity/general/focus_new_windows **Value:** smart
**Key:** /apps/compiz/plugins/place/screen0/options/mode **Value:** 1



Now your applications should start up nice and centered :)
