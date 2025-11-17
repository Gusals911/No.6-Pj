#!/bin/csh -f

## start scripts and current date to current variable
 set current = `/usr/bin/date +%Y%m%d%H%M`
 set start_tim = `date`

# The information of domains ## User defines ###############################################
 set PMAP    = TTM
 set DATUM   = "WGS-84"
 set FEAST   = 200.0
 set FNORTH  = 600.0
 set RLAT0   = 38N
 set RLON0   = 127E
 set XORIGKM = 396.512
 set YORIGKM = 304.936
 set NX      = 300
 set NY      = 300
 set DGRIDKM = 0.1
 set VALUE = 21
####################################################################### End of User Define ##

## folder setting
 set bsdir   = ${HOME}/run
 set nmldir  = ${HOME}/inp/nmlist
 set emsdir	 = ${HOME}/inp/nmlist/emissions
 set outdir  = ${HOME}/out
 set sfcdir  = ${HOME}/inp/surf
 set uppdir  = ${HOME}/inp/up
 set rstdir  = ${HOME}/inp/restart
 set exedir  = ${HOME}/bin
 set logdir  = ${HOME}/log
 cd ${bsdir}
 echo "  ==================================== ${current} ===================================="

## set date variables
 set stt_yr = `${exedir}/advt ${current} 0 -F ccyy`
 set stt_mm = `${exedir}/advt ${current} 0 -F mm`
 set stt_dd = `${exedir}/advt ${current} 0 -F dd`
 set stt_jd = `${exedir}/advt ${current} 0 -j`
 @ sjd = ${stt_jd} - ( ${stt_yr} * 1000 )
 set stt_hh = `${exedir}/advt ${current} 0 -F hh`
 set stt_nn = `${exedir}/advt ${current} 0 -F nn`

 set end_yr = `${exedir}/advt ${current} +48 -F ccyy`
 set end_mm = `${exedir}/advt ${current} +48 -F mm`
 set end_dd = `${exedir}/advt ${current} +48 -F dd`
 set end_jd = `${exedir}/advt ${current} +48 -j`
 @ ejd = ${end_jd} - ( ${end_yr} * 1000 )
 set end_hh = `${exedir}/advt ${current} +48 -F hh`
 set end_nn = `${exedir}/advt ${current} +48 -F nn` 

 set stt_date = `${exedir}/advt ${current} 0 -F ccyymmddhh`
 set stt_utc1 = `${exedir}/advt ${current} -9 -F ccyymmdd`
 set stt_utc2 = `${exedir}/advt ${current} -33 -F ccyymmdd`

## link to run folder geogrphy and gfs dataset
 ln -sf ${nmldir}/GEO.DAT ${bsdir}/
 ln -sf ${nmldir}/topo.csv ${bsdir}/
 ln -sf ${nmldir}/calpost.org ${bsdir}/calpost.inp

 @ j = 0
 foreach k ( 47922 47925 47952 47955 )
   @ j++
   if ( -e ${uppdir}/UP_${k}_${stt_utc1}.DAT ) then
     ln -sf ${uppdir}/UP_${k}_${stt_utc1}.DAT ${bsdir}/UP${j}.DAT
   else if ( -e ${uppdir}/UP_${k}_${stt_utc2}.DAT ) then
     ln -sf ${uppdir}/UP_${k}_${stt_utc2}.DAT ${bsdir}/UP${j}.DAT
   else
     echo "    Error... None Upper Data UP_${k}_${stt_utc1}.DAT/UP_${k}_${stt_utc2}.DAT"
     exit()
   endif
 end

