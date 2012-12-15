---
comments: true
date: 2009-10-29 15:35:49
layout: post
slug: ubuntu-9-10-karmic-koala-and-broadcom-bcm4312
title: Ubuntu 9.10 (Karmic Koala) and Broadcom BCM4312
wordpress_id: 565
categories:
- desktop
- linux
- ubuntu
tags:
- karmic
- ubuntu
---

Ubuntu 9.10 (Karmic Koala) launched today and I figured it was time to do an install from scratch onto my Dell D830 Latitude laptop. Everything went quite smoothly but when it started up I noticed two issues:

**Problem 1: No wireless**

I know the Broadcom card inside the laptop isn't the greatest, but the last two Ubuntu releases it has worked out of the box. The following command enabled the card after a reboot:


    
    
    sudo apt-get install bcmwl-kernel-source
    



**Problem 2: Really slow DNS lookups (because of IPV6)**

As [documented on Launchpad](https://bugs.launchpad.net/ubuntu/+source/network-manager/+bug/417757), there still doesn't seem to be an official fix. Strangely disabling IPV6 in _/etc/sysctl.conf_ didn't solve anything, however disabling it in Firefox at least fixes the issue in the browser. Just type **about:config** in the address bar, and set **network.dns.disableIPv6** to **false**.

Otherwise things seem to be working well, although I don't understand why they stick with a color scheme that looks like mud.
