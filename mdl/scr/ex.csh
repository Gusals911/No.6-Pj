#!/bin/csh -f

 set exedir  = ${HOME}/bin
 set gfsfile = ${HOME}/inp/gfs/${current}/gfs.t00z.pgrb2.0p25.f000

 set wgribline = `${exedir}/wgrib2 ${gfsfile} | grep "PRES:surface:"`
 set extracode = `echo ${wgribline} | cut -f 1 -d':'`
 ${exedir}/wgrib2 ${gfsfile} -d ${extracode} -lon ${lonlat} >  ${tm1file}
 set wgribline = `${exedir}/wgrib2 ${gfsfile} | grep "HGT:surface:"`
 set extracode = `echo ${wgribline} | cut -f 1 -d':'`
 ${exedir}/wgrib2 ${gfsfile} -d ${extracode} -lon ${lonlat} >>  ${tm1file}
 set wgribline = `${exedir}/wgrib2 ${gfsfile} | grep "TMP:2 m above ground:"`
 set extracode = `echo ${wgribline} | cut -f 1 -d':'`
 ${exedir}/wgrib2 ${gfsfile} -d ${extracode} -lon ${lonlat} >>  ${tm1file}
 set wgribline = `${exedir}/wgrib2 ${gfsfile} | grep "UGRD:10 m above ground:"`
 set extracode = `echo ${wgribline} | cut -f 1 -d':'`
 ${exedir}/wgrib2 ${gfsfile} -d ${extracode} -lon ${lonlat} >>  ${tm1file}
 set wgribline = `${exedir}/wgrib2 ${gfsfile} | grep "VGRD:10 m above ground:"`
 set extracode = `echo ${wgribline} | cut -f 1 -d':'`
 ${exedir}/wgrib2 ${gfsfile} -d ${extracode} -lon ${lonlat} >>  ${tm1file}

 foreach j ( 1000 975 950 925 900 850 800 750 700 650 600 550 500 )

   set wgribline = `${exedir}/wgrib2 ${gfsfile} | grep "HGT:${j} mb:"`
   set extracode = `echo ${wgribline} | cut -f 1 -d':'`
   ${exedir}/wgrib2 ${gfsfile} -d ${extracode} -lon ${lonlat} >>  ${tm1file}
   set wgribline = `${exedir}/wgrib2 ${gfsfile} | grep "TMP:${j} mb:"`
   set extracode = `echo ${wgribline} | cut -f 1 -d':'`
   ${exedir}/wgrib2 ${gfsfile} -d ${extracode} -lon ${lonlat} >>  ${tm1file}
   set wgribline = `${exedir}/wgrib2 ${gfsfile} | grep "UGRD:${j} mb:"`
   set extracode = `echo ${wgribline} | cut -f 1 -d':'`
   ${exedir}/wgrib2 ${gfsfile} -d ${extracode} -lon ${lonlat} >>  ${tm1file}
   set wgribline = `${exedir}/wgrib2 ${gfsfile} | grep "VGRD:${j} mb:"`
   set extracode = `echo ${wgribline} | cut -f 1 -d':'`
   ${exedir}/wgrib2 ${gfsfile} -d ${extracode} -lon ${lonlat} >>  ${tm1file}

 end
