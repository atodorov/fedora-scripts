#!/bin/bash

################################################################################
#
#   Copyright (c) 2013-2014, Alexander Todorov <atodorov@redhat.com>
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
    ./tools/extract-srpm $f ~/rpmbuild/BUILD >/dev/null 2>&1

    find ~/rpmbuild/BUILD/ -type f | egrep "SelfTest/|test/|tests/|/t/|testing/|test_utils/|tests_utils/|testsuite/|tests.py|test.py|test_regex.py"
    if [ $? == 0 ]; then # grep matched something
        echo "^^^^^ $f"
    fi

    rm -rf ~/rpmbuild/ # clean up
done
