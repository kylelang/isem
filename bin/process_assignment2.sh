#!/bin/bash

### Title:    Process ISEM Assignment 2 Submissions
### Author:   Kyle M. Lang
### Created:  2024-10-03
### Modified: 2025-11-10

### Description:
# This script should automagically process the assignment downloads from BrightSpace
# 1. Unzip the download archive and move the download archive to ./downloads/
# 2. Give the directories consistent names

### Usage:
# ./process_assignments.sh BS_DOWNLOAD_FILE.zip

function lss () {
  ls -dr */ | grep -v downloads | grep -v duplicates
}

## Unzip the archive downloaded from BrightSpace
7z x "$1"

mkdir downloads duplicates
mv "$1" downloads/

rename.ul --all " " "_" ./*

for x in `lss`; do
  d=`echo $x | sed s/^.*[0-9]_-_// | sed s/_-_.*//`

  if [ -e $d ]; then
    mv $x duplicates/
    rename.ul --all "_" " " duplicates/$x
  else
    mv $x $d
  fi
done
