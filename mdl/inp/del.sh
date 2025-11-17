#!/bin/sh
path="/home/mdl/inp"

find ${path}/gfs/ -mtime +20 -delete
find ${path}/gfs_forecast/ -mtime +20 -delete
find ${path}/restart/ -mtime +20 -delete
find ${path}/surf/pr/
find ${path}/up/
