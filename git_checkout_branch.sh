#!/bin/bash

i=1
branches=()
while read branch_name;
do
	branch_name_cleaned=$(sed -e 's/^\*\s*//g' <<< "$branch_name")
	branches+=($branch_name_cleaned)
	echo "$i) $branch_name_cleaned"
	((i=i+1))
done <<< $(git branch)

ip=0
while [ $ip -lt 1 ] || [ $ip -gt ${#branches[*]} ]
do
	echo "Enter branch number: "
	read ip
done

git checkout "${branches[$((ip-1))]}"
