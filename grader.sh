#!/bin/bash
TEMP_FILE=`tempfile`
SEPERATOR='-------------------------------------------'

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
	title=${file:0:-3}
	in=$title.in
	out=$title.out

	echo $SEPERATOR
	nr=$(($nr+1))
	echo "TEST #$nr ($title)"
	outputTemp=`tempfile`
	/usr/bin/time -o $outputTemp -f "%U user %S system %E elapsed" $prog < $in > $TEMP_FILE
	time=`cat $outputTemp`
	echo -n "STATUS: "
	if [ -f $out ]; then
		diff -q $TEMP_FILE $out > /dev/null
		if [ $? -eq 0 ]; then
			echo "CORRECT"
		else
			countWrong=$((countWrong+1))
			echo "WRONG"
			echo "Received:"
			head $TEMP_FILE
			echo "Correct:"
			head $out
			
			if [ -f $title.txt ]; then
				echo Notes:
				cat $title.txt
			fi
		fi
	else
		mv $TEMP_FILE $out
		echo "Solution missing, created:"
		cat $out | head
	fi
	echo "TIME: $time"
done

echo $SEPERATOR

if [ $countWrong -gt 0 ]; then
	echo "$countWrong/$nr tests failed."
else
	echo "All tests correct."
fi

rm -f $TEMP_FILE
