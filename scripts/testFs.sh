#!/bin/bash

# Before run:
# sudo su -c 'sync; echo 1 > /proc/sys/vm/drop_caches'

TEST_PATH="/test/files"
NUM_FILES=100
DEBUG_MODE=false
FILES_LIST=""


# Processing input parameters
while [ 1 ] ; do 
    if [ "$1" = "-h" ] ; then 
		echo
        echo "Testing fs"
        echo
        exit 0
    elif [ "$1" = "-n" ] ; then
        shift ; NUM_FILES="$1"
    elif [ "$1" = "-p" ] ; then
        shift ; TEST_PATH="$1"
	elif [ "$1" = "-d" ] ; then
        shift ; DEBUG_MODE="true"
	elif [ -z "$1" ] ; then 
        break # Keys gi=one
    else 
        echo "Error: unknown key" 1>&2 
        exit 1 
    fi 
    shift 
done 

log() {
	echo "[$(date +'%Y-%m-%d %H:%M:%S')] $@"
}

dbg() {
	if $DEBUG_MODE; then
		echo "[$(date +'%Y-%m-%d %H:%M:%S')] $@"
	fi
}

err() {
	echo "[$(date +'%Y-%m-%d %H:%M:%S')] $@" >&2
}

export -f log dbg err

countTime() {
	if $DEBUG_MODE; then
		# { time $1; } 2>&1 | grep "real" | grep -v "real " | sed -En 's/real\t/- time: /p' | xargs -I {} bash -c 'log '{}
		time $1
	else
		{ time $1; } 2>&1 | grep "real" | grep -v "real " | sed -En 's/real\t//p' | tr '\n' '\t'
	fi
}

writeFilesDd() {
	for ((i=1; i<$NUM_FILES; i++))
	do
		sync; dd if=/dev/zero of=$TEST_PATH/$i.test bs=1b count=35 status=noxfer >& /dev/null; sync
	done
}

writeFiles() {
	content=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 35000 | head -n 1)
	for ((i=1; i<$NUM_FILES+1; i++))
	do
		echo $content > $TEST_PATH/$i.test
	done
}

clearCache() {
	sudo su -c 'sync; echo 3 > /proc/sys/vm/drop_caches'
	sleep 5
}

readFilesDd() {
	for ((i=1; i<$NUM_FILES; i++))
	do
		dd  if=$TEST_PATH/$i.test of=/dev/null bs=1b count=35 status=noxfer >& /dev/null
	done
}

readFiles() {
	content=""
	for ((i=1; i<$NUM_FILES; i++))
	do
		content=$(cat $TEST_PATH/$i.test)
	done
}

randomReadFilesDd() {
	OLD_IFS=$IFS
    IFS=$'\n'
	for line in $FILES_LIST; do
		sudo dd  if=$TEST_PATH/$line.test of=/dev/null bs=1b count=35 status=noxfer >& /dev/null
	done
	IFS=$OLD_IFS
}

randomReadFiles() {
	content=""
	OLD_IFS=$IFS
    IFS=$'\n'
	for line in $FILES_LIST; do
		content=$(cat $TEST_PATH/$line.test)
	done
	IFS=$OLD_IFS
}

deleteFiles() {
	rm -rf $TEST_PATH
	mkdir -p $TEST_PATH
}


#######################################
# MAIN
#######################################

dbg "Writing files ..."
countTime writeFiles

dbg "Clear caches ..."
clearCache

dbg "Read files ..."
countTime readFiles

dbg "Clear caches ..."
clearCache

FILES_LIST=$(eval echo {1..$NUM_FILES} | xargs shuf -e)

dbg "Random read files ..."
countTime randomReadFiles

dbg "Deleting files ..."
countTime deleteFiles

echo
exit 0


