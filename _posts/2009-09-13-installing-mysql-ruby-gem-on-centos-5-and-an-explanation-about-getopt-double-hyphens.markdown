---
comments: true
date: 2009-09-13 16:37:23
layout: post
slug: installing-mysql-ruby-gem-on-centos-5-and-an-explanation-about-getopt-double-hyphens
title: Installing MySQL Ruby Gem on CentOS 5 (and an explanation about getopt's double
  hyphens)
wordpress_id: 62
categories:
- mysql
- ruby
---

I had an issue trying to build the mysql gem on CentOS 5.x. 


    
    
    ERROR: While executing gem … (Gem::Installer::ExtensionBuildError)
    ERROR: Failed to build gem native extension.
    
    ruby extconf.rb update
    checking for mysql_query() in -lmysqlclient… no
    ...
    



After much hairpulling, two hyphens solved my problem:


    
    
    sudo gem install mysql -- \
    --with-mysql-include=/usr/include/mysql \
    --with-mysql-lib=/usr/lib/mysql
    



A blog comment I found explains the double hyphens:



> 
The double hyphens (–) tells the option parser that there is no more options on the command line. This special syntax comes from GNU getopt. Everything after ‘–’ is treated as non-options. This is useful if you want to write something on the command line that looks like an option but is not, or if it should be parsed though as an option to another program called by the one you are calling.

The two hyphens in this particular command string is important since the gem binary must not confuse the ‘–with-mysql-dir’ option as an option for gem it self. Instead this option should be passed on to the make command called in the gem internals.

[Thomas Watson](http://justaddwater.dk/)




And if you are on a 64-bit system, be sure to use **–-with-mysql-lib=/usr/lib64/mysql** instead.
