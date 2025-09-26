# install.packages("semPlot")

source(here::here("code", "supportFunctions.R"))

library(dplyr)
library(lavaan)
library(magrittr)
library(semPlot)

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
dominance =~ D1 + D2 + D3 + D4 + D4 + D5 + D6 + D7 + D8 + D9 + D10
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
