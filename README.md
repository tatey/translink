# Translink

[![Build Status](https://secure.travis-ci.org/tatey/translink.png)](http://travis-ci.org/tatey/translink)

[Translink](http://translink.com.au/) (Organisation) coordinates public transport operations in
Brisbane. Their website has an abundance of data with no easy way for a developer
to query it.

Translink (Program) scrapes bus stops, routes and service times into a nicely structured
database. Data is sourced from the [Translink website](http://translink.com.au/). Only routes
with codes 100..499, GLIDER and LOOP are persisted. You should be aware their data is protected by [copyright](http://translink.com.au/site-information/legal/copyright).

## Usage

First install.

    $ [sudo] gem install translink

Then scrape all bus stops, routes and services for Thursday, 24 November 2011 saving
them into a SQLite database named "2011-11-24.sqlite3" in the current working directory.

    $ translink scrape 2011-11-24

Change the path to the SQLite database.

    $ translink scrape 2011-11-24 --uri="sqlite:///Users/Tate/Downloads/translink.sqlite3"

## Schema

![Class Analysis Diagram](https://github.com/tatey/translink/raw/master/doc/schema.png)

## Copyright

Copyright © 2011 Tate Johnson. Released under the MIT license. See LICENSE.
