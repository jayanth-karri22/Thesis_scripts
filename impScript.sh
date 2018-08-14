#!/bin/sh

for file in *HHZ*.SAC; do
l=`echo $file | awk -F"HHZ" '{print $1}'`
sac <<EOF
r $l*
ppk
quit
EOF
read -p "is it a good event: " ans
if [ $ans = "y" ]
then
	echo $l	
	echo $l >> good.txt
fi
done
