#!/bin/bash

ETAPA=

while [ "$1" != "" ]; do
	case $1 in
		-e | --etapa ) 	shift
						ETAPA=$1
						;;
		* )				exit 1
	esac
	shift
done

if [ -z "$ETAPA" ]
then
	echo "Please provide the parameter (-e/--etapa), an integer between 1 and 2"
	exit 1
fi

TEST_DIR="test${ETAPA}/*"

for testfile in $TEST_DIR
do
	echo "************ TEST $testfile ************" >> test_result.txt
	cat $testfile >> test_result.txt
	cat $testfile | ./etapa$ETAPA/etapa$ETAPA >> test_result.txt 2>&1
done