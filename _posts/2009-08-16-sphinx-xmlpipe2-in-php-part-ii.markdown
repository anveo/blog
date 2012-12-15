---
comments: true
date: 2009-08-16 22:41:28
layout: post
slug: sphinx-xmlpipe2-in-php-part-ii
title: 'Sphinx xmlpipe2 in PHP: Part II'
wordpress_id: 251
categories:
- php
- sphinx
tags:
- xmlpipe2
---

In the [last article](http://jetpackweb.com/blog/2009/08/16/sphinx-xmlpipe2-in-php-part-i/) we successfully created a PHP class that outputs XML as input for Sphinx's indexer. However it was incredibly inefficient as we had to hold everything in memory. Here is an updated class that extends [XMLWriter](http://www.php.net/manual/en/book.xmlwriter.php), which is a built in PHP class that is essentially undocumented and works great for creating memory efficient streams of XML data. Rather than keeping each document in memory, XMLWriter will allow us to immediately flush that document's XML elements to standard output.


    
    
     false,
        );
        $options = array_merge($defaults, $options);
    
        // Store the xml tree in memory
        $this->openMemory();
    
        if($options['indent']) {
          $this->setIndent(true);
        }
      }
    
      public function setFields($fields) {
        $this->fields = $fields;
      }
    
      public function setAttributes($attributes) {
        $this->attributes = $attributes;
      }
    
      public function addDocument($doc) {
        $this->startElement('sphinx:document');
        $this->writeAttribute('id', $doc['id']);
    
        foreach($doc as $key => $value) {
          // Skip the id key since that is an element attribute
          if($key == 'id') continue;
    
          $this->startElement($key);
          $this->text($value);
          $this->endElement();
        }
    
        $this->endElement();
        print $this->outputMemory();
      }
    
      public function beginOutput() {
    
        $this->startDocument('1.0', 'UTF-8');
        $this->startElement('sphinx:docset');
        $this->startElement('sphinx:schema');
    
        // add fields to the schema
        foreach($this->fields as $field) {
          $this->startElement('sphinx:field');
          $this->writeAttribute('name', $field);
          $this->endElement();
        }
    
        // add attributes to the schema
        foreach($this->attributes as $attributes) {
          $this->startElement('sphinx:attr');
          foreach($attributes as $key => $value) {
            $this->writeAttribute($key, $value);
          }
          $this->endElement();
        }
    
        // end sphinx:schema
        $this->endElement();
        print $this->outputMemory();
      }
    
      public function endOutput()
      {
        // end sphinx:docset
        $this->endElement();
        print $this->outputMemory();
      }
    }
    



We can use it as follows:


    
    
    $doc = new SphinxXMLFeed();
    
    $doc->setFields(array(
      'title',
      'teaser',
      'content',
    ));
    
    $doc->setAttributes(array(
      array('name' => 'blog_id', 'type' => 'int', 'bits' => '16', 'default' => '0'),
    ));
    
    $doc->beginOutput();
    
    foreach(range(1, 1000) as $id) {
      $doc->addDocument(array(
        'id' => $id,
        'blog_id' => rand(1, 10),
        'title' => "Article Part {$id}",
        'teaser' => "Article {$id} teaster",
        'content' => "Article {$id} content",
      ));
    }
    
    $doc->endOutput();
    



As you can see the first thing we need to do is populate the **fields** and **attributes**. Once that is done, we call _beginOutput_, that will create the head of the XML document. After each document is added, the document's xml markup is immediately outputted and the memory buffer is cleared.

Finally we call _endOutput_, which will close the **sphinx:docset** element.

I have used this class in production to index millions of records that take up dozens of gigabytes. Keep in mind if you are working with that much data, you will probably need to bach your queries so you are not loading all the records at once!
