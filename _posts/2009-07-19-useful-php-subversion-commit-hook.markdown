---
comments: true
date: 2009-07-19 12:02:26
layout: post
slug: useful-php-subversion-commit-hook
title: Useful PHP Subversion Commit Hook
wordpress_id: 71
categories:
- php
- sysadmin
tags:
- php
- svn
---

Here is a subversion pre-commit hook script we use on PHP projects to make sure the developer making the commit is providing a meaningful description, and then PHP lint is run on each PHP script to make sure it will compile correctly.


    
    
    #!/bin/bash
    
    REPOS="$1"
    TXN="$2"
    
    PHP="/usr/bin/php"
    SVNLOOK="/usr/bin/svnlook"
    AWK="/usr/bin/awk"
    GREP="/bin/egrep"
    SED="/bin/sed"
    
    CHANGED=`$SVNLOOK changed -t "$TXN" "$REPOS" | $AWK '{print $2}' | $GREP \\.php$`
    
    for FILE in $CHANGED
    do
        MESSAGE=`$SVNLOOK cat -t "$TXN" "$REPOS" "$FILE" | $PHP -l`
        if [ $? -ne 0 ]
        then
            echo 1>&2
            echo "***********************************" 1>&2
            echo "PHP error in: $FILE:" 1>&2
            echo `echo "$MESSAGE" | $SED "s| -| $FILE|g"` 1>&2
            echo "***********************************" 1>&2
            exit 1
        fi
    done
    
    # Make sure that the log message contains some text.
    SVNLOOKOK=1
    SVNLOOK=/usr/bin/svnlook
    $SVNLOOK log -t "$TXN" "$REPOS" | \
       grep "[a-zA-Z0-9]" > /dev/null || SVNLOOKOK=0
    if [ $SVNLOOKOK = 0 ]; then
      echo Empty log messages are not allowed. Please provide a proper log message. 1>&2
      exit 1
    fi
    
    # Make sure text might be meaningful
    LOGMSGLEN=$($SVNLOOK log -t "$TXN" "$REPOS" | grep [a-zA-Z0-9] | wc -c)
    if [ "$LOGMSGLEN" -lt 6 ]; then
      echo -e "Please provide a meaningful comment when committing changes." 1>&2
      exit 1
    fi
    
    # All checks passed, so allow the commit.
    exit 0
    
