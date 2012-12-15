---
comments: true
date: 2010-01-12 19:47:51
layout: post
slug: how-to-keep-your-vim-plugins-up-to-date
title: How to keep your Vim Plugins up to date
wordpress_id: 609
categories:
- vim
tags:
- vim
---

It's not too hard to learn something new everyday about vim, but did you know there is an easy way to keep your plugins up-to-date? [GetLatestVimScripts](http://www.vim.org/scripts/script.php?script_id=642) is a plugin that can do just that. You can grab the latest version from the webpage, but it's most likely your distributions vim package already has it (Debian, Redhat, OSX, and MacPorts do anyway - check _/usr/share/vim/vim72/plugin_).

How does it know where to find updates? Either we manually add information about each of our plugins to a special config file, or plugin authors can embed a special comment in their scripts to be update friendly:


    
    
    $ head ~/.vim/plugin/rails.vim 
    




    
    
    " rails.vim - Detect a rails application
    " Author:       Tim Pope vimNOSPAM@tpope.info
    <b>" GetLatestVimScripts: 1567 1 :AutoInstall: rails.vim</b>
    " URL:          http://rails.vim.tpope.net/
    
    " Install this file as plugin/rails.vim.  See doc/rails.txt for details. (Grab
    ...
    



The bold-ed line will tell the plugin where to find updates. More on that in a minute. First lets create the directory where updates will be downloaded, and a configuration file will be placed:


    
    
    mkdir ~/.vim/GetLatest
    touch ~/.vim/GetLatest/GetLatestVimScripts.dat
    



By default the plugin will only download the updates and not install them. To enable auto-install put the following in your .vimrc:


    
    
    let g:GetLatestVimScripts_allowautoinstall=1
    



Now run **:GetLatestVimScripts** or **:GLVS**. Vim will analyze your plugins, see if they contain information about their download location, and add it to the .dat file. Then it will _wget_ the plugins and install them. If you had any plugins that were update friendly, they are now updated to the latest version! Since not all plugins are update friendly, you may have to manually add lines to the _GetLatest/GetLatestVimScripts.dat_. The format looks like this:


    
    
    ScriptID SourceID Filename
    --------------------------
    294 10110 :AutoInstall: Align.vim
    1896 7356 :AutoInstall: allml.vim
    1066 7618 :AutoInstall: cecutil.vim
    1984 11852 :AutoInstall: FuzzyFinder
    1984 11852 :AutoInstall: fuzzyfinder.vim
    1567 11920 :AutoInstall: rails.vim
    1697 8283 :AutoInstall: surround.vim
    



The first two lines act as comments but are required, so don't remove them! Next is the **ScriptID** which is the _script_id_ url parameter on the plugin's vim.org webpage (ex: http://www.vim.org/scripts/script.php?**script_id=642**). Then there is the **SourceID** which is a url parameter which identifies the version of the plugin (ex: http://www.vim.org/scripts/download_script.php?**src_id=8283**). The ScriptID is what is compared for newer versions. If you are adding a new plugin, you can just set it to **1**, run an update, and the number will automatically be set to the latest version. **:AutoInstall:** is a flag that signifies the update should be installed after download, and lastly **Filename** is just the filename of the plugin.

[GetLatestVimScripts.dat](http://github.com/anveo/vimfiles/blob/master/GetLatest/GetLatestVimScripts.dat) is an example of my update configuration. Also checkout my [vimfiles](http://github.com/anveo/vimfiles) and [dotfiles]() git repos for more vim and shell scripts you might find useful!



