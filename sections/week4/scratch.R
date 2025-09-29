install.packages("semptools")

source(here::here("code", "supportFunctions.R"))

library(dplyr)
library(lavaan)
library(magrittr)
library(semPlot)
library(semptools)

dataDir <- "data"
cattell <- readRDS(here::here(dataDir, "cattell.rds"))

head(cattell)

mod1 <- '
warmth =~ A1 + A2 + A3 + A4 + A5 + A6 + A7 + A8 + A9 + A10
'

out1.1 <- cfa(mod1, data = dat1)
out1.2 <- cfa(mod1, data = dat1, std.lv = TRUE)
out1.3 <- cfa(mod1, data = dat1, std.lv = TRUE, meanstructure = TRUE)

fitMeasures(out1.1)

partSummary(out1.1, 4)

summary(out1.1)
summary(out1.2)
summary(out1.3)

semPaths(out1.1)
semPaths(out1.2)
semPaths(out1.3)

colnames(dat1)

mod2 <- '
warmth =~ A1 + A2 + A3 + A4 + A5 + A6 + A7 + A8 + A9 + A10
dominance =~ D1 + D2 + D3 + D4 + D5 + D6 + D7 + D8 + D9 + D10
'

out2.1 <- cfa(mod2, data = dat1)
out2.2 <- cfa(mod2, data = dat1, std.lv = TRUE)
out2.3 <- cfa(mod2, data = dat1, std.lv = TRUE, meanstructure = TRUE)

tmp <- parameterEstimates(out2.1) |> filter(lhs == "warmth", op == "~~", rhs == "dominance")

tmp$est
tmp$se
tmp$z
tmp$p

prettyPValue(0.02555895) |> noquote()

tmp <- partSummary(out2.1, 8)

class(tmp)

length(tmp)

tmp2 <- unlist(tmp)

summary(out2.1)
summary(out2.2)
summary(out2.3)

semPaths(out2.1, whatLabels = "est")
semPaths(out2.2)
semPaths(out2.3)

inspect(out1.1, "est")$psi |> as.numeric()
inspect(out1.2, "est")$lambda
inspect(out2.3, "est")

###------------------------------------------------------------------------------------------------------------------###

colnames(cattell)

mod1 <- '
warmth     =~ A1 + A2 + A3 + A4 + A5 + A6 + A7 + A8 + A9 + A10
liveliness =~ E1 + E2 + E3 + E4 + E5 + E6 + E7 + E8 + E9 + E10
vigilance  =~ I1 + I2 + I3 + I4 + I5 + I6 + I7 + I8 + I9 + I10
tension    =~ P1 + P2 + P3 + P4 + P5 + P6 + P7 + P8 + P9
'

mod1 <- '
warmth     =~ A6 + A7 + A8 + A9 + 1*A10
liveliness =~ 1*E1 + E2 + E3 + E4 + E5 + E6 + E7 + E8 + E9 + E10
vigilance  =~ 1*I1 + I2 + I3 + I4 + I5 + I6 + I7 + I8 + I9 + I10
tension    =~ 1*P1 + P2 + P3 + P4 + P5 + P6 + P7 + P8 + P9
'

out1 <- cfa(mod1, data = cattell)
# out1 <- lavaan(mod1, data = cattell, auto.fix.first = FALSE, std.lv = FALSE, auto.var = TRUE)
summary(out1)

p0 <- semPaths(
  out1, 
  style = "ram",
  sizeMan = 2,
  node.width = 1,
  equalizeManifest = FALSE
  )

ind_order <- c(paste0("A", 1:10), paste0("E", 1:10), paste0("I", 1:10), paste0("P", 1:9))
ind_fac <- c(rep("warmth", 10), rep("liveliness", 10), rep("vigilance", 10), rep("tension", 9))
fac_layout <- matrix(
  c(NA, "warmth", NA, 
    "liveliness", NA, "vigilance",
    NA, "tension", NA),
  byrow = TRUE, 3, 3)
fac_direct <- matrix(
  c(NA, "up", NA,
    "left", NA, "right",
    NA, "down", NA),
  byrow = TRUE, 3, 3)

p1 <- set_sem_layout(p0,
  indicator_order = ind_order,
  indicator_factor = ind_fac,
  factor_layout = fac_layout,
  factor_point_to = fac_direct
)

plot(p1)

?lavOptions
