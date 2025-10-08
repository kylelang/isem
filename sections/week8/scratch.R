library(dplyr)

dataDir <- "data"

pgd <- read.table(here::here(dataDir, "PGDdata2.txt"),
                  na.strings = "-999",
                  header = TRUE,
                  sep = "\t") |>
       filter(!is.na(Kin2))

table(pgd$Kin2) / nrow(pgd)
