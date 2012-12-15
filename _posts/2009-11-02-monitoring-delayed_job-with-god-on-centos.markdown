---
comments: true
date: 2009-11-02 16:24:51
layout: post
slug: monitoring-delayed_job-with-god-on-centos
title: Monitoring delayed_job with god on CentOS
wordpress_id: 570
categories:
- linux
- rails
- ruby
- sysadmin
tags:
- centos
- delayed_job
- god
---

I recently started using [god](http://god.rubyforge.org/) rather than [monit](http://mmonit.com/monit/) for process monitoring. **god** lets me be a bit more expressive with how I want processes monitored using the the power of Ruby.

The current project I am working on has a number of tasks that I want processed asynchronously so I will setup **god** to monitor my [delayed_jobs](http://github.com/collectiveidea/delayed_job). If you are not familiar with awesome delayed_job gem, watch the excellent [Railscast tutorial](http://railscasts.com/episodes/171-delayed-job).

First install the god gem:


    
    
    $ sudo gem install god
    



Next we will create a Redhat compatible init script for god:


    
    
    $ sudo vi /etc/init.d/god
    
    #!/bin/bash
    #
    # God
    #
    # chkconfig: - 85 15
    # description: start, stop, restart God (bet you feel powerful)
    #
    
    RETVAL=0
    
    case "$1" in
        start)
          /usr/bin/god -P /var/run/god.pid -l /var/log/god.log
          /usr/bin/god load /etc/god.conf
          RETVAL=$?
          ;;
        stop)
          kill `cat /var/run/god.pid`
          RETVAL=$?
          ;;
        restart)
          kill `cat /var/run/god.pid`
          /usr/bin/god -P /var/run/god.pid -l /var/log/god.log
          /usr/bin/god load /etc/god.conf
          RETVAL=$?
          ;;
        status)      
          /usr/bin/god status
          RETVAL=$?
          ;;
        *)
          echo "Usage: god {start|stop|restart|status}"
          exit 1
      ;;
    esac
    
    exit $RETVAL
    




###### (adapted from debian version at [http://mylescarrick.com/articles/simple_delayed_job_with_god](http://mylescarrick.com/articles/simple_delayed_job_with_god))



Now adjust the permissions, and set the init script to start on system boot:


    
    
    $ sudo chmod a+x /etc/init.d/god
    $ sudo /sbin/chkconfig --add god
    $ sudo /sbin/chkconfig --level 345 god on
    



Before we start **god** up, we need to create a configuration file that tells it what configuration files to load:


    
    
    $ sudo vi /etc/god.conf
    
    God.load "/srv/apps/your_app/current/config/god/*.god"
    



You will need to adjust the above depending on how you have your app setup. When working in a Rails project I like to put my god scripts in _config/god_.

We will use [a script](http://github.com/blog/229-dj-god) from the guys at github to monitor our job daemon. I tweaked it slightly to have less workers, and to set the environment properly.


    
    
    RAILS_ROOT = "/srv/apps/your_app/current"
     
    1.times do |num|
      God.watch do |w|
        w.name = "dj-#{num}"
        w.group = 'dj'
        w.interval = 30.seconds
        w.start = "rake -f #{RAILS_ROOT}/Rakefile RAILS_ENV=production jobs:work"
     
        w.uid = 'your_app_user'
        w.gid = 'your_app_user'
     
        # retart if memory gets too high
        w.transition(:up, :restart) do |on|
          on.condition(:memory_usage) do |c|
            c.above = 300.megabytes
            c.times = 2
          end
        end
     
        # determine the state on startup
        w.transition(:init, { true => :up, false => :start }) do |on|
          on.condition(:process_running) do |c|
            c.running = true
          end
        end
      
        # determine when process has finished starting
        w.transition([:start, :restart], :up) do |on|
          on.condition(:process_running) do |c|
            c.running = true
            c.interval = 5.seconds
          end
        
          # failsafe
          on.condition(:tries) do |c|
            c.times = 5
            c.transition = :start
            c.interval = 5.seconds
          end
        end
      
        # start if process is not running
        w.transition(:up, :start) do |on|
          on.condition(:process_running) do |c|
            c.running = false
          end
        end
      end
    end
    



It's now time to start the daemon:


    
    
    $ sudo /etc/init.d/god start
    $ sudo /etc/init.d/god status
    dj:
      dj-0: up
    



Looks good! If you want to make sure it's working, kill the rake task running **jobs:work**. god will see that it is stopped and automatically restart it!
