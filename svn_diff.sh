#!/bin/bash
END_REV="$1"

##
## Get the SVN root
svn_root=$(svn info | grep "Relative URL:" | sed "s/Relative URL:\s*\(.*\)/\1/g" | cut -c 2-)

##
## Create a temporary file to hold the log and write the branches history, stopping at branch creation, into the file.
tf=$(mktemp)
svn log --stop-on-copy --verbose > "$tf"

##
## Get the revision of the branch and the last commit revision
revs=$(grep "r[0-9]" < "$tf" | sed "s/^\(r[0-9][0-9]*\).*/\1/g" | cut -c 2-)
revs_array=($revs)
last_commit=${revs_array[0]}
first_commit=${revs_array[-1]}

if [ -n "$END_REV" ]
then
    last_commit="$END_REV"
fi


##
## For each file modified in the log history, append the relative local path to that file
## to the variable `files`
# https://unix.stackexchange.com/questions/272698/why-is-the-array-empty-after-the-while-loop
files=""
while read fn; do fn2=${fn#"$svn_root"/}; [ -f "$fn2" ] && files="$files $fn2"; done < <(cat "$tf" | grep "^\s*[MAD]"| sed "s/^\s*[MAD]\s*\([^ ][^ ]*\).*/\1/g" | sort | uniq)

##
## Now diff, in one go, all the files listed in `files`
svn diff -"r$first_commit:$last_commit" $files | tee patch.diff
echo -e "\n\n-- Diff available in patch.diff"

##
## Cleanup
rm -f "$tf"
