---
comments: true
date: 2011-02-08 14:54:46
layout: post
slug: io-language-addons-and-making-them-work-in-ubuntu
title: Io Language Addons (and making them work in Ubuntu)
wordpress_id: 899
categories:
- io-language
- ubuntu
---

My [last post](http://jetpackweb.com/blog/2011/02/05/installing-the-io-language-in-ubuntu/) detailed how to compile the Io language from source and install it in Ubuntu (10.10 Maverick). Io has a growing set of addons such as GUI's, sound and image manipulation, OpenGL, and database support to name a few. However they will not be enabled if you don't have the proper development libraries installed.

I'll go through a couple of addons in this article, but if you just want to make sure you have as many dependencies as possible to run the addons here is a line you can paste:

    
    $ sudo apt-get install build-essential cmake libreadline-dev libssl-dev ncurses-dev libffi-dev zlib1g-dev libpcre3-dev libpng-dev libtiff4-dev libjpeg62-dev python-dev libpng-dev libtiff4-dev libjpeg62-dev libmysqlclient-dev libmemcached-dev libtokyocabinet-dev libsqlite3-dev libdbi0-dev libpq-dev libgmp3-dev libogg-dev libvorbis-dev libtaglib-cil-dev libtag1-dev libtheora-dev libsamplerate0-dev libloudmouth1-dev libsndfile1-dev libflac-dev libgl1-mesa-dev libglu1-mesa-dev freeglut3-dev libxmu-dev libxi-dev libxml2-dev libyajl-dev uuid-dev liblzo2-dev zlib1g-dev



You will need to rebuild Io once these are all installed.

I would encourage you to browse the addons/* directory in the Io source tree. There are many good useful addons and samples, although unfortunately there are few that do not seem to currently work or are missing samples, so dust off that book on C :)


## Sockets



    
    sudo apt-get install libevent-dev


Here is a minimal webserver using sockets:

    
    WebRequest := Object clone do(
        cache := Map clone
        handleSocket := method(socket, server,
            socket streamReadNextChunk
            if(socket isOpen == false, return)
            request := socket readBuffer betweenSeq("GET ", " HTTP")         
    
            data := cache atIfAbsentPut(request,
                writeln("caching ", request)
                f := File clone with(request)
                if(f exists, f contents, nil)
            )                                                                
    
            if(data,
                socket streamWrite("HTTP/1.0 200 OK\n\n")
                socket streamWrite(data)
            ,
                socket streamWrite("Not Found")
            )                                                                
    
            socket close
            server requests append(self)
        )
    )                                                                        
    
    WebServer := Server clone do(
        setPort(7777)
        socket setHost("127.0.0.1")
        requests := List clone
        handleSocket := method(socket,
            WebRequest handleSocket(socket, self)
        )
    ) start


Lots of other good socket based examples in addons/Socket/samples.


## Regex



    
    sudo apt-get install libpcre3-dev


That will install Perl Compatible Regular Expression support for Io. You can use it like:

    
    regex := Regex with("(?\\d+)([ \t]+)?(?\\w+)")
    match := "73noises" matchesOfRegex(regex) next




## CFFI


During the configure process you might have noticed a message saying Could NOT find FFI  (missing:  FFI_INCLUDE_DIRS).  [FFI](http://en.wikipedia.org/wiki/Foreign_function_interface) (foreign function interface) is basically a system that lets us call functions in different programming languages. First make sure you have the development libraries:

    
    $ sudo apt-get install libffi-dev


How FFI functions is very architecture and compiler dependent, and it seems debian places the includes in a location the cmake scripts aren't looking. I'm not that familiar with cmake and couldn't find a very elegant solution, so just place the following line in the modules/FindFFI.cmake script:

    
    $ vim modules/FindFFI.cmake
    
    # Add the following line
    set(FFI_INCLUDE_DIRS /usr/include/x86_64-linux-gnu)
    # Above these two
    include(FindPackageHandleStandardArgs)
    FIND_PACKAGE_HANDLE_STANDARD_ARGS(FFI DEFAULT_MSG FFI_INCLUDE_DIRS FFI_LIBRARIES)


Here is a small program that gets us direct access to libc's puts(3) function:

    
    CFFI
    
    lib := Library clone setName("libc.so.6")
    puts := Function with(Types CString) setLibrary(lib) setName("puts")
    
    puts "Hello Io!"




## Python



    
    sudo apt-get install python-dev


Want to access Python from Io?

    
    # Import a module
    sys := Python import("sys")
    
    "Which version of python are we running?" println
    sys version println
    
    "Split a string" println
    str := "Brave brave Sir Robin"
    str println
    string split(str) println
    
    "Load a C module (.so)" println
    t := Python import("time")
    
    writeln("Current time is: ", t time)




## Databases



    
    sudo apt-get install libmysqlclient-dev libmemcache-dev libtokyocabinet-dev libsqlite3-dev libdbi0-dev


Io has addons for MySQL, PostgresQL, memcached, Tokyo Cabinet, SQLite and a few others.


## Sound



    
    sudo apt-get install libgmp3-dev libogg-dev libvorbis-dev libtaglib-cil-dev libtag1-dev libtheora-dev libsamplerate0-dev libloudmouth1-dev libsndfile1-dev libflac-dev


Various sound processing libraries.


## Images



    
    $ sudo apt-get install libpng-dev libtiff4-dev libjpeg62-dev


Various image loading libraries.


## GUI



    
    $ sudo apt-get install x11proto-xf86misc-dev xutils-dev libxpm-dev libpango1.0-dev libcairo2-dev libfreetype6-dev 
    
    $ sudo apt-get install libclutter-1.0-dev libatk1.0-dev


There is also a GUI called Flux that requires OpenGL support. I wasn't able to get it working however.


## OpenGL



    
    $ sudo apt-get install libgl1-mesa-dev libglu1-mesa-dev freeglut3-dev libxmu-dev libxi-dev


Lots of great examples in addons/OpenGL/samples.


## XML and JSON



    
    $ sudo apt-get install libxml2-dev libyajl-dev


If you need to do any XML or JSON parsing.


## UUID



    
    $ sudo apt-get install uuid-dev


Support for UUID generator. Seems to be broken however.


## Misc



    
    $ sudo apt-get install libreadline-dev libssl-dev ncurses-dev libffi-dev zlib1g-dev liblzo2-dev zlib1g-dev


SSL, archives, REPL history, curses GUI.
