#!/bin/sh 

for f in $(find ${1}  -name '*.ncl' );do   nickel format "${f}" || echo "failed: $f"  ;done
