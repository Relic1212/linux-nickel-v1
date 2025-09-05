#!/bin/sh

for d in $(ls build/tmp/ | grep cosmic );do if [ -e build/tmp/$d/src/vendor/iced_wgpu ];then  echo $d; fi ;done|grep -v sources
