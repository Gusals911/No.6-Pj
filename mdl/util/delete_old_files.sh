#!/bin/csh

set GFS_DIR = "/home/mdl/inp/gfs"
set RESTART_DIR = "/home/mdl/inp/restart"
set PR_DIR = "/home/mdl/inp/surf/pr"
set UP_DIR = "/home/mdl/inp/up"
set OUT_DIR = "/home/mdl/out"
set LOG_DIR = "/home/mdl/log"

find $GFS_DIR -type f -mtime +1 -exec rm {} \;
find $GFS_DIR -type d -empty -exec rm -r {} \;

find $RESTART_DIR -type f -mtime +1 -exec rm {} \;

find $PR_DIR -type f -mtime +1 -exec rm {} \;
find $PR_DIR -type d -empty -exec rm -r {} \;

find $UP_DIR -type f -mtime +1 -exec rm {} \;

find $OUT_DIR -type f -mtime +5 -exec rm {} \;
find $OUT_DIR -type d -empty -exec rm -r {} \;

find $LOG_DIR -type f -mtime +30 -exec rm {} \;
find $LOG_DIR -type d -empty -exec rm -r {} \;

