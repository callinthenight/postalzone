#!/bin/bash
#
# This file is a simple sanity test for postal_tz.csv.
# It is run automatically on make.

OUT=$1
if [ "$OUT" = "" ]; then
	echo "usage: test.sh <postal_tz.csv>"
	exit 1
fi

WANT=$(cat <<EOF
US,50322,Urbandale,America/Chicago
US,07506,Hawthorne,America/New_York
CA,T1L,Banff,America/Edmonton
US,00778,Gurabo,America/Puerto_Rico
PR,00778,Gurabo,America/Puerto_Rico
EOF)

OK=true

for line in $WANT
do
	grep -q "^$line$" $OUT
	if [ $? -ne 0 ]; then
		echo "$line not found in $OUT"
		OK=false
	fi
done

if [ "$OK" = false ]; then
	echo
	echo "FAIL $OUT"
	exit 1
fi

echo "OK $OUT"
