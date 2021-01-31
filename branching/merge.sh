#!/bin/bash
# display command line options

count=1
param  "$*";
    echo "Next parameter: $param"
    count=$(( $count + 1 ))

