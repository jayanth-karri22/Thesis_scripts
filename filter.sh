#!/bin/sh
rm -r NEW
mkdir NEW
for file in *.SAC
do
gcrc=`sac <<EOF | grep gcarc | awk '{print $3}'
read $file
lh gcarc
quit
EOF`
echo $gcrc $file| awk '{if($1>=30 && $1<=90) print "mv" , $2 , "NEW" }' | sh

done
