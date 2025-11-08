#!/bin/csh -f

 set tmpfile = ${HOME}/scr/nofile
 set gfsserv = 'ftp://ftp.ncep.noaa.gov/pub/data/nccf/com/gfs/prod'
 cd ${bsdir}

 @ count_down = 1
 while ( ${count_down} <= 10 )

   rm -f ${tmpfile}
   @ i = 0
   while ( $i <= 48 )

     if ( $i < 10 ) then
       set tail = 00${i}
     else if ( $i < 100 ) then
       set tail = 0${i}
     else
       set tail = ${i}
     endif

     if ( ! -e ${gfsdir}/${current}/gfs.t00z.pgrb2.0p25.f${tail} ) then
       echo ${tail} >> ${tmpfile}
     else
       set ok_line = `tail -n 10 ${logdir}/${current}/${tail} | grep 'saved'`
       if ( "x${ok_line}" == x ) then
         echo ${tail} >> ${tmpfile}
       endif
     endif

   @ i = $i + 6
   end

   if ( ! -e ${tmpfile} ) then
     exit()
   else
     foreach i ( `cat ${tmpfile}` )
       /usr/bin/wget -o ${logdir}/${current}/$i "${gfsserv}/gfs.${current}/00/atmos/gfs.t00z.pgrb2.0p25.f${i}"
     end
     mv -vf gfs.*.f* ${gfsdir}/${current}
   endif

 @ count_down++
 end

 if ( -e ${tmpfile} ) then
   cat ${tmpfile} >> ${logdir}/${current}/error.wget
   rm -f ${tmpfile}
 endif

 exit()
