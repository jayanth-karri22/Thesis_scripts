#Convert output from joint96 to alpha format
gmtset FONT_ANNOT_PRIMARY 18,5
gmtset FONT_LABEL 18,5
#gmtset FONT_SIZE_ANNOT 28
#gmtset FONT_SIZE_LABEL 28
gmtset MAP_TICK_LENGTH_PRIMARY -.20
gmtset MAP_TICK_PEN_PRIMARY 1p
gmtset MAP_FRAME_PEN 1p
gmtset MAP_LABEL_OFFSET 0.2
gmtset MAP_ANNOT_OFFSET_PRIMARY .40
delta="0.1"
echo "Enter Model name (w/o .sac):"
read model
pic=$model.ps

                sac<<END
r $model.sac
cut -5 45
r $model.sac
w $model.sac1
convert from sac $model.sac1 to alpha end$model.a
q
END

                sacalphafile=end$model.a
                begintime=-5
                outfile=end$model.s
                awk 'NR > 30 { print $0 }' < $sacalphafile | awk '{ i=1; while (i<NF+1) { print $i; ++i }}' | awk '{ print '$begintime' + '$delta'*(NR-1), $1 }' | awk '{ print $1, "0", $2 }' > $outfile


##########################
#################
scale=0.2		# Scale of plot
num=10			# max number of Rfs in main figure
Timemin=-2
Timemax=40
jj="-JX10/15"
rrs="-R$Timemin/$Timemax/-0.04/0.30"
################

	# Gmt plot
	#scale=`echo "scale=3; 0.05 * $n " | bc`
	#n=`wc -l rftn.lst | awk '{print $1}'`
	i=0
	psbasemap $jj $rrs -Ba5f1S:"Time (s)":S -P -V -K > $pic
	#psbasemap $jj $rrs -Ba5f1S:"Time (s)":S -P -Y6.5i -V -K > $pic
	pswiggle end$model.s $jj $rrs  -Z$scale -W1,black -K -O -V >> $pic

######## For Moho mark
#echo "3.3 40 25 360 34 ML \333" | pstext $j $rs -G  -C$1/$2 -K -O >>$model.ps
echo "4.6  0.046 18 0 5 ML \Pms" | pstext $jj $rrs -G -C$1/$2 -K -O >> $pic
echo "6.9  0.017 18 0 5 ML \Phs" | pstext $jj $rrs -G -C$1/$2 -O >> $pic
gs $pic
       
