#!/bin/bash

NUM=200000000 
OUTPUT=1

while getopts hn:o: opt
do
		case $opt in
				h)
						echo "sudo ./$(basename $0) [-h] [-n NUM]
options:
		-h show help
		-n set the number of KV pairs (default: 200,000,000)
		-o set the number of result file (i.e. leveled'1'.txt)"
						exit 0
						;;
				n) 
						NUM=$OPTARG
						echo "$NUM items"
						;;
				o)
						OUTPUT=$OPTARG
						echo "filename: $OUTPUT"
						;;
		esac
done

SCRIPT="./db_bench --benchmarks="ycsbfilldb,ycsbwklda,ycsbwkldc,stats" --db=/nvme/rocksdb-data --statistics"
OPTION="--num=$NUM --value_size=48"
CLEAN="rm /nvme/rocksdb-data/* && sync; sudo echo 3 > /proc/sys/vm/drop_caches"
SPACE="df -h /nvme"
RESULT="/home/ss/rocksdb-bench-result"

#############
#  SCRIPTS  #
#############

echo $CLEAN | bash
echo $SPACE | bash > $RESULT/leveled$OUTPUT.txt
$SCRIPT $OPTION --compaction_style=0 >> $RESULT/leveled$OUTPUT.txt
echo $SPACE | bash >> $RESULT/leveled$OUTPUT.txt

echo $CLEAN | bash
echo $SPACE | bash > $RESULT/universal$OUTPUT.txt
$SCRIPT $OPTION --compaction_style=1 >> $RESULT/universal$OUTPUT.txt
echo $SPACE | bash >> $RESULT/universal$OUTPUT.txt
