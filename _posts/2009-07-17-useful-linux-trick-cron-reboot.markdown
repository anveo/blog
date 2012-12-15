---
comments: true
date: 2009-07-17 11:19:03
layout: post
slug: useful-linux-trick-cron-reboot
title: 'Useful Linux Trick: cron  @reboot'
wordpress_id: 138
categories:
- linux
- sysadmin
tags:
- cron
- linux
---

There are various ways to make sure something is run at system startup - Redhat has **/etc/rc.local** script, and it and many others have **/etc/init.d/*** scripts - but many times you might not have access to those files or creating init scripts might be overkill for your needs.

People are always amazed when I tell them they can achieve this basic functionality by using cron. Many of our websites use [Sphinx](http://sphinxsearch.com/), the excellent full text indexer, to allow site searches. Should the server ever reboot, we need to make multiple search daemons start back up. Take the following line from a crontab:


    
    
    crontab -l
    
    @reboot /usr/local/bin/searchd --config ~/conf/sphinx.conf
    



This will make sure the _searchd_ daemon starts on bootup.

Also there are a few other shortcuts you can use:


    
    
    @yearly        Run once a year, "0 0 1 1 *".
    @annually      (same as @yearly)
    @monthly       Run once a month, "0 0 1 * *".
    @weekly        Run once a week, "0 0 * * 0".
    @daily         Run once a day, "0 0 * * *".
    @midnight      (same as @daily)
    @hourly        Run once an hour, "0 * * * *".
    



See **man 5 cron** for more information.

(And to be pedantic, @reboot is run when cron is started or restarted, not necessarily the OS itself. So **/etc/init.d/cron restart** would trigger that line to be run. You may want to keep that in mind.)
