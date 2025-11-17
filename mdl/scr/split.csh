#!/bin/csh -f

 foreach i ( `cat ${tm1file}` )

   set value = `echo $i | cut -f4 -d'='`
   echo ${value} >> ${tm2file}

 end
