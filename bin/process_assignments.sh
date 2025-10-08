#!/bin/bash

### Title:    Process ISEM Assignment Submissions
### Author:   Kyle M. Lang
### Created:  2024-10-03
### Modified: 2025-10-07

### Description:
# This script should automagically process the assignment downloads from BrightSpace
# 1. Unzip the download archive and move the download archive to ./downloads/
# 2. Give the directories consistent names

### Usage:
# ./process_assignments.sh ASSIGNMENT_NUMBER BS_DOWNLOAD_FILE.zip

function lss () {
  ls -dr */ | grep -v downloads | grep -v duplicates
}

## Unzip the archive downloaded from BrightSpace
7z x "$2"

mkdir downloads duplicates
mv "$2" downloads/

rename.ul --all " " "_FML_" ./*

# if [ "$1" -eq "3" ]; then
#   s0='s/^Assignment_3_//'
# elif [ "$1" -eq "33" ]; then
#   s0='s/^A3_Resit_//'
# else
#   s0='s/^.*Group_/g/'
# fi

for x in `lss`; do
  n=`echo $x | sed s/^.*group_FML_// | sed s/_FML_-.*//`

  nchar=`echo $n | wc -m`
  if [ $nchar -gt 2 ]; then
    d=g$n
  else
    d=g0$n
  fi

  if [ -e $d ]; then
    mv $x duplicates/
    rename.ul --all "_FML_" " " duplicates/$x
  else
    mv $x $d
  fi
done
