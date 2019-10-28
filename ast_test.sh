#!/bin/bash

#############################################################
#						FOR E3 ONLY							#
#					Execute with Python3					#
#############################################################

VALGRIND=false
CONVERT_SCRIPT=convert_csv_dot.py
TCNO_SCRIPT=ast_test.py

while [ "$1" != "" ]; do
	case $1 in
		-m | --valgrind )		VALGRIND=true
								;;	
		* )				exit 1
	esac
	shift
done

rm test_result.txt
echo "test, tcno, valgrind" >> test_result.txt

TEST_DIR="test3/"

for test in `ls $TEST_DIR -I '*.*'` `cd $TEST_DIR; ls *.ptg`
do
	printf "$test," >> test_result.txt
	if [ "$VALGRIND" = true ]; then
		# Executes with valgrind		
		rm -f valgrind.txt
		valgrind ./etapa3/etapa3 < $TEST_DIR$test 2>&1 | grep -A5 LEAK\ SUMMARY > valgrind.txt
		VGRESULT=$(cat valgrind.txt | cut -d":" -f2| awk '{print $1}' | tr '\n' ' ' | sed "s/,//g")
		if [[ $VGRESULT = "" ]]; then
		    VGRESULT="no leaks are possible"
		    VG=0
		else
		    VG=$(echo $VGRESULT | tr ' ' '+' | bc)
		fi
	else
		# Executes without valgrind
		cat $TEST_DIR$test | ./etapa3/etapa3
	fi

	# At this point we have the output at ./e3.csv
	DOT_REF=$TEST_DIR$test.ref.dot
	DOT_GEN=$TEST_DIR$test.gen.dot

	# Turn the output into a .dot file
	python3 $CONVERT_SCRIPT e3.csv >	$DOT_GEN

	TCNO_RESULT=$(python3 $TCNO_SCRIPT $(pwd)/$DOT_GEN $(pwd)/$DOT_REF)
	TCNOCODE=$?

	printf "$TCNOCODE," >> test_result.txt
	echo "$VG" >> test_result.txt
done