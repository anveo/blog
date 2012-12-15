---
comments: true
date: 2009-07-20 19:49:17
layout: post
slug: bash-script-to-create-mysql-database-and-user
title: Bash script to create MySQL database and user
wordpress_id: 170
categories:
- mysql
---

Here is a little script I made to quickly and easily create users and databases for MySQL. I only use this for development, for actual deployed applications you would probably want to be more specific about the privileges given:


    
    
    #!/bin/bash
    
    EXPECTED_ARGS=3
    E_BADARGS=65
    MYSQL=`which mysql`
    
    Q1="CREATE DATABASE IF NOT EXISTS $1;"
    Q2="GRANT ALL ON *.* TO '$2'@'localhost' IDENTIFIED BY '$3';"
    Q3="FLUSH PRIVILEGES;"
    SQL="${Q1}${Q2}${Q3}"
    
    if [ $# -ne $EXPECTED_ARGS ]
    then
      echo "Usage: $0 dbname dbuser dbpass"
      exit $E_BADARGS
    fi
    
    $MYSQL -uroot -p -e "$SQL"
    



To use it, just run:


    
    
    ./createdb testdb testuser secretpass
    



That command would create a database named _testdb_, and user _testuser_ with the password of _secretpass_.
