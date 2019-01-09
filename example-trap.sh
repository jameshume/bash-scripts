#!/bin/bash
###################################################################################################
#
# From http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_12_02.html
#
# There might be situations when you don't want users of your scripts to exit untimely using 
# keyboard abort sequences, for example because input has to be provided or cleanup has to be 
# done. The trap statement catches these sequences and can be programmed to execute a list of
# commands upon catching those signals.
#
# The syntax for the trap statement is straightforward:
#
#    trap [COMMANDS] [SIGNALS]
#
# This instructs the trap command to catch the listed SIGNALS, which may be signal names with or
# without the SIG prefix, or signal numbers. 
#
###################################################################################################
#
# An example implementing traps to clean up temporary files before script exits
#
###################################################################################################

doend=0           # Dummy variable controlling script end
_mktemp_files=( ) # Array to hold a list of all the files added

function cleanup() {
    echo "Cleaning up the following files ${_mktemp_files[*]}"
    rm ${_mktemp_files[*]}
    doend=5
}

# Call cleanup() when script EXITs - this is ANY exit, whether triggered by SIGINT or just a
# normal script termination.
trap cleanup EXIT

# Do some silly work to show how the EXIT trap works
while [ $doend -lt 5 ]; do 
   fname="$(mktemp)"
   echo $doend , $fname
   _mktemp_files+=("$fname")
   sleep 1
   doend=$((doend+=1))
done

