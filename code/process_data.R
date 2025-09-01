### Title:    Process Data for Practical Exercises
### Author:   Kyle M. Lang
### Created:  2022-09-26
### Modified: 2022-10-15

library(dplyr)
library(magrittr)
library(labelled)
library(haven)

## This path assumes the working directory is set to the root directory of this 
## repo (e.g., by /tcsm.Rproj)
dataDir <- "../../data/"

###-Week 3-------------------------------------------------------------------###

ess <- read.csv(paste0(dataDir, "essround1-b.csv"))

## Compute age from birthyear:
ess$age <- 2002 - ess$yrbrn

## Recode the four character values into two factor levels:
ess$polintr_bin <- recode_factor(ess$polintr,
                                         "Not at all interested" = "Low Interest",
                                         "Hardly interested" = "Low Interest",
                                         "Quite interested" = "High Interest",
                                         "Very interested" = "High Interest")

## Check the conversion:
table(old = ess$polintr, new = ess$polintr_bin)

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

###-Week 6-------------------------------------------------------------------###

suicide <- read_spss(paste0(dataDir, "suiciderisk.sav")) %>% unlabelled()

## Convert "gender" to a more appropriate form:
suicide %<>% 
  mutate(sex = factor(gender, 
                      levels = c("females", "males"), 
                      labels = c("female", "male")
                      )
         ) %>% 
  select(-gender)

## Save the data as RDS:
saveRDS(suicide, paste0(dataDir, "suicide_risk.rds"))
