#!/bin/bash
# display command line options

count=1
 param  "$*";
    echo "\$* Parameter #$count = $param"
    count=$(( $count + 1 ))

