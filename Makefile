RED="\\033[1;31m"
CLEAR="\\033[0m"

default: test

# Download postal code DB for country code % from geonames.org
tmp/postal-%.csv.zip: tmp
	@echo $(RED) "$*: Downloading Postal Codes Database" $(CLEAR)
	curl "http://download.geonames.org/export/zip/$*.zip" > $@

# Download geonames DB for country code % from geonames.org
tmp/geonames-%.csv.zip: tmp
	@echo $(RED) "$*: Downloading Geonames Database" $(CLEAR)
	curl "http://download.geonames.org/export/dump/$*.zip" > $@

# Unzip databases
tmp/%.csv: tmp/%.csv.zip
	unzip -ap $< -x readme.txt > $@

# Import into spatialite and create geo index
tmp/postalzone-%.sqlite3: tmp/postal-%.csv tmp/geonames-%.csv
	rm -f $@
	@echo $(RED) "$*: Creating Geo Index" $(CLEAR)
	sed s/COUNTRY_CODE/$*/ src/import_index_geo.template.sql | spatialite $@

# Find most likely time zone for each postal code
tmp/postalzone-%.csv: tmp/postalzone-%.sqlite3
	@echo $(RED) "$*: Finding Nearest Timezones" $(CLEAR)
	sed s/COUNTRY_CODE/$*/ src/generate_postalzone.template.sql | spatialite $<

# HACK: Puerto Rico is part of the US. Include it in the US results too.
tmp/postalzone-PR_us.csv: tmp/postalzone-PR.csv
	cat $< | sed s/^PR,/US,/ > $@

# Concatenate results
output/postalzone.csv: tmp/postalzone-US.csv tmp/postalzone-CA.csv tmp/postalzone-PR.csv tmp/postalzone-PR_us.csv
	mkdir -p output
	head -n 1 $< > $@
	tail -n+2 -q $? >> $@

# Run a sanity check
test: output/postalzone.csv
	./src/test.sh $<

tmp:
	mkdir tmp

clean:
	rm -rf tmp output

.PHONY: clean default test

# keep files in case something breaks
.SECONDARY:
