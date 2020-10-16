#!/bin/bash
#
# automerge <remote branch>
#

# Exit when any command fails
set -e
# start a merge
echo "Merging $1..."
git fetch
git merge $1 -X theirs --no-commit

if test -f ./manmerge.sh && test -f ./manmerge.txt; then

	# Process the files listed in manmerge.txt
	echo "Prepping files in manmerge.txt for manual merge:"
	while read line; do
		# Read line and process it
		if test -f $line; then
			./manmerge.sh $line
		else
			echo "File $line not found."
			exit 1
		fi
	done < ./manmerge.txt
	echo "Automerge complete, please examine the files, restage, recompile, and commit."

else
	echo "./manmerge.sh and manmerge.txt not found! Aborting..."
	git merge --abort
	git reset --hard
	exit 1
fi

echo 
