PostalZone
==========

PostalZone is a Makefile for creating a postal code to time zone database.
It downloads place and time zone data from geonames.org, enters the info into
a spatial database, and finds the time zone closest to the centroid of each
postal code.

There might be errors—I haven't tested it fully—but it seems to work OK
for most postal codes. Use at your own risk.

Usage
-----
	$ make

Running make produces the database at output/postalzone.csv

Requirements
------------
spatialite

License
-------
MIT
