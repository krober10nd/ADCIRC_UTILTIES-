#!/bin/bash 
awk '/STA/ {print "***MARKER***";} / / {print $0;}' $1 > temp 
echo "***MARKER***" >> temp
awk "/$2 /{flag=1;next}/MARKER/{flag=0}flag" temp  > $2
rm temp
