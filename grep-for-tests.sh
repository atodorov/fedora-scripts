#!/bin/bash

################################################################################
#
#   Copyright (c) 2013, Alexander Todorov <atodorov@redhat.com>
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
################################################################################
#
# Expands src.rpm packages and inspect them for test/ or tests/ directories to 
# provide a rough estimate of how many packages have upstream test suites.
# Operates on pwd if no arguments given.
#
################################################################################

SEARCH_IN=`pwd`

if [ -n "$1" ]; then
    SEARCH_IN="$1"
fi

for f in `find $SEARCH_IN -name "*.src.rpm"`; do
    # extract the sources
    rpmbuild -bp $f

    BUILD_DIR=`basename $f | sed -r 's/.fc20.src.rpm//' | rev | cut -f2- -d- | rev`
    pushd "~/rpmbuild/BUILD/$BUILD_DIR"
    find -type f | egrep "test/|tests/";
    if [ $? == 0 ]; then # grep matched something
        echo "^^^^^ $f"
    fi
    popd

    rm -rf "$BUILD_DIR" # to save space
done
