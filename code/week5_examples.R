### Title:    Week 5 CFA Prep
### Author:   Kyle M. Lang
### Created:  2023-10-11
### Modified: 2023-10-11

dataDir <- "../../../data/"

ess <- readRDS(paste0(dataDir, "ess_round1_attitudes.rds"))
efa <- readRDS(paste0(dataDir, "w4_efa_attitudes.rds"))

x <- efa$loadings
y <- apply(abs(x), 1, which.max)

f <- list()
for(i in unique(y)) f[[i]] <- rownames(x)[y == i]

f
