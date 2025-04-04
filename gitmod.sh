#!/bin/bash

# Copy this script to the root/manifest folder that contains alot of sub repositories
# Run this script and it will show you which files under which repositories are modified
# This ensures efficient files modifications tracking and prevent any modified files to be omitted


shopt -s dotglob # Allows hidden files to be seen

iterate_dir(){
	for i in $1/*/ # For every items within the directory
	do
		#echo $i
		if [[ $i == *"/.git/" ]]; then  #if it is a git repo
			pushd $i/../ > /dev/null 2>&1
			git status | grep '^nothing to commit, working tree clean$' > /dev/null
			if [[ $? != 0 ]]; then #Parse only those repos that have modified, uncommitted files
				echo -e "\033[1;33m====================================================================================\033[0m" #\033 is meant for font color, [1;33m is color code for yellow
				echo -e "\033[1;33mOn `pwd`:\033[0m"
				echo -e "\033[1;33m====================================================================================\033[0m"
				git status
			fi
			popd > /dev/null 2>&1
		elif [[ -d $i ]];then # else if it is a directory other than .git/
			iterate_dir $i
		fi
	done
}

if [[ -z $1 ]]; then
	iterate_dir `pwd`
else
	iterate_dir $1
fi
