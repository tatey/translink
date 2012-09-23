# Changelog

## Current

* Update Mechanize to 2.5.1.
* Add version command. Prints the current version.
* Drop auto incrementing primary keys.
* Add uniqueness constraints to primary keys.
* Rename routes.id -> routes.route_id. Type changed to TEXT. Value is short name provided by Translink.
* Rename trips.id -> trips.trip_id. Value is trip id provided by Translink.
* Rename stops.id -> stops.stop_id. Type changed to TEXT. Value is stop id provided by Translink.
* Primary key on stop_times is now composite of stop_times.arrival_time, stop_times.trip_id and stop_times.stop_id.
* Change Page::Route#trip_pages to only return trips for the given date.
* Schema is created with SQL as opposed to DM's automatic migrations.
* Change short name for some routes. CGLD -> CityGlider, LOOP -> City Loop and SHLP -> Spring Hill City Loop.
* Some routes and stop times have duplicates. Only persist unique sets.
* Add exception handling. Retry HTTP requests with bad responses.
* Enforce integiry with foreign key constraints.

## 2012-07-21 / v2.0.0

* Add headsign column to trips table.
* Direction column distinguishes between travelling in one direction (Regular)
  and opposite direction (Goofy).
* Headsign column is a human readable name for the given direction. Eg "Inbound".

## 2012-06-26 / v1.0.0

* Compatibility with Translink website (2012-05-29).
* Changed schema to conform with General Transit Feed Specification.
* Stops include latitude and longitude fields.
* Help command always gives working example.

## 2012-03-15 / v0.0.1

* Initial release.
