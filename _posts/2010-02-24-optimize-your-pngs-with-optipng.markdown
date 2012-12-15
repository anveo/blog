---
comments: true
date: 2010-02-24 17:39:58
layout: post
slug: optimize-your-pngs-with-optipng
title: Optimize your PNG's with OptiPNG
wordpress_id: 754
---

Here is a quick shell command tip to run all your PNG files through the file size optimizer **OptiPNG**. Since PNG is a loss-less format quality stays exactly the same and file-size shrinks! I install optipng via MacPorts via the following command:


    
    
    sudo port install optipng
    



In this example, _public/images_ is the directory I want to search for PNG files:

    
    
    find public/images/ -iname *.png -print0 |xargs -0 optipng -o7
    



The **-o7** flag means it will try seven different compression techniques for each file and pick the best one. If it couldn't do better, optipng will just leave the file alone and move on to the next.

If you just want to check if optipng will perform better compression but you don't want it to modify your files yet just, add the **-simulate** parameter at the end.


