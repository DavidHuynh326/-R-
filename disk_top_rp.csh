#!/bin/csh -f


set date        = `date +%Y%m%d-%H%M`

#ssh rvc-app04 du -sh  $pwd/*|sort -n | sed 's#'$pwd'##g' | tee log_disk.$date
#bs -M 1000 du -sh $pwd/* |tee log_disk.$date
#echo  "----------------------------------------------------- "
echo  "         Total  Used   Remain  Ratio     Disk"
df -i -h /design01/kairosen9vcf |grep "[0-9]M" | awk '{print "inode \t", $1"\t"$2"\t"$3"\t"$4"\t"$5}'
df -h /design01/kairosen9vcf    |grep "[0-9]G" | awk '{print "disk \t", $1"\t"$2"\t"$3"\t"$4"\t"$5}'
