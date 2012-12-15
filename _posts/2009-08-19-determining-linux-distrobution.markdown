---
comments: true
date: 2009-08-19 12:00:40
layout: post
slug: determining-linux-distrobution
title: Determining linux distribution
wordpress_id: 284
categories:
- linux
- sysadmin
---

I work with a wide variety of client server deployments, and sometimes it isn't obvious(via uname) what distribution and version a server is running. Here is a quick list of common files which contain that information:


    
    
    Debian          /etc/debian_release, /etc/debian_version,
    Fedora          /etc/fedora-release
    Gentoo          /etc/gentoo-release
    Mandrake        /etc/mandrake-release
    Novell SUSE     /etc/SUSE-release
    Red Hat         /etc/redhat-release, /etc/redhat_version
    Slackware       /etc/slackware-release, /etc/slackware-version
    Solaris/Sparc   /etc/release
    Sun JDS         /etc/sun-release
    Ubuntu          /etc/lsb-release
    UnitedLinux     /etc/UnitedLinux-release
    Yellow dog      /etc/yellowdog-release
    
