---
comments: true
date: 2009-07-15 11:08:04
layout: post
slug: using-maatkit-to-batch-convert-mysql-storage-engines
title: Using Maatkit to batch convert MySQL storage engines
wordpress_id: 75
categories:
- mysql
---

Recently I was working with a client who imported a couple databases, each that had thousands of InnoDB tables taking up tens of gigabytes of data to a new server. Unfortunately the InnoDB engine was misconfiguration and therefore not loaded at the time of import. MySQL silently created all these tables as MyISAM instead. Not wanting to wait hours for the import process to proceed again, I used a program from the excellent [Maatkit](http://www.maatkit.org/) package: [mk-find](http://www.maatkit.org/doc/mk-find.html). It works similar to the unix find command, except it works on the MySQL server.

The following command will find all MyISAM tables from a certain database and convert them to InnoDB:


    
    mk-find <db_name> --engine MyISAM --exec "ALTER TABLE %D.%N ENGINE=INNODB" --print 



You can download the latest version from Maatkit's [Google Code](http://code.google.com/p/maatkit/) page.
