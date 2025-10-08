#!/bin/bash

### Title:    Process TCSM Assignment Submissions
### Author:   Kyle M. Lang
### Created:  2024-10-03
### Modified: 2024-11-04

### Description:
# This script should automagically process the assignment downloads from BB
# 1. Unzip the download archive and move the download archive to ./tmp/
# 2. Replace all spaces in filenames with underscores
# 3. Remove all BB boilerplate from filenames and give the files consistent names
# 4. Parse the file names to extract the group numbers/student IDs and create a directory for each
# 5. Move all relevant files to the matching directory

### Usage:
# ./process_assignments.sh ASSIGNMENT_NUMBER BB_DOWNLOAD_FILE.zip
# ASSIGNMENT_NUMBER = 33 -> A3 Resit

function lss () {
  ls --ignore=*.sh -p | grep -v /$
}

unzip "$2"

mkdir tmp
mv "$2" tmp/

rename.ul --all " " "_" ./*

if [ "$1" -eq "3" ]; then
  s0='s/^Assignment_3_//'
elif [ "$1" -eq "33" ]; then
  s0='s/^A3_Resit_//'
else
  s0='s/^.*Group_/g/'
fi

for x in `lss`; do
  f=`echo $x | sed -e $s0 -e 's/_.*\\././'`
  d=`echo $f | sed 's/\\..*//'`

  if [ ! -d "$d" ]; then
    mkdir $d
  fi

  mv $x $d/$f
done
