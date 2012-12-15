---
comments: true
date: 2011-06-12 11:51:53
layout: post
slug: manage-your-third-party-chef-cookbooks-with-knife-github-cookbooks
title: Manage your third-party Chef cookbooks with knife-github-cookbooks
wordpress_id: 948
categories:
- chef
- git
---

## The Problem



For those using [chef](http://wiki.opscode.com/display/chef/Home) to automate your server infrastructure you probably find managing third-party cookbooks to be a pain. Ideally I want to make custom changes to a cookbook while still being able to track for upstream enhancements.

A few techniques I see being used are:

**no tracking:** Manually download an archive from github or opscode community and drop it in your cookbooks/ directory. Easy to make custom changes but you have no automated way to check for updates.

**git submodules:** This tracks upstream well, but unless you own the repo you can't make changes.

**fork it:** Since pretty much all cookbooks reside on github, so you can fork a copy. This works, but now you might have dozens of different repos to manage. And checking for updates means going into each repo and manually merging in enhancements from the upstream.

**knife vendor:** Now we are getting somewhere. Chef's knife command has functionality for dealing with third-party cookbooks. It looks something like this:


    
    
    knife cookbook site vendor nginx
    



This downloads the nginx cookbook from the opscode community site, puts an unmodified copy in a _chef-vendor-nginx_ git branch, and then puts a copy in your cookbooks/nginx dir in your master branch. When you run the install again it will download the updated version into the chef-vendor-nginx branch, and then merge that into master.

This is a good start, but it has a number of problems. First you are restricted to using what is available on the [opscode community site](http://community.opscode.com/cookbooks). Second, although this seems like a git-centric model, knife is actually downloading a .tar.gz file. In fact if you visited the [nginx cookbook page](http://community.opscode.com/cookbooks/nginx) you would see it only offers an archive download, no way to inspect what this cookbook actually provides before installing.

There is a sea of great high-quality cookbooks on github. Since we all know and love git it would be great if we could get the previous functionality but using git repositories as a source instead.



## A Solution



Enter [knife-github-cookbooks](https://github.com/websterclay/knife-github-cookbooks). This gem enhances the knife command and lets us get the above functionality by pulling from github rather than downloading from opscode. To use it just install the gem and run:


    
    
    knife cookbook github install cookbooks/nginx
    



By default it assumes a _username_/repo from github. So for each cookbook you install you will have a _chef-vendor-cookbookname_ branch storing the upstream copy and a _cookbooks/cookbook-name_ directory in your master branch to make local changes to.

If you want to check for upstream changes:


    
    
    knife cookbook github compare nginx
    



That will launch a github compare view. You can even pass this command a different user who has forked the repo and see or merge in changes from that fork! Read more about it on the [github page](https://github.com/websterclay/knife-github-cookbooks).

One thing to keep in mind is this gem doesn't pull in required dependencies automatically, so you will have to make sure you download any requirements a cookbook might have. You can check what dependencies a cookbook requires by inspecting the metadata files.



## Bonus Tip!



Opscode has a github repository full of recipes you probably want to use ([opscode/cookbooks](https://github.com/opscode/cookbooks)). Unfortunately using this repository would mean pulling in *all* of those cookbooks. That just clutters up your chef project with cookbooks you don't need. Luckily there is [https://github.com/cookbooks](https://github.com/cookbooks)! This repository get updated daily and separates each _opscode/cookbook_ cookbook into a separate git repository.

Now you can cherry-pick the cookbooks you want, and manage them with [knife-github-cookbooks](https://github.com/websterclay/knife-github-cookbooks)!