## link to run folder surface data, read and write averaged pressure to surface data
 set prpr = `cat ${sfcdir}/pr/${stt_yr}${stt_mm}${stt_dd}/pres_${stt_yr}${stt_mm}${stt_dd}${stt_hh}`
 sed -e "s/STCY/${stt_yr}/g" -e "s/SJD/${sjd}/g" -e "s/SHH/${stt_hh}/g" -e "s/EDCY/${end_yr}/g" -e "s/EJD/${ejd}/g" -e "s/EHH/${end_hh}/g" -e "s/KYTSPR/${prpr}/g" ${sfcdir}/lastdata > ${bsdir}/SURF.DAT

 set end_yr = `${exedir}/advt ${current} +48m -F ccyy`
 set end_mm = `${exedir}/advt ${current} +48m -F mm`
 set end_dd = `${exedir}/advt ${current} +48m -F dd`
 set end_jd = `${exedir}/advt ${current} +48m -j`
 @ ejd = ${end_jd} - ( ${stt_yr} * 1000 )
 set end_hh = `${exedir}/advt ${current} +48m -F hh`
 set end_nn = `${exedir}/advt ${current} +48m -F nn`
 set stt_date = ${current}
 set end_date = `${exedir}/advt ${current} +48m -F ccyymmddhhnn`
 @ sss = ${stt_nn} * 60
 @ ess = ${end_nn} * 60

 if ( -e ${rstdir}/RESTART_${stt_date}.DAT ) then
   ln -sf ${rstdir}/RESTART_${stt_date}.DAT ${bsdir}/RESTARTA.DAT
   set res_p = 3
 else
   set res_p = 2
 endif

## nudge domain informations and time variables to calmet.inp
 sed -e "s/SBTSPMAP/${PMAP}/g" -e "s/SBTSDATUM/${DATUM}/g" -e "s/SBTSEAST/${FEAST}/g" -e "s/SBTSNORTH/${FNORTH}/g" -e "s/SBTSRLAT/${RLAT0}/g" -e "s/SBTSRLON/${RLON0}/g" -e "s/SBTSORGX/${XORIGKM}/g" -e "s/SBTSORGY/${YORIGKM}/g" -e "s/SBTSNX/${NX}/g" -e "s/SBTSNY/${NY}/g" -e "s/SBTSGRID/${DGRIDKM}/g" -e "s/KYTSSY/${stt_yr}/g" -e "s/KYTSSM/${stt_mm}/g" -e "s/KYTSSD/${stt_dd}/g" -e "s/KYTSSH/${stt_hh}/g" -e "s/KYTSSS/${sss}/g" -e "s/KYTSEY/${end_yr}/g" -e "s/KYTSEM/${end_mm}/g" -e "s/KYTSED/${end_dd}/g" -e "s/KYTSEH/${end_hh}/g" -e "s/KYTSES/${ess}/g" ${nmldir}/calmet.org > ${bsdir}/calmet.inp

## nudge domain iformations and restart situation to calpuff.inp and mkae calpuff.inp with emissions file
 sed -e "s/SBTSPMAP/${PMAP}/g" -e "s/SBTSDATUM/${DATUM}/g" -e "s/SBTSEAST/${FEAST}/g" -e "s/SBTSNORTH/${FNORTH}/g" -e "s/SBTSRLAT/${RLAT0}/g" -e "s/SBTSRLON/${RLON0}/g" -e "s/SBTSORGX/${XORIGKM}/g" -e "s/SBTSORGY/${YORIGKM}/g" -e "s/SBTSNX/${NX}/g" -e "s/SBTSNY/${NY}/g" -e "s/SBTSGRID/${DGRIDKM}/g" -e "s/KYTSRES/${res_p}/g" ${nmldir}/calpuff1.org > ${bsdir}/calpuff.inp


