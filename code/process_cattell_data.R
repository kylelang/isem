### Title:    Process Cattell 16PF Data for Lab Exercises
### Author:   Kyle M. Lang
### Created:  2025-09-26
### Modified: 2025-09-30

rm(list = ls(all = TRUE))

library(dplyr)
library(magrittr)
library(mice)

set.seed(235711)

## Load the raw data
dataDir <- "data"
cattell <- dat0 <- read.table(here::here(dataDir, "16PF", "data.csv"), na.strings = "0", sep = "\t", header = TRUE)

## Create factors
cattell %<>%
  mutate(
    gender = factor(gender, levels = 1:3, labels = c("male", "female", "other")),
    source = factor(source, levels = 1:6, labels = c("homepage", "google", "facebook", "edu", "wikipedia", "other"))
    )

## Check
table(cattell$gender, dat0$gender, useNA = "always")
table(cattell$source, dat0$source, useNA = "always")

## Sample 5000 rows
cattell <- slice_sample(cattell, n = 5000)

## Impute missing data
predMat <- quickpred(cattell, mincor = 0.1, exclude = c("accuracy", "country", "elapsed"))
miceOut <- mice(cattell, m = 1, maxit = 10, predictorMatrix = predMat)
cattell <- mice::complete(miceOut, 1)

saveRDS(cattell, here::here(dataDir, "cattell_imputed_5000.rds"))

## Sample 1000 rows for use in the lab exercises
cattell <- slice_sample(cattell, n = 1000)
saveRDS(cattell, here::here(dataDir, "cattell.rds"))
