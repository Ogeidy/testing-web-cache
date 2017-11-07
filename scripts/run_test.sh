#!/bin/bash

CONCURRENT=50
REPEATS=1000
URL_FILE="urls.txt"

CACHES=(btrfs ext4 raiser)

for cacheType in ${CACHES[*]}
do
	echo "Testing $cacheType FS ..."
	sleep 10

	# Start iostat porces
	iostat -xdy 1 > $cacheType.out &
	# Save PID of command just launched:
    last_pid=$!

    # Change FS var to current fs type
	sed -i "1s/.*/FS=$cacheType/" $URL_FILE

	# Run siege to populate cache
	siege -b -c $CONCURRENT -r $REPEATS -f $URL_FILE

	sleep 10

	# Run siege to testing cache read speed
	siege -b -c $CONCURRENT -r $REPEATS -f $URL_FILE

	# Stop iostat proces
	kill -KILL $last_pid
done

echo "Clearing caches..."
sudo find /test/ext4_cache/ -maxdepth 1 -type d -name "[a-Z0-9]" -exec rm -rf {} \;
sudo find /test1/btrfs_cache/ -maxdepth 1 -type d -name "[a-Z0-9]" -exec rm -rf {} \;
sudo find /test2/raiser_cache/ -maxdepth 1 -type d -name "[a-Z0-9]" -exec rm -rf {} \;