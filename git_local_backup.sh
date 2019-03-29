#!/bin/bash

PARENT_NAME="$1"
DEST_ROOT="$2"

branch_name="$(git branch 2> /dev/null \
                | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/' | sed -e 's/^\s*//g')"
dest_fname="$(date +"%Y%m%d_%H%M%S")_$(sed -e 's/\//_/g' <<< "$branch_name")"

# Note this has some short comings. If you have forward merged you mainline 
# since you branched this might fail - untested
parent_sha1=$(git rev-parse --short $PARENT_NAME)
head_sha1=$(git rev-parse --short HEAD)

committed_diff_fname=""
uncached_diff_fname="${dest_fname}.diff.uncached"
cached_diff_fname="${dest_fname}.diff.cached"


if [ "$upc2_dev_sha1" != "$head_sha1" ]; then
	common_ancestor=$(git rev-parse --short $(git merge-base $PARENT_NAME $branch_name))
	committed_diff_fname="${dest_fname}.diff.committed_${common_ancestor}_to_HEAD"
	git diff "$common_ancestor" HEAD > "$DEST_ROOT/$committed_diff_fname"
fi

git diff > "$DEST_ROOT/$uncached_diff_fname"
git diff --cached > "$DEST_ROOT/$cached_diff_fname"
