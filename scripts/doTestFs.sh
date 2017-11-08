#!/bin/bash

COUNT=10000

CACHES=("/test/files" "/test1/files" "/test2/files")

#sudo iostat -xdy 2 > iostat.out &

ITERATION=0

for cacheType in ${CACHES[*]}
do
	# Start iostat porces
	iostat -xdy 1 > $ITERATION.out &
	# Save PID of command just launched:
    last_pid=$!
	
	echo -e "$cacheType\t" | tr '\n' '\t'
	./testFs.sh -p "$cacheType" -n $COUNT
	
	# Stop iostat proces
	kill -KILL $last_pid 2&>1 > /dev/null
	
	let "ITERATION = ITERATION + 1"
	sleep 20
done
