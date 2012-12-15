---
comments: true
date: 2009-07-13 17:41:28
layout: post
slug: chkdsk-and-grub
title: chkdsk and Grub
wordpress_id: 27
categories:
- linux
- sysadmin
tags:
- chkdsk
- grub
- linux
- ubuntu
---

Recently I used GParted to resize an NTFS disk to dual boot Ubuntu and Windows XP. I finished the Ubuntu installation and everything seemed to be working fine until I tried to boot back into XP. Windows reported there might be disk corruption, ran chkdsk, and chkdsk ended up freezing. I rebooted again and saw that the grub bootloader was now also freezing. Delightful. Although I didn't think chkdsk modified the MBR, upon further research in some cases it does(when run with the /r switch) and in this case ends up corrupting the MBR. To fix this issue you can perform the following:

Boot with an Ubuntu Live CD and open up a terminal.

    
    
    sudo grub
    
    grub> find /boot/grub/stage1


Note the hd_x_ number and partition number to it's right. Now type the following commands into the grub prompt:

    
    grub> root (hdx, y)
    
    grub> setup (hdx)
    
    grub> quit


Note whitespace is important here. Now you can reboot. When Windows asks to run chkdsk hit a key to cancel. Once in Windows, open a command prompt and type:

    
    chkntfs /c c:


This will schedule a disk check on reboot that will not alter the MBR. Reboot and allow the disk check to complete. It may automatically reboot your system again, but once that is finished both OS's should boot fine from now on.
