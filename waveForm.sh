#!/bin/sh

for file in *sac; do
   sac <<EOF
   echo on
   read $file
   rmean
   rtrend
   lp co 0.1 p 2 n 4
   write ${file}.filtered
   quit
EOF
done
