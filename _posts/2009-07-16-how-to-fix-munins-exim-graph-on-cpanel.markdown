---
comments: true
date: 2009-07-16 10:57:07
layout: post
slug: how-to-fix-munins-exim-graph-on-cpanel
title: How to fix Munin's Exim Graph on cPanel
wordpress_id: 113
tags:
- cpanel
- exim
- munin
---

If you notice the Exim graphs on your server have stop updating, you might want to check /var/log/munin/munin-node.log and see if you have lots of these entries:


    
    
    tail /var/log/munin/munin-node.log
    
    ...
    Plugin "exim_mailstats" exited with status 768. ----
    ...
    



You just need to remove the state file, and the graph will start updating again. Don't worry about deleting the file, no data should be lost.


    
    rm /var/lib/munin/plugin-state/plugin-exim_mailstats.state



