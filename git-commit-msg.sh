#!/bin/sh
##
## Rename me to git-commit in your .git/hooks directory or add me to the existing script
##
## Change "TICKET" in the text below to your specific prefix and adjust the \{6\} to the number
## of digits after - it expectes a "tag" like TICKET-123456

parse_git_branch() {
   git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/' | sed -e 's/^\s*//g'
}

echo "[INFO] Running commit script with \$1 = \"$1\""

# Parse the git branch name and fund the TICKET-xxxxxx specifier if it exists
BRANCH=$(parse_git_branch)
BRANCH_TICKET_NUM=$(sed -e 's/.*\(\(ticket\|TICKET\)-[0-9]\{6\}\).*/\1/g' <<< "#$BRANCH")
[ "${BRANCH_TICKET_NUM:0:1}" = "#" ] && BRANCH_TICKET_NUM=""
echo "[INFO] BRANCH_UPM_NUM = \"$BRANCH_UPM_NUM\""

# Make sure the message starts with TICKET-dddddd where d is a number 0-9
grep -i "^TICKET-[0-9]\{6\}" "$1" > /dev/null 2>&1 || {
        echo >&2 Missing ticket number at start of message.
        exit 1
}

# Have to grep here as when merging the commit message file is multi line
MSG_TICKET_NUM=$(sed 's/^\(ticket\|TICKET\)\(-[0-9]\{4\}\).*/\1\2/g' <<< $(grep -i "^TICKET" "$1"))
echo "[INFO] MSG_UPM_NUM = \"$MSG_UPM_NUM\""

# If the branch name exists the TICKET of the branch name must be verfied against the msg
if [ -n "$BRANCH_TICKET_NUM" ]; then
        if [ "$MSG_TICKET_NUM" != "$BRANCH_TICKET_NUM" ]; then
                echo >&2 "The branch TICKET number ($BRANCH_TICKET_NUM) does not match the commit msg TICKET number ($MSG_TICKET_NUM)."
                exit 1
        fi
fi

echo "COMMIT @ $(date) on branch $BRANCH ($TICKET_NUM) with msg \"$(cat $1)\"" >> ~/git_commits_log.txt
