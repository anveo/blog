---
comments: true
date: 2009-09-29 10:54:05
layout: post
slug: munin-graphs-for-phusion-passenger-a-k-a-mod_rails
title: Munin Graphs for Phusion Passenger (a.k.a. mod_rails)
wordpress_id: 408
categories:
- apache
- cpanel
- rails
- ruby
tags:
- munin
---

The goal of this article is to get fairly nice looking graphs of [Phusion Passenger's](http://www.modrails.com/) performance and memory metrics:

![](http://jetpackweb.com/blog/wp-content/uploads/2009/09/passenger_memory_stats.png)
![](http://jetpackweb.com/blog/wp-content/uploads/2009/09/passenger_status.png)

This specific setup focuses on CentOS (on cPanel none the less) - but instructions should apply for most linux distros. It assumes you already have Passenger and Munin successfully setup. See my [previous article](http://jetpackweb.com/blog/2009/07/21/install-phusion-passenger-a-k-a-mod_rails-on-cpanel-server/) on getting Phusion Passenger setup if you have not already. 

First we need to allow the **munin** user sudo privileges for a few passenger related commands:


    
    
    $ sudo /usr/sbin/visudo
    
    # Add the following line to the file
    munin ALL=(ALL) NOPASSWD:/usr/bin/passenger-status, /usr/bin/passenger-memory-stats
    
    # Depending on your setup, you may also have to comment out the following line:
    Defaults requiretty
    



If you see the error **sorry, you must have a tty to run sudo** in **/var/log/munin/munin-node.log**, comment out the final line shown above.

The following two files will glean some performance and memory statistics.

**Passenger Status:**

    
    
    sudo vi /usr/share/munin/plugins/passenger_status
    



    
    
    #!/usr/bin/env ruby
     
    def output_config
      puts <<-END
    graph_category App
    graph_title passenger status
    graph_vlabel count
     
    sessions.label sessions
    max.label max processes
    running.label running processes
    active.label active processes
    END
      exit 0
    end
     
    def output_values
      status = `sudo /usr/bin/passenger-status`
      unless $?.success?
        $stderr.puts "failed executing passenger-status"
        exit 1
      end
      status =~ /max\s+=\s+(\d+)/
      puts "max.value #{$1}"
     
      status =~ /count\s+=\s+(\d+)/
      puts "running.value #{$1}"
     
      status =~ /active\s+=\s+(\d+)/
      puts "active.value #{$1}"
     
      total_sessions = 0
      status.scan(/Sessions: (\d+)/).flatten.each { |count| total_sessions += count.to_i }
      puts "sessions.value #{total_sessions}"
    end
     
    if ARGV[0] == "config"
      output_config
    else
      output_values
    end
    



**Memory Stats:**

    
    
    sudo vi /usr/share/munin/plugins/passenger_memory_status
    



    
    
    #!/usr/bin/env ruby
    # put in /etc/munin/plugins and restart munin-node
    # by Dan Manges, http://www.dcmanges.com/blog/rails-application-visualization-with-munin
    # NOTE: you might need to add munin to allow passwordless sudo for passenger-memory-stats
     
    def output_config
      puts <<-END
    graph_category App
    graph_title Passenger memory stats
    graph_vlabel count
     
    memory.label memory
    END
      exit 0
    end
     
    def output_values
      status = `sudo /usr/bin/passenger-memory-stats | tail -1`
      unless $?.success?
        $stderr.puts "failed executing passenger-memory-stats"
        exit 1
      end
      status =~ /(\d+\.\d+)/
      puts "memory.value #{$1}"
    end
     
    if ARGV[0] == "config"
      output_config
    else
      output_values
    end
    



Now we will link these to the active plugins, and make them executable:

    
    
    sudo chmod +x /usr/share/munin/plugins/passenger_status
    sudo chmod +x /usr/share/munin/plugins/passenger_memory_status
    sudo ln -s /usr/share/munin/plugins/passenger_status /etc/munin/plugins/passenger_status
    sudo ln -s /usr/share/munin/plugins/passenger_memory_status /etc/munin/plugins/passenger_memory_status
    



Last thing we need to do is make sure those scripts run as the munin user:

    
    
    sudo vi /etc/munin/plugin-conf.d/munin-node
    



    
    
    [passenger_*]
    user munin
    command ruby %c
    



Restart the munin node, and wait and you should see the graphs start to propagate.

    
    
    sudo /etc/init.d/munin-node restart
    



For even more detailed performance analytics, checkout [NewRelic](http://www.newrelic.com/) monitoring. And thanks to [Dan Mange](http://www.dcmanges.com/blog/rails-application-visualization-with-munin) for the munin scripts.
