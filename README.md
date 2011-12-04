# Translink

[Translink](http://translink.com.au/) (Organisation) coordinates public transport operations in 
Brisbane. Their website has an abundance of data with no easy way for a developer
to query it.

Translink (Program) imports bus stops, routes and service times into a nicely structured
database. Data is sourced from the [Translink website](http://translink.com.au/). You should be aware their 
data is protected by [copyright](http://translink.com.au/site-information/legal/copyright).

## Usage

First install all the required dependancies.

    $ bundle install

Then import all bus stops, routes and services for Thursday, 24 November 2011 saving 
them into a SQLite database named "2011-11-24.sqlite3" in the current working directory.

    $ translink import 2011-11-24
    
### Options

Change the path to the SQLite database.

    $ translink import 2011-11-24 --uri="sqlite:///Users/Tate/Downloads/translink.sqlite3"

Prefer not to use SQLite? Translink is compatible with any adapter supported by
[DataMapper](http://datamapper.org/). Translink uses Bundler for managing dependancies.
Append your favourite adapter to the Gemfile.

    gem 'dm-postgres-adapter'

Install the new adapter.

    $ bundle install

Specify a URI to the database server.

    $ translink import 2011-11-24 --uri="postgres://user:secret@127.0.0.1/translink"
        
## Schema

![Class Analysis Diagram](https://github.com/tatey/translink/raw/master/doc/schema.png)

## Copyright

Copyright © 2011 Tate Johnson. Released under the MIT license. See LICENSE.
