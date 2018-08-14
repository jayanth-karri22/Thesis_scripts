gmtset ANNOT_FONT 5
gmtset LABEL_FONT 5
gmtset LABEL_FONT_SIZE 18
gmtset ANNOT_FONT_SIZE 16
gmtset TICK_LENGTH -.30
gmtset TICK_PEN 1p
gmtset FRAME_PEN 1p
gmtset LABEL_OFFSET 0
gmtset ANNOT_OFFSET .10
count=1
outfile=Time-Amp.inp
rm -rf $outfile Baz-Del-List Eqr-Baz-File
stn=`pwd |awk -F"/" '{print $7}'`
########Sort eqrs wrt BAZ
for file in `ls *eqr`
do
baz=`saclhdr -BAZ $file | awk '{print $1}'`
del=`saclhdr -GCARC $file | awk '{print $1}'`
echo "$file $baz $del"|awk '{printf "%s\t%d\t%d\n", $1,$2,$3}' >> Baz-Del-List
done
sort -g -k2 Baz-Del-List>Sort-Baz-List
rm -rf Baz-Del-List
###

more Sort-Baz-List |grep -v \*|awk '{print $1}'>rftn.lst
sfpath=`pwd`

for stack in `cat rftn.lst` ; do
#		rayp=`saclhdr -USER4 ${sfpath}/$stack`
		delta="0.05"
		gauss=`saclhdr -USER0 ${sfpath}/$stack`
		baz=`saclhdr -BAZ ${sfpath}/$stack`
		#Convert original stack file to alpha format
echo "$stack $baz" >>Eqr-Baz-File
sac<<END
r ${sfpath}/$stack
cut -3 45
r ${sfpath}/$stack
w ${sfpath}/${stack}1
convert from sac ${sfpath}/${stack}1 to alpha $stack.a
q
END

		sacalphafile=$stack.a
		begintime=-3
echo ">" >> $outfile
awk 'NR > 30 { print $0 }' < $sacalphafile | awk '{ i=1; while (i<NF+1) { print $i; ++i }}' | awk '{ print '$begintime' + '$delta'*(NR-1), $1 }' | awk '{ print $1, '$count', $2 }' >> $outfile
count=`echo $count |awk '{print $1+1}'`

rm -rf $stack.a ${stack}1
done
#################
#scale=0.2		# Scale of plot
num=10			# max number of Rfs in main figure
Timemin=-1
Timemax=25
jj="-JX4i/3i"
rrs="-R$Timemin/$Timemax/0/14"
OUT=RF.ps
################
        scale=.8
	psbasemap $jj $rrs -Ba5f1S:"Time (s)": -P -X1.5i -Y2i -V -K > ${OUT}
        
		baz=`saclhdr -BAZ ${sfpath}/$stack`
		pswiggle $outfile $jj $rrs -N -Ggray -Z$scale -K -O -m >> $OUT
		pswiggle $outfile $jj $rrs -Gblack -Z$scale -W.01 -K -O -m >> $OUT
		pswiggle $outfile $jj $rrs -Z$scale -W.01 -K -O -m >> $OUT
		more Sort-Baz-List |awk '{print $1,$2}'|awk '{print -2.5,++count,10,0,5,"ML",$2}' | pstext $jj $rrs -K -N -O >> $OUT
echo $count|awk '{print -3.2,$1+.5,14,0,5,"ML","BAZ"}' | pstext $jj $rrs -N -K -O >> $OUT
echo $count|awk '{print 21.5,$1+.5,16,0,5,"ML","'$stn'"}' | pstext $jj $rrs -Wwhite,o -K -N -O >> $OUT
psxy $jj $rrs -W3,red,a -O -m <<EOF>>$OUT
4.5 0
4.5 12
EOF

gs $OUT
