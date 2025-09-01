### Title:    Render R Markdown Files
### Author:   Kyle M. Lang
### Created:  2023-07-25
### Modified: 2023-07-25

## Extract command line arguments:
args <- commandArgs(trailingOnly = TRUE)

## Render each of the RMD files:
lapply(args, rmarkdown::render) 
