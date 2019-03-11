#!/bin/bash

##
## Global variable used to count data lines in CSV file
valid_lines=0

##
## Function does a very basic file parse, ignore all lines starting with a hash
## and all blank lines.
##
## Params:
##    $1 - The file name of the mapping CSV file
##    $2 - The name of the callback function to be called with each non-comment
##         and non-blank line of the file
function ParseCSV {
   map_file="$1"
   callback="$2"
   while read line
   do
      # Any blank line or line beginning with a hash is a comment.
      [ "${line:0:1}" == "#" ] && continue
      grep "^\s*$" <<< "$line" && continue

      # Line looks good, process it by passing it to the callback.
      $callback "$line"
   done < $map_file
}

##
## Callback counts the number of non-comment and non-blank links in the file
##
## Params:
##    $1 - The file name of the mapping CSV file
function CountValidLines {
   line="$1"
   valid_lines=$((valid_lines + 1))
}


##
## Callback fills in the globals mapping_src, mapping_webrtc and mapping_vbuffer from
## the mapping CSV file. See script header for information about the mapping file.
##
## Params:
##    $1 - The file name of the mapping CSV file
function ParseSingleCSVLine {
   line="$1"
   
   IFS="," read -a line_split <<< $line

   for i in $(seq 0 $((${#line_split[*]} - 1)))
   do
      # Trim whitespace on both sides of string
      line_split[$i]="$(echo ${line_split[$i]} | sed -e 's/^\s*(.*)\s*$/\$1/')"
   done

   ## Do something with ${line_split[i]} which now contains the ith cell data
}

ParseCSV $map_file CountValidLines
ParseCSV $map_file ParseSingleCSVLine
