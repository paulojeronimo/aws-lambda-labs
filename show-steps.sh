#!/usr/bin/env bash
set -eou pipefail

echo "---- Step 1: load your environment variables ----"
echo "$ source ./config.sh"
echo

echo "---- Step 2: create a build directory and change to it ----"
echo "$ mkdir -p build && cd \$_"
echo

count=3
while read step
do
	echo "---- Step $count: ($step) ----"
	echo -n "$ "
	cat steps/$step
	echo
	(( ++count ))
done < steps/order.txt
