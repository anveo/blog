---
comments: true
date: 2009-08-05 13:59:15
layout: post
slug: using-a-sane-user-agent-for-ubuntus-firefox-3-5-shiretoko
title: Using a sane user-agent for Ubuntu's Firefox 3.5 - Shiretoko
wordpress_id: 202
categories:
- desktop
- linux
tags:
- ubuntu
---

Ubuntu's current release version of Firefox 3.5 is named Shiretoko and sends a user-agent of Shiretoko/3.5 rather than Firefox/3.5. This broke a number of sites I use that rely on browser sniffing such as Facebook Chat and DailyMotion. There are two ways to adjust this behavior:

1) Type **about:config** in the address bar. Search for 'general.useragent.extra.firefox'. Double click "Shiretoko/3.5" replace it with "Firefox/3.5"

2) Use the [User Agent Switcher](https://addons.mozilla.org/en-US/firefox/addon/59) plugin. This I prefer this option as it also lets me set IE user agents so I can use a few sites that think they require IE, and also set iPhone header's for development.
