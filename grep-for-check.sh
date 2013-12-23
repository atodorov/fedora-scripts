#!/bin/bash

##############################################
#
# Inspect all .spec files for %check section
#
##############################################

SEARCH_IN=`pwd`

if [ -n "$1" ]; then
    SEARCH_IN="$1"
fi

for f in `find $SEARCH_IN -name "*.src.rpm"`; do
    rpm2cpio $f | cpio -i --quiet --to-stdout *.spec | grep "%check";
    if [ $? == 0 ]; then # grep matched something
        echo "^^^^^ $f"
    fi
done
