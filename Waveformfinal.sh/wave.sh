#!/bin/sh

for file in *HHZ*.M.SAC; do
l=`echo $file | awk -F"HHZ" '{print $1}'`
taup_setsac -ph P-0 $l*
sac <<EOF
r $l*
cut T0 -30 120
read
cutoff
rmean
rtrend
wh
w over
r $l*
bp co 0.05 1 p2
w over
r $l.HHZ.M.SAC $l.HHE.M.SAC
rotate to gcarc
w $l.HHR.M.SAC $l.HHT.M.SAC
quit
EOF
done
