#!/bin/bash

i=1
branches=()
while read a; 
do 
	b=$(echo "$a" | sed -e 's/^\*\s*//g'); 
	branches+=($b)
	echo "$i) $b"; ((i=i+1)); 
done <<< $(git branch)

ip=0
while [ $ip -lt 1 ] || [ $ip -gt ${#branches[*]} ]
do
	echo "Enter branch number: "
	read ip
done

git checkout "${branches[$((ip-1))]}"
