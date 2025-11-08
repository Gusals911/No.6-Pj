#!/bin/csh -f

 set bsdir = ${PWD}
 set exdir = ${HOME}/bin
 set pexec = convt.tm.ll.py

 echo "x,y,lon,lat,tmx,tmy,height,landuse" > topo.csv

 foreach i ( `cat domain.csv` )

   set xx  = `echo $i | cut -f1 -d','`
   set yy  = `echo $i | cut -f2 -d','`
   set tmx = `echo $i | cut -f3 -d','`
   set tmy = `echo $i | cut -f4 -d','`
   set hgt = `echo $i | cut -f5 -d','`
   set lui = `echo $i | cut -f6 -d','`

   set geo = `python ${exdir}/${pexec} 2 ${tmx} ${tmy}`

   set lon = `echo ${geo} | cut -f1 -d' ' | cut -c1-10`
   set lat = `echo ${geo} | cut -f2 -d' ' | cut -c1-9`

   echo "${xx},${yy},${lon},${lat},${tmx},${tmy},${hgt},${lui}" >> topo.csv

 end

 exit()
