---
comments: true
date: 2008-11-04 14:02:32
layout: post
slug: svn-autobackup-restore
title: SVN autobackup restore
wordpress_id: 7
categories:
- linux
- sysadmin
tags:
- backups
- linux
- php
- subversion
- svn
---

I have been using [Doug Hellman's](http://blog.doughellmann.com/) useful [svnautobackup](http://code.google.com/p/svnautobackup/) script for our subversion backups. I think it is a pretty useful script, but it only focuses on backups and not restoration.

During a recent server upgrade I needed to restore a large amount of repositories from our dumpfiles. I made the following shell script in php that will loop through all of the backup dumps and restore them. There is a [similar tool](http://blogs.law.harvard.edu/hoanga/2008/07/03/svnbackup-restorerb-svnbackups-handy-companion-tool/) that uses ruby, but it can only restore one repository and I do not know enough ruby to modify it :)

    
    #!/usr/bin/php -q
    isDot())
      {
        // get files
        $dumpfiles = glob($backup_dir.$file.'/dumpfile*.bzip2');
        // sort them
        natsort($dumpfiles);
    
        // create the repo if not exists
        if(!is_dir($repo_dir.$file))
        {
          $cmd =  "svnadmin create {$repo_dir}{$file}";
          system(escapeshellcmd($cmd));
        }
    
        // restore dump files
        foreach($dumpfiles as $dumpfile)
        {
          $cmd = "bzcat {$dumpfile} | svnadmin load {$repo_dir}{$file}";
          system(escapeshellcmd($cmd));
        }
      }
    }
    


For reference, here is the script that runs nightly though cron

    
    #!/bin/bash
    
    files=`ls /svn`
    for file in $files
    do
      if [ -d /svn/$file ]
      then
        mkdir -p $file
        /home/backup/scripts/svnautobackup/svnbackup.sh -v -i 100 --history-file /home/backup/svn/$file-hist --out-dir /home/backup/svn/$file /svn/$file
      fi
    done
