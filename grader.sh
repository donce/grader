PROG=main
temp=temp.out

for file in `find . -name '*.in'`
do
	test=${file:2:-3}
	in=$test.in
	out=$test.out

	echo ---------------------
	echo "Running $test"
	echo ---------------------
	./$PROG < $in > $temp
	if [ -f $out ]; then
		diff -s -y $temp $out"
	else
		mv $temp $out
		echo "Solution missing - created"
	fi
done

rm temp.out
