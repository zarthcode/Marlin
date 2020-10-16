#!/bin/bash
#
# manmerge <file path>
#

filepath=$1
if test -f $1; then

	# determine common ancestor
	commonSHA=`git merge-base HEAD MERGE_HEAD`

	# blurt common/theirs/ours into a file.
	git show MERGE_HEAD:$1 > $1.theirs 2>&1
	if [ $? -ne 0 ]; then
		echo "		...Not in MERGE_HEAD"
		# the file does not exist in MERGE_HEAD.
		rm -f $1.theirs
		exit 0;
	fi
	
	git show $commonSHA:$1 > $1.common 2>&1
	if [ $? -ne 0 ]; then
		echo "		...Not in common"
		# the file does not exist in common.
		rm -f $1.common
		rm -f $1.ours
		rm -f $1.theirs
		exit 0;
	fi

	git show HEAD:$1 > $1.ours 2>&1
	if [ $? -ne 0 ]; then
		echo "		...Not in HEAD"
		# the file does not exist in HEAD.
		rm -f $1.common
		rm -f $1.ours
		rm -f $1.theirs
		exit 0;
	fi




	# Merge items into the output file.
	git merge-file -p $1.ours $1.common $1.theirs > $1
	conflicts=$?
	if [ "$conflicts" -eq 0 ]; then
		echo "		No changes/conflicts."
	elif [ "$conflicts" -gt 0 ]; then
		echo "		$conflicts conflicts ready for merge."
	else
		echo "		Error reported ($conflicts)."
	fi


	# Unstage the file so that it calls attention.
	git reset $1

	# Delete temp files
	rm $1.common $1.theirs $1.ours

	exit 0


else
	echo "		Failed: $1 not found."
	exit 1
fi

