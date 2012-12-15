---
comments: true
date: 2009-07-16 10:54:51
layout: post
slug: how-to-fix-munins-mysql-graph-on-cpanel
title: How to fix Munin's MySQL Graph on cPanel
wordpress_id: 105
categories:
- cpanel
- linux
- mysql
- sysadmin
tags:
- cpanel
- munin
- mysql
---

We have a few cPanel servers deployed and to visually monitor performance we use the Munin monitoring tool. We were having issues where the MySQL graphs would stop updating. The bug has to do with one of the perl libraries the script uses, which causes the MySQL plugin to have problems location the **mysqladmin** program.

To fix these, create or edit the following file:


    
    vi /etc/munin/plugin-conf.d/cpanel.conf



It should contain the following:


    
    
    [mysql*]
    user root
    group wheel
    env.mysqladmin /usr/bin/mysqladmin
    env.mysqlopts --defaults-extra-file=/root/.my.cnf
    



This would load the username and password from root's mysql config. If that file doesn't exist you can create it:


    
    
    sudo vi /root/.my.cnf
    




    
    
    [client]
    user="root"
    pass="secret!password"
    



Now just restart Munin, wait a a little bit, and the graphs should start populating again!


    
    
    sudo /etc/init.d/munin-node restart
    
