### Title:    Process Cattell 16PF Data for Lab Exercises
### Author:   Kyle M. Lang
### Created:  2025-09-26
### Modified: 2025-09-26

rm(list = ls(all = TRUE))

set.seed(235711)

library(dplyr)
library(magrittr)

dataDir <- "data"
cattell <- dat0 <- read.table(here::here(dataDir, "16PF", "data.csv"), na.strings = "0", sep = "\t", header = TRUE)

head(cattell)
sapply(cattell, class)

cattell %<>% mutate(gender = factor(gender, levels = 1:3, labels = c("male", "female", "other")))

table(cattell$gender, dat0$gender, useNA = "always")

dat1 <- slice_sample(cattell, n = 1000)

summary(dat1)

saveRDS(dat1, here::here(dataDir, "cattell.rds"))
