#!/bin/bash

DATA=/nvme/rocksdb-data
DATA_BAK=/nvme/rocksdb-data-bak
RESULT=/nvme/result

#### YCSB-C (zipfian)
for i in $(seq 1 8) 
do
		rm $RESULT/keys.txt -f
		rm -r $DATA
		mkdir $DATA
		cp -r $DATA_BAK/* $DATA

		./db_bench --use_direct_io_for_flush_and_compaction=true --use_direct_reads=true --num=6250000 --cache_size=268435456 --key_size=48 --value_size=43 --perf_level=2 --benchmarks="ycsbwkldc" --use_existing_db --YCSB_uniform_distribution=false --threads=8 --cache_numshardbits=$i --db=$DATA > $RESULT/zipf$i.txt
		cp $RESULT/keys.txt $RESULT/keys-zipf$i.txt
done

#### uniform
for i in $(seq 1 8) 
do
		rm $RESULT/keys.txt -f
		rm -r $DATA
		mkdir $DATA
		cp -r $DATA_BAK/* $DATA

		./db_bench --use_direct_io_for_flush_and_compaction=true --use_direct_reads=true --num=6250000 --cache_size=268435456 --key_size=48 --value_size=43 --perf_level=2 --benchmarks="ycsbwkldc" --use_existing_db --YCSB_uniform_distribution=true --threads=8 --cache_numshardbits=$i --db=$DATA > $RESULT/uni$i.txt
		cp $RESULT/keys.txt $RESULT/keys-uni$i.txt
done
