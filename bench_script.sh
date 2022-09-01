#!/bin/bash

SCRIPT="./db_bench --benchmarks="ycsbfilldb,ycsbwklda,ycsbwkldc,stats" --db=/nvme/rocksdb-data --statistics"
OPTION="--num=200000000 --value_size=48"
CLEAN="rm /nvme/rocksdb-data/* && sync; sudo echo 3 > /proc/sys/vm/drop_caches"
SPACE="df -h /nvme"
RESULT="~/rocksdb-bench-result"

#############
#  SCRIPTS  #
#############

echo $CLEAN | bash
echo $SPACE | bash > $RESULT/leveled.txt
$SCRIPT $OPTION --compaction_style=0 >> $RESULT/leveled.txt
echo $SPACE | bash >> $RESULT/leveled.txt

echo $CLEAN | bash
echo $SPACE | bash > $RESULT/universal.txt
$SCRIPT $OPTION --compaction_style=1 >> $RESULT/universal.txt
echo $SPACE | bash >> $RESULT/universal.txt
