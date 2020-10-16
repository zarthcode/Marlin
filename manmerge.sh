!/bin/bash
#
# manmerge <file path>
#

filepath=$1
if test -f $1; then

	# determine common ancestor
	commonSHA=`git merge-base HEAD MERGE_HEAD`

	# blurt common/theirs/ours into a file.
	git show $commonSHA:$1 > $1.common
	git show HEAD:$1 > $1.ours
	git show MERGE_HEAD:$1 > $1.theirs

	# Merge items into the output file.
	git merge-file -p $1.ours $1.common $1.theirs > $1

	# Unstage the file so that it calls attention.
	git reset $1

	# Delete temp files
	rm $1.common $1.theirs $1.ours

	echo "$1"


else
	echo "Manual merge setup failed: $1 not found."
	exit 1
fi

