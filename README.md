# Translink

[![Build Status](https://secure.travis-ci.org/tatey/translink.png)](http://travis-ci.org/tatey/translink)

[Translink](http://translink.com.au/) (Organisation) coordinates public transport operations in
South-East Queensland. Their website has an abundance of data with no easy way for a developer
to query it.

Translink (Program) scrapes bus routes, trips, stops and times into a relational database. 
Data is sourced from the [Translink website](http://translink.com.au/).You should be 
aware their data is protected by [copyright](http://translink.com.au/site-information/legal/copyright).

## Installation

Translink requires Ruby 1.9.2 or greater. For documentation on how to install Ruby on your
platform, visit the [Download Ruby](http://www.ruby-lang.org/en/downloads/) page.

Translink is available as a gem. On UNIX-like platforms, install translink from the command line.

    $ [sudo] gem install translink

## Usage

Scrape all bus stops, routes and services for Thursday, 24 November 2011 saving
them into a SQLite database named "2011-11-24.sqlite3" in the current working directory.

    $ translink scrape 2011-11-24

Change the path to the SQLite database.

    $ translink scrape 2011-11-24 --uri=sqlite:///Users/Tate/Downloads/translink.sqlite3

## Queries

Stops the 130 visits on the outbound trip.

    SELECT DISTINCT(stops.id), stops.stop_name, stops.stop_lat, stops.stop_lon FROM routes
    INNER JOIN trips ON trips.route_id = routes.id
    INNER JOIN stop_times ON stop_times.trip_id = trips.id
    INNER JOIN stops ON stop_times.stop_id = stops.id
    WHERE routes.short_name = '130' AND trips.direction = 'outbound';

Routes that visit the 'Calam Rd near Honeywood St' stop.

    SELECT DISTINCT(routes.id), short_name FROM stops
    INNER JOIN stop_times ON stop_times.stop_id = stops.id
    INNER JOIN trips ON stop_times.trip_id = trips.id
    INNER JOIN routes ON routes.id = trips.route_id
    WHERE stops.stop_name = 'Calam Rd near Honeywood St';

## Schema

![Class Analysis Diagram](https://github.com/tatey/translink/raw/master/doc/schema.png)

## Contributing

1. Fork it
2. Install dependancies (`bundle install`)
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Run tests (`rake test`)
5. Commit your changes (`git commit -am 'Added some feature'`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create new Pull Request

## Copyright

Copyright © 2011 Tate Johnson. Released under the MIT license. See LICENSE.
