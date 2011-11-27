# Translink

Scraper for http://translink.com.au/. Very much a work-in-progress. Use with caution.

## Usage

Get all routes and services for Thursday, 24 November.

    $ translink scrape 2011-11-24
    
Optionally specify the path to persist the SQLite database.

    $ translink scrape 2011-11-24 --path="/Users/Tate/Downloads/Translink 2011-11-24.db"

## Copyright

Copyright © 2011 Tate Johnson. Released under the MIT license. See LICENSE.
