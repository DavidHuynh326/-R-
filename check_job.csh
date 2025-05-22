#! /bin/csh -f

#####################################################################
# Date            Version         Description                       #
#-------------------------------------------------------------------#
# 20160304        v2             Set the default user = caller      #
#                                                                   #
#####################################################################

set caller = `whoami`

set max = "300"

mkdir -p /svhome/VCF_RVC_OffSite/lpvf05_vf/${caller}/LOG_CHECK_JOBS
set HOSTNAME = `/bin/hostname`

if (($HOSTNAME =~ *login*) || ($HOSTNAME =~ *rvc-srv*)) then
   
#   if ( $#argv != 1 ) then
#      set LIST_USER = "$argv[1-$#argv]"
#   else
#      set LIST_USER = "$argv[1]"
#   endif
   if ( $#argv != 1 ) then
      if ( $#argv > 1 ) then
        set LIST_USER = "$argv[1-$#argv]"
      else
        set LIST_USER = "$caller"
      endif
   else
      set LIST_USER = "$argv[1]"
   endif

   foreach USER ($LIST_USER)
      echo "* Infor: LSF jobs of $USER"
      sjobs -l -u $USER | sed 's/ //g'|sed 's/\t//g' | awk '{printf $0}' | sed '/IBloadSched-loadStop/s//\n/g'|sed 's/#####LSFinformation#####//g' |sed 's/-\+Job</Job</g'> /svhome/VCF_RVC_OffSite/lpvf05_vf/${caller}/LOG_CHECK_JOBS/log.${USER}
      cat /svhome/VCF_RVC_OffSite/lpvf05_vf/${caller}/LOG_CHECK_JOBS/log.${USER} | sed 's/.*use_mem_size=\([0-9]*\).*/use_mem_size \1/g' | \
         awk '{if ($1~/use_mem_size/) {print $2}}'                                                                        > /svhome/VCF_RVC_OffSite/lpvf05_vf/${caller}/LOG_CHECK_JOBS/jsize.${USER}
      cat /svhome/VCF_RVC_OffSite/lpvf05_vf/${caller}/LOG_CHECK_JOBS/log.${USER} | sed 's/.*Job<\([0-9]*\).*/\1/g' | awk '{print $1}'          > /svhome/VCF_RVC_OffSite/lpvf05_vf/${caller}/LOG_CHECK_JOBS/jobid.${USER}
      cat /svhome/VCF_RVC_OffSite/lpvf05_vf/${caller}/LOG_CHECK_JOBS/log.${USER} | sed 's/.*JobName<\(.*\)>,User<.*/\1/g' | awk '{print $1}'   > /svhome/VCF_RVC_OffSite/lpvf05_vf/${caller}/LOG_CHECK_JOBS/jname.${USER}
      cat /svhome/VCF_RVC_OffSite/lpvf05_vf/${caller}/LOG_CHECK_JOBS/log.${USER} | sed 's/.*Startedon.*<\(rvc-srv[0-z]*\)>.*/\1/g'| \
         awk '{if ($0 ~ /loadStop/) {print "-"} else {print $0}}'                                                         > /svhome/VCF_RVC_OffSite/lpvf05_vf/${caller}/LOG_CHECK_JOBS/jserv.${USER}
      cat /svhome/VCF_RVC_OffSite/lpvf05_vf/${caller}/LOG_CHECK_JOBS/log.${USER} | sed 's/.*\([A-Z][a-z].*[A-Z][a-z].*[0-9].*:[0-9]*:[0-9]*\):Startedon.*/\1/g' | \
         awk '{if ($0 ~ /loadStop/) {print "-"} else {print $0}}'|sed 's/\(...\)\(.*\)\(..\):\(..\):\(..\)/\2_\3:\4:\5/g' > /svhome/VCF_RVC_OffSite/lpvf05_vf/${caller}/LOG_CHECK_JOBS/jrans.${USER}
      cat /svhome/VCF_RVC_OffSite/lpvf05_vf/${caller}/LOG_CHECK_JOBS/log.${USER} | sed 's/.*TheCPUtimeusedis\([0-9]*\)seconds.*/\1/g' | \
         awk '{if ($0 ~ /loadStop/) {print "-"} else {print $0}}'                                                         > /svhome/VCF_RVC_OffSite/lpvf05_vf/${caller}/LOG_CHECK_JOBS/jcput.${USER}
      cat /svhome/VCF_RVC_OffSite/lpvf05_vf/${caller}/LOG_CHECK_JOBS/log.${USER} | sed 's/.*MEM:\([0-9]*\)Mbytes.*/\1/g' | \
         awk '{if ($0 ~ /loadStop/) {print "-"} else {print $0}}'                                                         > /svhome/VCF_RVC_OffSite/lpvf05_vf/${caller}/LOG_CHECK_JOBS/jmemo.${USER}
      cat /svhome/VCF_RVC_OffSite/lpvf05_vf/${caller}/LOG_CHECK_JOBS/log.${USER}| sed 's/.*Status<\([A-Z]*\)>,Queue.*/\1/g' | awk '{print $1}' > /svhome/VCF_RVC_OffSite/lpvf05_vf/${caller}/LOG_CHECK_JOBS/jstat.${USER}
      cat /svhome/VCF_RVC_OffSite/lpvf05_vf/${caller}/LOG_CHECK_JOBS/log.${USER} | sed 's/.*CWD<\(.*\)>/\1>/g' | \
         awk -F\> '{print $1}'                                                                                            > /svhome/VCF_RVC_OffSite/lpvf05_vf/${caller}/LOG_CHECK_JOBS/jdire.${USER}
      cat /svhome/VCF_RVC_OffSite/lpvf05_vf/${caller}/LOG_CHECK_JOBS/log.${USER} | sed 's/.*>,\([1-8]\)ProcessorsRequested.*/\1/g' | \
         awk '{if ($0 ~ /loadStop/) {print 1} else {print $0}}'                                                           > /svhome/VCF_RVC_OffSite/lpvf05_vf/${caller}/LOG_CHECK_JOBS/hosts.${USER}
		rm -rf /svhome/VCF_RVC_OffSite/lpvf05_vf/${caller}/LOG_CHECK_JOBS/lsload.${USER}
	foreach f (`cat /svhome/VCF_RVC_OffSite/lpvf05_vf/${caller}/LOG_CHECK_JOBS/jserv.${USER}`)	
		set LSLOAD = `lsload $f|grep rvc| awk '{print $6}'|sed 's/%//g'`        	
		echo $LSLOAD"%"	>>  /svhome/VCF_RVC_OffSite/lpvf05_vf/${caller}/LOG_CHECK_JOBS/lsload.${USER} 
 	end
      paste /svhome/VCF_RVC_OffSite/lpvf05_vf/${caller}/LOG_CHECK_JOBS/jobid.${USER} /svhome/VCF_RVC_OffSite/lpvf05_vf/${caller}/LOG_CHECK_JOBS/jname.${USER} \
            /svhome/VCF_RVC_OffSite/lpvf05_vf/${caller}/LOG_CHECK_JOBS/jstat.${USER} /svhome/VCF_RVC_OffSite/lpvf05_vf/${caller}/LOG_CHECK_JOBS/jserv.${USER} \
            /svhome/VCF_RVC_OffSite/lpvf05_vf/${caller}/LOG_CHECK_JOBS/jrans.${USER} /svhome/VCF_RVC_OffSite/lpvf05_vf/${caller}/LOG_CHECK_JOBS/jcput.${USER} \
            /svhome/VCF_RVC_OffSite/lpvf05_vf/${caller}/LOG_CHECK_JOBS/jmemo.${USER} /svhome/VCF_RVC_OffSite/lpvf05_vf/${caller}/LOG_CHECK_JOBS/jdire.${USER} \
            /svhome/VCF_RVC_OffSite/lpvf05_vf/${caller}/LOG_CHECK_JOBS/hosts.${USER} /svhome/VCF_RVC_OffSite/lpvf05_vf/${caller}/LOG_CHECK_JOBS/jsize.${USER} /svhome/VCF_RVC_OffSite/lpvf05_vf/${caller}/LOG_CHECK_JOBS/lsload.${USER} > /svhome/VCF_RVC_OffSite/lpvf05_vf/${caller}/LOG_CHECK_JOBS/sum.${USER}
      echo "=================================================================================================================================================================================================="
      echo "JOB_ID|JOB_NAME                                      |N |STATE|RUN_ON_SERVE| UT |RUN_AT_TIME     |CPUTIME|MEMORY    |SUBMITTED_AT                                                                  " 
      echo "------+----------------------------------------------+--+-----+------------+----+----------------+-------+----------+------------------------------------------------------------------------------"
      cat /svhome/VCF_RVC_OffSite/lpvf05_vf/${caller}/LOG_CHECK_JOBS/sum.${USER} | \
         awk '{if ($1 ~ /-/) {} else {printf ("%-6s|%-46s|%2s|%-5s|%-12s|%-4s|%-16s|%7s|%4.3s(%4s)|%-80s\n",$1,substr($2,0,50),$9,$3,$4,$11,$5,$6,$7/1024,$10,substr($8,0,'$max'))};}'
      echo "------+----------------------------------------------+--+-----+------------+----+----------------+-------+----------+------------------------------------------------------------------------------"
      set SUM_RUN = `egrep -c "RUN" /svhome/VCF_RVC_OffSite/lpvf05_vf/${caller}/LOG_CHECK_JOBS/sum.${USER}`
      set SUM_PEN = `egrep -c "PEND" /svhome/VCF_RVC_OffSite/lpvf05_vf/${caller}/LOG_CHECK_JOBS/sum.${USER}`
   end
#   rm -rf /svhome/VCF_RVC_OffSite/lpvf05_vf/${caller}/LOG_CHECK_JOBS
endif