## run calmet model
 echo " Ex>> calmet-6.5.0.exe" 
 ${exedir}/calmet-6.5.0.exe
 ${exedir}/read.calmet.exe
 if ( ! -e ${bsdir}/CALMET.DAT ) then
   echo "    Error.... CALMET Model"
   exit()
 endif
 if ( ! -e ${outdir}/${stt_yr}${stt_mm}${stt_dd} ) mkdir -p ${outdir}/${stt_yr}${stt_mm}${stt_dd}
 mv -f uu.csv ${outdir}/${stt_yr}${stt_mm}${stt_dd}/uu.${end_date}.csv
 mv -f vv.csv ${outdir}/${stt_yr}${stt_mm}${stt_dd}/vv.${end_date}.csv
 mv -f ww.csv ${outdir}/${stt_yr}${stt_mm}${stt_dd}/ww.${end_date}.csv
 mv -f tt.csv ${outdir}/${stt_yr}${stt_mm}${stt_dd}/tt.${end_date}.csv
 mv -f dd.csv ${outdir}/${stt_yr}${stt_mm}${stt_dd}/dd.${end_date}.csv


 echo "[SYSTEM1] Calculate total emissions Start!"
 
 rm ${bsdir}/calpuff.inp
 cp ${bsdir}/original_calpuff/calpuff.inp ${bsdir}/calpuff.inp
 cat ${emsdir}/emissions >> ${bsdir}/calpuff.inp
 cat ${nmldir}/calpuff2.org >> ${bsdir}/calpuff.inp
	 
	 
 ## run calpuff model and check error
 set iferror = 0 

 @ i  = 0
 while ( ${i} <= 9 )

	   echo " "
	   echo " Ex>> calpuff.z0${i}.exe"
	   ${exedir}/calpuff.z0${i}.exe

	#  if ( -e ${bsdir}/RESTARTB.DAT ) then
		 ${exedir}/calpost-7.1.0.exe
		 mv -f *_L00_SO2_*.GRD so2.z0${i}.grd
		 if ( ${i} < 9 ) rm -f ${bsdir}/RESTARTB.DAT
	#  else
	#    set iferror = 1
	#  endif

	@ i++
	end

	## if error ?? 
 if ( $iferror == 1 ) then
	## error :: initialize 
	if ( ! -e ${logdir}/${stt_yr}${stt_mm}${stt_dd} ) mkdir -p ${logdir}/${stt_yr}${stt_mm}${stt_dd}
	cp ${bsdir}/CALPUFF.LST ${logdir}/${stt_yr}${stt_mm}${stt_dd}/PUFF_${current}
	rm -f ${bsdir}/CALMET.DAT ${bsdir}/RESTARTA.DAT
 else
	## no error :: read & write 3d data to csv files
	${exedir}/read.puff.3d.exe
	mv -vf conc.csv ${outdir}/${stt_yr}${stt_mm}${stt_dd}/conc.${end_date}.csv
	rm -f ${bsdir}/so2.z*.grd
	mv -vf ${bsdir}/RESTARTB.DAT ${rstdir}/RESTART_${end_date}.DAT
 endif





 echo "[SYSTEM2] Calculate each emissions Start!"
 set v = 1
 while ( ${v} <= $VALUE )
	 rm ${bsdir}/calpuff.inp
	 cp ${bsdir}/original_calpuff/calpuff.inp ${bsdir}/calpuff.inp
	 cat ${emsdir}/emissions${v} >> ${bsdir}/calpuff.inp
	 cat ${nmldir}/calpuff2.org >> ${bsdir}/calpuff.inp
	 
	 
	## run calpuff model and check error
	 set iferror = 0 

	 @ i  = 0
	 while ( ${i} <= 9 )

	   echo " "
	   echo " Ex>> calpuff.z0${i}.exe"
	   ${exedir}/calpuff.z0${i}.exe

	#  if ( -e ${bsdir}/RESTARTB.DAT ) then
		 ${exedir}/calpost-7.1.0.exe
		 mv -f *_L00_SO2_*.GRD so2.z0${i}.grd
		 if ( ${i} < 9 ) rm -f ${bsdir}/RESTARTB.DAT
	#  else
	#    set iferror = 1
	#  endif

	@ i++
	end

	## if error ?? 
	 if ( $iferror == 1 ) then
	## error :: initialize 
	   if ( ! -e ${logdir}/${stt_yr}${stt_mm}${stt_dd} ) mkdir -p ${logdir}/${stt_yr}${stt_mm}${stt_dd}
	   cp ${bsdir}/CALPUFF.LST ${logdir}/${stt_yr}${stt_mm}${stt_dd}/PUFF_${current}
	   rm -f ${bsdir}/CALMET.DAT ${bsdir}/RESTARTA.DAT
	 else
	## no error :: read & write 3d data to csv files
	   ${exedir}/read.puff.3d.exe
	   if ( ! -e ${outdir}/${stt_yr}${stt_mm}${stt_dd}/eachdata ) mkdir -p ${outdir}/${stt_yr}${stt_mm}${stt_dd}/eachdata
	   mv -vf conc.csv ${outdir}/${stt_yr}${stt_mm}${stt_dd}/eachdata/conc.${end_date}ll${v}.csv
	   rm -f ${bsdir}/so2.z*.grd
	   mv -vf ${bsdir}/RESTARTB.DAT ${rstdir}/RESTART_${end_date}.DAT
	 endif
 @ v++
 end

 echo ' '
 echo '--------------------------------'
 echo $start_tim
 date
 echo '--------------------------------'
 echo ' '

 exit()
