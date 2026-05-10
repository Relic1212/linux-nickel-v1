

for d in $(ls build/tmp/ | grep cosmic );do if [ -e build/tmp/$d/src/vendor/smithay ];then  echo $d; fi ;done|grep -v sources
