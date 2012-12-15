---
comments: true
date: 2009-09-17 14:44:01
layout: post
slug: textmate-and-gnu-screen-error-in-leopard
title: Textmate and GNU screen error in Leopard
wordpress_id: 389
categories:
- osx
- textmate
---

When running **mate** from inside a GNU screen session in Leopard, I was getting this error:


    
    
    $ mate .
    mate: failed to establish connection with TextMate.
    



I read reports of falling back to a previous version in macports, but a simple solution is to put this line in your _.profile_ config: 


    
    
    alias mate='open -a TextMate.app'
    



That will fix the problem.
