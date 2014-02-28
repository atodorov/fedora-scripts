#!/bin/bash

################################################################################
#
#   Copyright (c) 2014, Alexander Todorov <atodorov@redhat.com>
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
# Query the URL fiels from all .rpm packages and do a basic validity check.
# Operates on pwd if no arguments given.
#
################################################################################

SEARCH_IN=`pwd`

if [ -n "$1" ]; then
    SEARCH_IN="$1"
fi

for f in `find $SEARCH_IN -name "*.rpm"`; do
    URL=`rpm -qp --qf "%{url}\n" $f`
    RESPONSE=`curl -I "$URL" 2>/dev/null | grep HTTP`
    echo "$RESPONSE     $URL    $f"
done
