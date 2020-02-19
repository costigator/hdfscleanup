#!/bin/bash

# check parameters
if [ $# -ne 2 ]; then
  echo "Usage: cleanup_hdfs.sh [days] [path]"
  exit 1
else
  days=$1
  path=$2
  # print header
  dt=`date '+%d/%m/%Y %H:%M:%S'`
  echo "====================================================================="
  echo "HDFS cleanup startet at $dt"
  echo "Path: " $path
  echo "Days: " $days
fi

# get kerberos ticket (comment if not necessary)
kinit -ik

# get directory size
size=$(/usr/bin/hdfs dfs -du -s -h $path | awk '{print $1 $2}')
echo "Directory size before cleanup:" $size

# delete files
today=`date +'%s'`

/usr/bin/hdfs dfs -ls $path | grep "^d" | while read line ; do
  dir_date=$(echo ${line} | awk '{print $6}')
  difference=$(( ( ${today} - $(date -d ${dir_date} +%s) ) / ( 24*60*60 ) ))
  filePath=$(echo ${line} | awk '{print $8}')
  if [ ${difference} -ge $days ]; then
      echo "Deleting" $filePath
      /usr/bin/hdfs dfs -rm -r $filePath
  fi
done

# get directory size again
size=$(/usr/bin/hdfs dfs -du -s -h $path | awk '{print $1 $2}')
echo "Directory size after cleanup:" $size