---
comments: true
date: 2011-02-05 11:30:32
layout: post
slug: installing-the-io-language-in-ubuntu
title: Installing the Io Language in Ubuntu
wordpress_id: 884
categories:
- bash
- io-language
- ubuntu
---

I have recently begun reading through [Bruce Tate's](http://twitter.com/#!/redrapids) fun [Seven Languages In Seven Weeks](http://www.pragprog.com/titles/btlang/seven-languages-in-seven-weeks) book. One of the chapters focuses the [Io language](http://iolanguage.com/) and it's installation can be a little bit non-standard to get it to my liking.

Generally on my development machine when I compile from source I like to install locally to my home directory rather than system wide. This way sudo privileges are not needed plus I just like the idea of keeping these items close to home.

First **Io** requires the cmake build system so make sure that is available.


    
    
    $ sudo apt-get install cmake
    



Next download and extract the source code.


    
    
    $ wget --no-check-certificate http://github.com/stevedekorte/io/zipball/master -O io-lang.zip
    $ unzip io-lang.zip
    $ cd stevedekorte-io-[hash]
    



Io provides a build script, however it is setup to install the language to /usr/local. Since I want it to go in $HOME/local you just need to modify that file. Here is a quick one liner:


    
    
    $ sed -i -e 's/^INSTALL_PREFIX="\/usr\/local/INSTALL_PREFIX="$HOME\/local/' build.sh
    



Now build and install.


    
    
    $ ./build.sh
    $ ./build.sh install
    



Since we are installing into a location our OS doesn't really know about, we need to configure a few paths.


    
    
    $ vim ~/.bashrc
    export PATH="${HOME}/local/bin:${PATH}"
    export LD_LIBRARY_PATH="${HOME}/local/lib:${LD_LIBRARY_PATH}"
    
    # You might want these too
    export LD_RUN_PATH=$LD_LIBRARY_PATH
    export CPPFLAGS="-I${HOME}/local/include"
    export CXXFLAGS=$CPPFLAGS
    export CFLAGS=$CPPFLAGS
    export MANPATH="${HOME}/local/share/man:${MANPATH}"
    



Lastly restart your shell and type 'io' and you should be dropped into Io's REPL!

A side benefit to this method is you can install anything you build into **$HOME/local**. Usually you just need to pass the _--prefix=$HOME/local_ parameter when you run a _./configure_ script.
