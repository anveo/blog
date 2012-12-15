---
comments: true
date: 2009-09-16 11:33:32
layout: post
slug: unobstrusive-viewing-of-mysql-queries-with-tcpdump
title: Unobtrusive viewing of MySQL queries with tcpdump
wordpress_id: 381
categories:
- linux
- mysql
- sysadmin
tags:
- tcpdump
---

There are times when you need to monitor the queries coming in to MySQL, but turning on query logging would create too much of a disk I/O hit, or you can't restart the server to setup [MySQL Proxy](http://forge.mysql.com/wiki/MySQL_Proxy). Instead we can just monitor the network traffic and extract data that might be interesting using **tcpdump** and an inline perl script:


    
    
    sudo tcpdump -i lo -s 0 -l -w - dst port 3306 | strings | perl -e '
    while(<>) { chomp; next if /^[^ ]+[ ]*$/;
      if(/^(SELECT|UPDATE|DELETE|INSERT|SET|COMMIT|ROLLBACK|CREATE|DROP|ALTER)/i) {
        if (defined $q) { print "$q\n"; }
        $q=$_;
      } else {
        $_ =~ s/^[ \t]+//; $q.=" $_";
      }
    }'
    



This will only work for clients communicating via TCP - if you are connecting through 'localhost' you will be going through a unix socket instead. If you switch 'localhost' to '127.0.0.1' then your queries will go through the network stack.

If you just want to dump the traffic to a file for a little bit and analyze it later, do this instead:


    
    
    sudo tcpdump -i lo port 3306 -s 65535 -x -n -q -tttt> tcpdump.out
    



You can then use **mk-query-digest** from [Maatkit](http://www.maatkit.org/) with**--type=tcpdump**. See more about this at the [MySQL Performance Blog](http://www.mysqlperformanceblog.com/2009/07/01/gathering-queries-from-a-server-with-maatkit-and-tcpdump/).
