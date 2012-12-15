---
comments: true
date: 2009-08-16 22:31:30
layout: post
slug: sphinx-xmlpipe2-in-php-part-i
title: 'Sphinx xmlpipe2 in PHP: Part I'
wordpress_id: 246
categories:
- php
- sphinx
tags:
- xmlpipe2
---

[Sphinx](http://www.sphinxsearch.coml) is a great open source package for implementing a full text search. Before we can use it to search, we first must inject all of our data into it. There are two primary ways of loading that data in - directly accessing the data via a sql query, or using the **xmlpipe2** format. Although using the database as a direct data source is very fast, it can sometimes be difficult to craft a query that will contain normalized data for all the fields you require in an index. The XML option gives us much more flexibility at the cost of speed(although it is still very fast). This article will deal with show you how to generate that XML. It assumed to have a basic understanding of how Sphinx works, if not [browse the docs](http://www.sphinxsearch.com/docs/current.html) first.


Lets try and encapsulate some of that logic into a PHP class:


    
    
    fields = $fields;
      }
    
      public function setAttributes($attributes) {
        $this->attributes = $attributes;
      }
    
      public function addDocument($doc) {
        $this->documents[] = $doc;
      }
    
      public function render() {
    
        // create a new XML document
        $dom = new DomDocument('1.0');
        $dom->encoding = "utf-8";
        $dom->formatOutput = true;
    
        // create root node
        $root = $dom->createElement('sphinx:docset');
        $root = $dom->appendChild($root);
    
        // create the schema
        $schema = $dom->createElement('sphinx:schema');
    
        // common fields we will be cloning
        $tmp_field = $dom->createElement('sphinx:field');
        $tmp_attr  = $dom->createElement('sphinx:attr');
    
        // add fields to the schema
        foreach($this->fields as $field) {
          $new_field = clone($tmp_field);
          $new_field->setAttribute('name', $field);
          $schema->appendChild($new_field);
        }
    
        // add attributes to the schema
        foreach($this->attributes as $attributes) {
          $new_attr = clone($tmp_attr);
          foreach($attributes as $key => $value) {
            $new_attr->setAttribute($key, $value);
            $schema->appendChild($new_attr);
          }
        }
    
        // add the schema to the document
        $root->appendChild($schema);
    
        // go through each document
        foreach($this->documents as $doc) {
          $node = $dom->createElement('sphinx:document');
          $node->setAttribute('id', $doc['id']);
    
          foreach($doc as $key => $value) {
            if($key == 'id') continue;
            $tmp = $dom->createElement($key);
            $tmp->appendChild($dom->createTextNode($value));
    
            $node->appendChild($tmp);
          }
    
          // add the document to the dom
          $root->appendChild($node);
        }
    
        // return xml text
        return $dom->saveXML();
      }
    }
    



The previous code uses PHP's DomDocument interface because that is less error prone than manually echo'ing out XML tags. One downside of using DomDocument is we must build the entire XML tree before we can output it. This means we must keep each document in memory, so if you are indexing a large amount of data you will probably hit PHP's memory limit. We will fix this in the next article. For now, you can use this class as follows:


    
    
    // instantiate the class
    $doc = new SphinxXMLFeed();
    
    // set the fields we will be indexing
    $doc->setFields(array(
      'title',
      'teaser',
      'content',
    ));
    
    // set any attributes
    $doc->setAttributes(array(
      array('name' => 'blog_id', 'type' => 'int', 'bits' => '16', 'default' => '0'),
    ));
    
    // generate some random document. These would usually be pulled from a database
    // or other data source
    foreach(range(1, 3) as $id) {
      $doc->addDocument(array(
        'id' => $id,
        'blog_id' => rand(1, 10),
        'title' => "Article Part {$id}",
        'teaser' => "Article {$id} teaster",
        'content' => "Article {$id} content",
      ));
    }
    
    // Render the XML
    $doc->render();
    



That code will generate the following XML:


    
    
    
    <sphinx:docset>
      <sphinx:schema>
        <sphinx:field name="title"></sphinx:field>
        <sphinx:field name="teaser"></sphinx:field>
        <sphinx:field name="content"></sphinx:field>
        <sphinx:attr default="0" bits="16" type="int" name="blog_id"></sphinx:attr>
      </sphinx:schema>
      <sphinx:document id="1">
        <blog_id>6</blog_id>
        <title>Article Part 1</title>
        <teaser>Article 1 teaster</teaser>
        <content>Article 1 content</content>
      </sphinx:document>
      ...
    </sphinx:docset>
    



You would setup you datasource in sphinx.conf something like this:


    
    
    source xml_blog_posts
    {
        type = xmlpipe
        xmlpipe_command = /usr/bin/php /home/example.com/lib/tasks/sphinx_blogs.php
    }
    



Don't forget to checkout the next article where we optimize this class to handle millions of records!

Continue to next article: Sphinx xmlpipe2 in PHP: Part II


