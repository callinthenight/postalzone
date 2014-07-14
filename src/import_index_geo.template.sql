.echo on

-- Import postal
CREATE TABLE postal (countrycode TEXT, postalcode TEXT, placename TEXT, admin1name TEXT, admin1code TEXT, admin2name TEXT, admin2code TEXT, admin3name TEXT, admin3code TEXT, latitude DOUBLE, longitude DOUBLE, accuracy INT);

.mode csv
.separator "\t"
.import "tmp/postal-COUNTRY_CODE.csv" postal

SELECT AddGeometryColumn("postal", "Geometry", 4326, "POINT", "XY");
SELECT CreateSpatialIndex("postal", "Geometry");
UPDATE postal SET Geometry=MakePoint(longitude,latitude,4326);

ANALYZE postal;

-- Import geonames
CREATE TABLE geonames (geonameid INT, name TEXT, asciiname TEXT, alternatenames TEXT, latitude DOUBLE, longitude DOUBLE, featureclass TEXT, featurecode TEXT, countrycode TEXT, cc2 TEXT, admin1code TEXT, admin2code TEXT, admin3code TEXT, admin4code TEXT, population LONG, elevation INT, gtopo30alt INT, timezone TEXT, modificationdate TEXT);

.mode csv
.separator "\t"
.import "tmp/geonames-COUNTRY_CODE.csv" geonames

SELECT AddGeometryColumn("geonames", "Geometry", 4326, "POINT", "XY");
SELECT CreateSpatialIndex("geonames", "Geometry");
UPDATE geonames SET Geometry=MakePoint(longitude,latitude,4326);

ANALYZE geonames;

VACUUM;
