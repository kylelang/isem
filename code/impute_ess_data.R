### Title:    Impute ESS Data for Practical Exercises
### Author:   Kyle M. Lang
### Created:  2022-09-26
### Modified: 2025-10-08

rm(list = ls(all = TRUE))

library(dplyr)
library(magrittr)
library(mice)

dataDir <- "data"
ess     <- readRDS(here::here(dataDir, "ess_round1.rds"))

predMat <- quickpred(ess, mincor = 0.1, exclude = c("name", "essround", "edition", "proddate", "cntry", "idno", "gndr"))

methVec         <- make.method(ess)
methVec["gndr"] <- ""

miceOut <- mice(ess, m = 1, maxit = 20, method = methVec, predictorMatrix = predMat, seed = 235711)
miceOut$loggedEvents

essImp <- complete(miceOut, 1)

## Compute age from birthyear:
essImp$age <- 2002 - essImp$yrbrn

summary(essImp$age)
hist(essImp$age)

## Recode the four character values into two factor levels:
essImp$polintr_bin <- recode_factor(
  essImp$polintr,
  "Not at all interested" = "Low Interest",
  "Hardly interested" = "Low Interest",
  "Quite interested" = "High Interest",
  "Very interested" = "High Interest"
)

## Check the conversion:
essImp %$% table(old = polintr, new = polintr_bin, useNA = "always")

## Save the processed data:
saveRDS(essImp, here::here(dataDir, "ess_round1_imputed.rds"))

## Extract only the Finnish data
ess_fin <- filter(essImp, country == "Finland")

saveRDS(ess_fin, here::here(dataDir, "ess_finland.rds"))
