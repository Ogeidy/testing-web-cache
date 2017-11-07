#!/bin/bash

COUNT=100000
LENGTH=32
MAIN_URL='http://localhost:8085/$(FS)/'
OUT_FILE="urls.txt"

rm $OUT_FILE

echo "FS=file" >> $OUT_FILE

for ((i=0; i<$COUNT; i++))
do
	fileName=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w $LENGTH | head -n 1)
	echo "$MAIN_URL$fileName" >> $OUT_FILE
done