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
			echo "	$line:"
			./manmerge.sh $line
		else
			echo "	File $line not found on disk."
			exit 1
		fi
	done < ./manmerge.txt
	echo "Automerge complete! Examine modified files with your mergetool, restage, recompile, and commit."

else
	echo "./manmerge.sh and manmerge.txt not found! Aborting..."
	echo "Abandon with 'git merge --abort && git reset --hard && git clean -f'"
	exit 1
fi

echo 
