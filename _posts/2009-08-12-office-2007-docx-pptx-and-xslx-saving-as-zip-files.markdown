---
comments: true
date: 2009-08-12 13:57:07
layout: post
slug: office-2007-docx-pptx-and-xslx-saving-as-zip-files
title: Office 2007 docx, pptx, and xslx saving as zip files
wordpress_id: 238
categories:
- apache
tags:
- office 2007
---

Recently I had an issue where various browsers on Windows desktops were saving **docx**, **xslx**, and **pptx** as zip files when downloaded from our linux web servers(apache in this case). The solution was to add extra mime-types to /etc/mime/types: 


    
    
    echo 'application/vnd.openxmlformats       docx pptx xlsx' >> /etc/mime.types
    



And then restart apache:


    
    
    sudo /etc/init.d/apache2 reload
    



This would also require **mod_mime** to be loaded, and is by default in Debian based systems. To verify the location of the mime.types file your server is using, the following commands may be helpful(replace the httpd.conf or mods conf directory with your distributions location).


    
    
    grep -n mime.types /etc/apache2/mods-available/*
    grep -n mime.types /etc/apache2/httpd.conf
    



Linux desktops with [Open Office](http://www.openoffice.org/) had no such problems :)


