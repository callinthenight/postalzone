.mode csv
.headers on
.output tmp/postalzone-COUNTRY_CODE.csv
SELECT p.countrycode, p.postalcode, p.placename, g.timezone
  FROM postal AS p
  LEFT JOIN geonames AS g
  ON (
    g.ROWID = (
      SELECT rowid
      FROM SpatialIndex
      WHERE f_table_name='geonames'
      AND search_frame=BuildCircleMbr(p.longitude, p.latitude, 0.5)
      LIMIT 1
    )
  );