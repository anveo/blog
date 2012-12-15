---
comments: true
date: 2010-02-15 12:02:08
layout: post
slug: vim-tips-for-ruby
title: Vim Tips for Ruby (and your wrists)
wordpress_id: 688
categories:
- rails
- ruby
- vim
---

Each time I am forced to type non-alpha-numeric characters during a coding session I feel that the flow and speed of my typing suffers. Not to mention depending on the size of your hands and how (im)properly you type, those keys can also put extra strain on your wrists. Since Ruby and Rails make extensive use of **:**symbols and hash-rockets ( **=>** ) I felt the need to optimize their entry. 



### **Hash-Rocket Insertion**



    
    
    " bind control-l to hashrocket
    imap <c-l> <space>=><space>"
    



This emulates TextMate's hash-rocket insertion. Just press Ctrl-L when in insert mode for a hash-rocket and leading quote to be inserted. Thanks to [TechnicalPickles](http://technicalpickles.com/posts/vimpocalypse/) for this one.

If you use this with [autoClose.vim](http://www.vim.org/scripts/script.php?script_id=1849) the trailing quote will be inserted too. There are times when you don't want  quotes surrounding the hash value like booleans and symbols, so use [surround.vim](http://www.vim.org/scripts/script.php?script_id=1697) and type **ds"**. _Poof!_ gone are the quotes.




### **Word to Symbol**



    
    
    " convert word into ruby symbol
    imap <c-k> <c-o>b:<esc>Ea
    nmap <c-k> lbi:<esc>E
    



This will turn any word into a symbol by prefixing it with a colon. It works in either Insert or Command mode. In command mode just place your cursor over the word and press Ctrl-k. While in Insert mode pressing Ctrl-k will convert the current word you are typing into a symbol.

You could probably make the argument it's easier just to type the colon.  To each his own but I have seen a lot of people who bend their right wrist to press both **Shift** and **;** entirely with their right hand which puts strain on the wrist. Since symbols are often used right before the hash-rocket, chaining these two shortcuts can be a bit more fluid IMHO(the caret denotes the cursor position):


    
    
    render action^<ctrl-k><ctrl-l>
    
    # Will be transformed to
    
    render :action => "^"
    





### **Symbol to Proc snippets**



    
    
    snippet collecta
                 collect(&:${1:symbol})${2}
    snippet mapa
                 map(&:${1:symbol})${2}
    



The **collection.collect(&:symbol)** is a great shortcut I use often in Rails, these [snipMate.vim](http://www.vim.org/scripts/script.php?script_id=2540) snippets make for less awkward entry.



### **Easy Command Mode Entry**



    
    
    " Easier non-interactive command insertion
    nnoremap <space> :
    



This one has nothing to do with Ruby, but instead of typing the colon every time to want to enter a new command in Command mode, just hit the spacebar!



### **Swap Esc and Caps-Lock**



Another tip not specific to Ruby or even Vim really. I think using the Caps-Lock key as escape in Vim is the most efficient and quickest way to cancel some commands or exit certain modes. I prefer to swap them at the Operating System level rather than .vimrc hacks because I find the switch convenient in almost all applications, not just Vim. Consult Google to find out how to do it in your OS.



### **Conclusion**



That's it! If anyone has any other vim tips for ruby I would love to hear them!  Also feel free to dig through my [dotfiles](http://github.com/anveo/dotfiles) and [vimfiles](http://github.com/anveo/vimfiles) to glean other tips.


