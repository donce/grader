#!/bin/bash
TEMP_FILE=`tempfile`

nr=0

countWrong=0

if [ $# -eq 0 ]; then
	echo "Argument missing"
	exit 1
fi

prog=$1
if [ ! -f $prog ]; then
	echo "File \"$prog\" does not exist"
	exit 1
fi

<<nereik
while [ $# -gt 0 ]
do
	echo $1
	shift 1
done;
nereik

for file in *.in
do
	echo "$file"
	title=${file:0:-3}
	in=$title.in
	out=$title.out

	echo ---------------------
	nr=$(($nr+1))
	echo "TEST #$nr ($title)"
	$prog < $in > $TEMP_FILE
	if [ -f $out ]; then
		if [ `diff -q $TEMP_FILE $out` ]; then
			countWrong=$((countWrong+1))
			echo "WRONG"
			echo "Received:"
			head $TEMP_FILE
			echo "Correct:"
			head $out
		else
			echo "CORRECT"
		fi
	else
		mv $TEMP_FILE $out
		echo "Solution missing, created:"
		cat $out | head
	fi
done

rm -f $TEMP_FILE
