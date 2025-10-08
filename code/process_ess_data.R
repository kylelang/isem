### Title:    Process ESS Data for Practical Exercises
### Author:   Kyle M. Lang
### Created:  2022-09-26
### Modified: 2025-10-08

###-WARNING----------------------------------------------------------------------------------------------------------###
###
### This script is half-finished and not actually used to process any data.
###
###------------------------------------------------------------------------------------------------------------------###

rm(list = ls(all = TRUE))

library(dplyr)

dataDir  <- "data/ess"
fileName <- "ESS1e06_7.csv"
ess      <- read.csv(here::here(dataDir, fileName))

targetNames <- c(
  "name"
  , "essround"
  , "edition"
  , "proddate"
  , "cntry"
  , "idno"
  , "trstlgl"
  , "trstplc"
  , "trstun"
  , "trstep"
  , "trstprl"
  , "stfhlth"
  , "stfedu"
  , "stfeco"
  , "stfgov"
  , "stfdem"
  , "pltinvt"
  , "pltcare"
  , "trstplt"
  , "imsmetn"
  , "imdfetn"
  , "eimrcnt"
  , "eimpcnt"
  , "imrcntr"
  , "impcntr"
  , "qfimchr"
  , "qfimwht"
  , "imwgdwn"
  , "imhecop"
  , "imtcjob"
  , "imbleco"
  , "imbgeco"
  , "imueclt"
  , "imwbcnt"
  , "imwbcrm"
  , "imrsprc"
  , "pplstrd"
  , "vrtrlg"
  , "shrrfg"
  , "rfgawrk"
  , "gvrfgap"
  , "rfgfrpc"
  , "rfggvfn"
  , "rfgbfml"
  , "gndr"
  , "yrbrn"
  , "edulvla"
  , "eduyrs"
  , "polintr"
  , "lrscale"
)

ess <- ess[targetNames]

## Compute age from birthyear:
ess$age <- 2002 - ess$yrbrn

colSums(ess == "", )

## Recode the four character values into two factor levels:
ess$polintr_bin <- recode_factor(
  ess$polintr,
  "Not at all interested" = "Low Interest",
  "Hardly interested" = "Low Interest",
  "Quite interested" = "High Interest",
  "Very interested" = "High Interest",
  .default = NA
)

unique(ess$polintr)

?recode_factor

## Check the conversion:
table(old = ess$polintr, new = ess$polintr_bin, useNA = "always")
?table


## Recode the extreme levels of political orientation:
tmp <- recode(ess$lrscale,
              "Left" = 0,
              "Right" = 10,
              .default = as.numeric(ess$lrscale)
              )

## Check the conversion:
table(old = ess$lrscale, new = tmp)

## Overwrite the old variable:
ess$lrscale <- tmp

## Create a proper factor for sex:
ess$sex <- factor(ess$gndr)

## Save the processed data:
saveRDS(ess, paste0(dataDir, "ess_round1.rds"))
