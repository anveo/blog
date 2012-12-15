---
comments: true
date: 2010-05-19 16:21:53
layout: post
slug: making-monit-delayed_job-and-bundler-play-nice-together
title: Making monit, delayed_job, and bundler play nice together
wordpress_id: 831
categories:
- linux
- rails
- ruby
- sysadmin
tags:
- bundler
- delayed_job
- monit
---

Recently I was having a heck of a time getting [monit](http://mmonit.com/monit/) to start my [delayed_job](http://github.com/collectiveidea/delayed_job) instances. I was using the monit template that came with delayed job, it looks something like this:


    
    
    check process delayed_job_bandwith_prod 
      with pidfile /home/bandwith/apps/production/shared/pids/delayed_job.pid
      start program = "/usr/bin/env RAILS_ENV=production /home/bandwith/apps/production/current/script/delayed_job start" as uid bandwith and gid bandwith 
      stop program  = "/usr/bin/env RAILS_ENV=production /home/bandwith/apps/production/current/script/delayed_job stop" as uid bandwith and gid bandwith
    



This did not work however, and after quite a bit of debugging I found there are a couple of issues you might need to be aware of:



## 1. Your $PATH



monit starts things with a '_spartan path_' of:


    
    
    /bin:/usr/bin:/sbin:/usr/sbin
    



My ruby happens to be in /usr/local/bin, so we will need to pass that in too:


    
    
    start program = "/usr/bin/env PATH=/usr/local/bin:PATH RAILS_ENV=production /var/www/apps/{app_name}/current/script/delayed_job start"
    





## 2. monit doesn't define a $HOME environment variable



Even though we are starting these processes with uids and guids specified, that doesn't actually load the users shell. With no $HOME env variable, [bundler](http://gembundler.com/) can't find where your gems are installed and thinks they are all missing. I ended up just putting the variable in the monit command, another option might be running _su -c '{command}'_ (I didn't test that).

So putting that all together you get the following which should make everything work:


    
    
    check process delayed_job_bandwith_prod 
      with pidfile /home/bandwith/apps/production/shared/pids/delayed_job.pid
      start program = "/usr/bin/env HOME=/home/bandwith PATH=/usr/local/bin:$PATH RAILS_ENV=production /home/bandwith/apps/production/current/script/delayed_job start" as uid bandwith and gid bandwith 
      stop program  = "/usr/bin/env HOME=/home/bandwith PATH=/usr/local/bin:$PATH RAILS_ENV=production /home/bandwith/apps/production/current/script/delayed_job stop" as uid bandwith and gid bandwith
    



I would be interested to know if anyone has any better suggestions, but this seems to be working nicely.
