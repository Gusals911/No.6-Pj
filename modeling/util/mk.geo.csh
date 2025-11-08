#!/bin/csh -f

## User Define #############################################
 set xorigin = 396512
 set yorigin = 304936
 set dxdy    = 100
 set xgrid   = 300
 set ygrid   = 300
############################################################

 set bsdir = ${PWD}
 set exdir = ${HOME}/bin

 time ${exdir}/mk.geo.exe ${xorigin} ${yorigin} ${dxdy} ${xgrid} ${ygrid}

 exit()
