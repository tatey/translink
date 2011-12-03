# NOTE

This project is a work-in-progress. Use with caution. It may be available as a gem in the future.

# Translink

[Translink](http://translink.com.au/) (Organisation) coordinates public transport operations in 
Brisbane. Their website has an abundance of data with no easy way for a developer
to query it.

Translink (Program) imports bus routes and service times into a nicely structured
database. Data is sourced from the [Translink website](http://translink.com.au/). You should be aware their 
data is protected by [copyright](http://translink.com.au/site-information/legal/copyright).

## Usage

Import all bus routes and services for Thursday, 24 November 2011 saving them into a 
SQLite database named "2011-11-24.sqlite3" in the current working directory.

    $ translink import 2011-11-24
    
### Options

Change the path to the SQLite database.

    $ translink import 2011-11-24 --uri="sqlite:///Users/Tate/Downloads/translink.sqlite3"

Prefer not to use SQLite? Translink is compatible with any adapter supported by
[DataMapper](http://datamapper.org/). Specify a URI to your favourite database server.

    $ translink import 2011-11-24 --uri="postgres://user:secret@127.0.0.1/translink"
    
## Schema

![Class Analysis Diagram](http://f.cl.ly/items/0p2m0k3U1I2Z1d0c0g1V/translink_schema.png)

## Copyright

Copyright © 2011 Tate Johnson. Released under the MIT license. See LICENSE.
