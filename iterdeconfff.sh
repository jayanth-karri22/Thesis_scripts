for station in `ls *.e|awk -F".e" '{print $1}'`
do 
#. ~/.profile
sac<<!

r ${station}.z ${station}.n ${station}.e
fileid t n
bp co 0.2 1.6
cut t0 -30 90
read
cut off
w ${station}.z.cut ${station}.n.cut ${station}.e.cut
r ${station}.n.cut ${station}.e.cut
rotate to gcarc
w ${station}.r ${station}.t
q
!
done

for station in `ls *.e|awk -F".e" '{print $1}'`
do 
#for gw in 1.0 2.0 4.0 
#do
iterdecon<<!
${station}.r
${station}.z.cut
200
5
0.01
1
1
0
!
cp decon.out ${station}.eqr
echo "RFs"
#done
usr=`sac<<! | grep USER9 |awk '{print $3}'
r $station.eqr 
lh USER9
q
!`
echo $usr $station  | awk '{if ($1>70) print $1 "\t" $2".eqr"}'>> list.dat
done


