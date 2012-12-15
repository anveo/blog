---
comments: true
date: 2010-03-04 12:58:31
layout: post
slug: write-html-faster-with-sparkup-vim-and-textmate
title: Write HTML Faster with Sparkup (Vim and Textmate)
wordpress_id: 770
categories:
- textmate
- vim
tags:
- sparkup
- textmate
- vim
---

I recently came across a really great Vim(and Textmate) plug-in called [sparkup.vim](http://github.com/rstacruz/sparkup) that "lets you write HTML code faster". It's actually a small python script, but has editor plug-ins to work with Vim and Textmate. It allows us to write HTML faster by leveraging the terse css selector syntax and converting it the much more verbose HTML.



## Selector Expansion



Selector expansion is the plug-in's primary purpose. It lets you write in a CSS selector syntax that get expanded to full HTML:


    
    
    #album.photo
    



If you type that into vim and then press **Ctrl-e** on that line it will be expanded to:


    
    
    <div id="album" class="photo">|</div>
    



This next one is a bit more complicated, I'll explain what's going on:


    
    
    #container > #nav > ul > li.first {Home} + li*2 + li.last {About Us} < <  #content > p*2 < #footer > span.copyright {(c) 2010 Jetpack LLC}
    





> 

> 
> 
  
>   1. Creating a div with the id of "container"
> 
  
>   2. Creating a div with an id of "_nav_" that is a child of the "_container_" div. The > specifies we are creating a child element in the DOM tree.
> 
  
>   3. Creating a ul tag that is a child of "_nav_"
> 
  
>   4. Creating an li tag with the class name "_first_". Text in brackets will be plain text placed in-between the tag we are creating.
> 
  
>   5. Creating two sibling li elements. The **+** denotes what comes next will be a sibling. The ***** is a multiplier to create any number of similar elements.
> 
  
>   6. Creating an li tag with the class name "_last_" as a sibling to the previous li elements we have created. It will contain the text '_About Us_'.
> 
  
>   7. Next now use the **<** symbol to go up two levels of the DOM tree.
> 
  
>   8. Next we create a div with the id of "_content_" that will contain two paragraph tags.
> 
  
>   9. We go back up a level and add a footer div that will have a span with the class of "_copyright_" that contains some boilerplate copyright text.
> 





If we press **Ctrl-e** on that line, it will be expanded to the following:


    
    
      <div id="container">
        <div id="nav">
          <ul>
            <li class="first">Home</li>
            <li>|</li>
            <li></li>
            <li class="last">About Us</li>
          </ul>
        </div>
        <div id="content">
          <p></p>
          <p></p>
        </div>
        <div id="footer">
          <span class="copyright">(c) 2010 Jetpack LLC</span>
        </div>
      </div>
    



It will also place your cursor in the first empty tag denoted by the **|**. You can jump around to other empty tags with **Ctrl-n** (I change this mapping, more on that in a second).

If you are a fan of [HAML](http://haml-lang.com/) but forced to use standard HTML in your projects this plug-in might make you a bit happier.



## Shortcuts



The other piece of functionality this plug-in provides is a [snipMate](http://www.vim.org/scripts/script.php?script_id=2540) like shortcuts feature. These act much like snipMate snippets except they are hard-coded into the python script. However most are still quite useful and you can view the [python script](http://github.com/rstacruz/sparkup/blob/master/sparkup) to review them.



## Issues



After installing this plugin I was having tabbing/tab-expansion issues. I believe it's **Ctrl-n** mapping which allows you to jump around to empty tags was conflicting with some other plug-in I had installed, possibly [SuperTab](http://www.vim.org/scripts/script.php?script_id=1643). I remapped it by putting the following in my .vimrc:


    
    
    let g:sparkupNextMapping = '<c-x>'
    



That doesn't seem to conflict with anything for me, and since it only gets used in normal mode it doesn't conflict with Tim Pope's excellent [ragtag](http://github.com/tpope/vim-ragtag) plug-in ([read more on that here](http://www.catonmat.net/blog/vim-plugins-ragtag-allml-vim/)).



## Video Demonstration



Some of this might make more sense when you see it in action, so watch the following YouTube video(make sure to switch it to 720p for crisper text):





## Conclusion


Have fun writing faster HTML! You can see more examples on [sparkup's Github page](http://github.com/rstacruz/sparkup).


