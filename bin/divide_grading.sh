#!/bin/bash

### Title:    Divide TCSM Grading
### Author:   Kyle M. Lang
### Created:  2024-11-04
### Modified: 2024-11-04

### Description:
# This script should divide the grading load among the teachers as defined in the
# JSON file specified in the first argument.

### Usage:
# ./divide_grading.sh ASSIGNMENT_ALLOCATION.json SUBMISSION_DIRECTORY

SUB_DIR=`echo $2 | sed -e 's/\\///'`

for TEACHER in `jq -r 'keys.[]' $1`; do
  echo "Processing $TEACHER's assignment."
  
  if [ ! -d $TEACHER ]; then
    mkdir $TEACHER
  fi

  for ID in `jq -r .$TEACHER.[] $1`; do
    if [ -d $SUB_DIR/$ID ]; then
      cp -r $SUB_DIR/$ID $TEACHER/$ID
    fi
  done
done
