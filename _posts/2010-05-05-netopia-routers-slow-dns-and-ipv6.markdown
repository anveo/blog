---
comments: true
date: 2010-05-05 12:51:34
layout: post
slug: netopia-routers-slow-dns-and-ipv6
title: Netopia Routers, Slow DNS, and IPv6
wordpress_id: 827
categories:
- linux
tags:
- ipv6
---

We have been having issues for a while where DNS lookups in Ubuntu setups have been taking significant amounts of time. We learned turning off IPv6 support in Firefox would fix the issue for that application, but we needed a system wide fix. 

It turns out the Netopia router(3347) seems to have issues with IPv6 AAAA requests when acting as a DNS proxy to our ISP. Any linux computer that was getting DNS info via DHCP was generally being affected. There is no way to fix this in the Netopia web-gui, but we can telnet into the router and twiddle some things. Run the following commands once you log in:


    
    
    configure
    set dns proxy-enable off
    save
    exit
    restart
    



Once the router restarts DNS look-ups will be quite snappy!
