#!/bin/csh
 
 set stn = (  47922  47925  47952  47955 )
### User defines ############################################################################
 set lon = ( 129.25 129.25 129.50 129.50 )
 set lat = (  35.25  35.50  35.25  35.50 )
####################################################################### End of User Define ##

 setenv current `date +%Y%m%d`
 setenv bsdir   ${HOME}
 setenv scrdir  ${HOME}/scr
 setenv exedir  ${HOME}/bin
 setenv logdir  ${HOME}/log
 setenv gfsdir  ${HOME}/inp/gfs
 setenv uppdir  ${HOME}/inp/up
 setenv nmldir  ${HOME}/inp/nmlist
 cd ${bsdir}
 
 mkdir -p ${logdir}/${current}
 mkdir -p ${gfsdir}/${current}
 if ( ! -e ${HOME}/inp/surf/pr/${current} ) mkdir -p ${HOME}/inp/surf/pr/${current}
 set tomor = `${exedir}/advt ${current} +24 -F ccyymmdd`
 if ( ! -e ${HOME}/inp/surf/pr/${tomor} ) mkdir -p ${HOME}/inp/surf/pr/${tomor}
 set tomor = `${exedir}/advt ${current} +48 -F ccyymmdd`
 if ( ! -e ${HOME}/inp/surf/pr/${tomor} ) mkdir -p ${HOME}/inp/surf/pr/${tomor}

 ${scrdir}/down.gfs.csh

 set start_date = ${current}00
 set end_date   = `${exedir}/advt ${start_date} +48 -F ccyymmddhh`
 set stt_yr     = `${exedir}/advt ${start_date} 0 -F ccyy`
 set stt_mm     = `${exedir}/advt ${start_date} 0 -F mm`
 set stt_dd     = `${exedir}/advt ${start_date} 0 -F dd`
 set stt_jd     = `${exedir}/advt ${start_date} 0 -j`
 @ sjd          = ${stt_jd} - ( ${stt_yr} * 1000 )
 set stt_hh     = `${exedir}/advt ${start_date} -0 -F hh`

 set end_yr     = `${exedir}/advt ${end_date} 0 -F ccyy`
 set end_mm     = `${exedir}/advt ${end_date} 0 -F mm`
 set end_dd     = `${exedir}/advt ${end_date} 0 -F dd`
 set end_jd     = `${exedir}/advt ${end_date} 0 -j`
 @ ejd          = ${end_jd} - ( ${stt_yr} * 1000 )
 set end_hh     = `${exedir}/advt ${end_date} 0 -F hh`
 set endnum     = $#stn

 @ j = 1
 while ( $j <= ${endnum} )

   setenv stnid  ${stn[$j]}
   setenv lonlat "${lon[$j]}  ${lat[$j]}"

   cat ${nmldir}/UP.head > ${bsdir}/UP${j}.DAT
   ${exedir}/upp_line.exe ${stt_yr} ${sjd} ${stt_hh} ${end_yr} ${ejd} ${stt_hh} 500. 2 1 >> ${bsdir}/UP${j}.DAT
   echo "     F    F    F    F" >> ${bsdir}/UP${j}.DAT

   @ k = 0
   set i = ${start_date}
   while ( ${i} <= ${end_date} )

     echo "==================================================== ${i} ===================================================="
     if ( $k < 10 ) then
       set tail = 00${k}
     else if ( $k < 100 ) then
       set tail = 0${k}
     else
       set tail = ${k}
     endif
     setenv gfsfile ${gfsdir}/${current}/gfs.t00z.pgrb2.0p25.f${tail}
     setenv tm1file ${bsdir}/1.tmp
     setenv tm2file ${bsdir}/2.tmp

     ${scrdir}/ex.csh
     if ( -e ${tm2file} ) rm -f ${tm2file}
     echo "  ${scrdir}/split.csh"
     ${scrdir}/split.csh
     echo "  ${exedir}/mk.up.exe ${stnid} ${i}"
     ${exedir}/up.calmet.exe ${stnid} ${i}
     cat UP_${stnid}_${i}.DAT >> ${bsdir}/UP${j}.DAT

   @ k = $k + 6
   set i = `${exedir}/advt ${i} +6 -F ccyymmddhh`
   end

   mv -vf ${bsdir}/UP${j}.DAT ${uppdir}/UP_${stnid}_${current}.DAT
   #mv -vf ${bsdir}/UP${j}.DAT ${uppdir}/UP${j}.DAT

 @ j++
 end

 if ( -e ${bsdir}/times ) rm -f times
 set i = ${start_date}
 while ( ${i} <= ${end_date} )
   echo ${i} >> ${bsdir}/times
 set i = `${exedir}/advt ${i} +6 -F ccyymmddhh`
 end
  set i = ${start_date}
 while ( ${i} <= ${end_date} )
   echo ${i} >> ${bsdir}/times
 set i = `${exedir}/advt ${i} +1 -F ccyymmddhh`
 end

 ${exedir}/cal.pres.exe

 rm -f ${bsdir}/UP_* ${bsdir}/pres_* ${tm1file} ${tm2file} ${bsdir}/times
