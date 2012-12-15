---
comments: true
date: 2009-07-22 12:12:03
layout: post
slug: subversion-repository-creation-script
title: Subversion repository creation script
wordpress_id: 166
categories:
- sysadmin
---

Here is a simple script I use to create subversion repositories and setup common hook scripts. This assumes you are making svn available through an HTTPS/Apache/DAV.

My directory svn structure looks like the following:


    
    
    $ tree -L 2 /home/svn
    
    /home/svn
    |-- conf
    |   |-- permissions.conf
    |   `-- mailer.conf
    |-- repos
    |   |-- repo1
    |   |-- repo2
    |   `-- repo3 
    `-- scripts
        |-- post-commit
        |-- pre-commit
        `-- svncreate.sh
    



There are 3 main directories:

**repos** - This is where the actual subversion repositories are stored
**scripts** - Various scripts, including the following creation script, and also various hook scripts that repositories can symlink to
**conf** - Various configuration files that might contain mailer configuration or repository permissions(both outside the scope of this article)

The following script will create the new repository, set proper user and permissions, symlink common pre and pos commit scripts, and then make the initial import that contains the trunk/branches/tags structure.


    
    
    #!/bin/bash
    
    REPOS_URL=https://svn.example.com
    REPOS_PATH=/home/svn/repos
    SCRIPTS_PATH=/home/svn/scripts
    APACHE_USER=www-data
    
    SVNADMIN=`which svnadmin`
    EXPECTED_ARGS=1
    E_BADARGS=65
    REPO=$1
    
    if [ $# -ne $EXPECTED_ARGS ]
    then
      echo "Usage: $0 reponame"
      exit $E_BADARGS
    fi
    
    $SVNADMIN create --fs-type fsfs $REPOS_PATH/$REPO
    
    rm -rf /tmp/subversion-layout/
    mkdir -pv /tmp/subversion-layout/{trunk,branches,tags}
    
    ln -s $SCRIPTS_PATH/pre-commit $REPOS_PATH/$1/hooks/pre-commit
    ln -s $SCRIPTS_PATH/post-commit $REPOS_PATH/$1/hooks/post-commit
    
    chown $APACHE_USER:$APACHE_USER -R $REPOS_PATH/$1
    chmod -R 2775 $REPOS_PATH/$1
    
    svn import -m "Initial Import" /tmp/subversion-layout/ $REPOS_URL/$REPO
    rm -rf /tmp/subversion-layout/
    



As you root you just run it as **/home/svn/scripts/svncreate.sh _reponame_**

