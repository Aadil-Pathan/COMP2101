#!/bin/bash

var=$(ls /sys/class/net)

for v in $var; do
	if [ "$v" != "lo" ]; then
		interface=$v
	fi
done
