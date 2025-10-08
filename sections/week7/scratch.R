rm(list = ls(all = TRUE))

library(lavaan)
library(dplyr)
library(psych)
library(semPlot)

dataDir <- "data"
ess_fin <- readRDS(here::here(dataDir, "ess_finland.rds"))

## Create a dummy codes by broadcasting a logical test on the factor levels:
ess_fin <- mutate(ess_fin,
                  female = ifelse(sex == "Female", 1, 0),
                  hi_pol_interest = ifelse(polintr_bin == "High Interest", 1, 0)
                  )

## Check the results:
with(ess_fin, table(dummy = female, factor = sex))
with(ess_fin, table(dummy = hi_pol_interest, factor = polintr_bin))

mod_sem <- '
## Define the latent DVs:
institutions =~ trstlgl + trstplc + trstun + trstep + trstprl
satisfaction =~ stfhlth + stfedu  + stfeco + stfgov + stfdem
politicians  =~ pltinvt + pltcare + trstplt

## Specify the structural relations:
institutions ~ female + age + eduyrs + hi_pol_interest + lrscale
satisfaction ~ female + age + eduyrs + hi_pol_interest + lrscale
politicians  ~ female + age + eduyrs + hi_pol_interest + lrscale
'

## Fit the SEM:
fit_sem <- sem(mod_sem, data = ess_fin, fixed.x = FALSE)

## Summarize the results:
summary(fit_sem, fit.measures = TRUE, standardized = TRUE, rsquare = TRUE)

scaleKeys <- list(
  ins_score = c("trstlgl", "trstplc", "trstun", "trstep", "trstprl"),
  sat_score = c("stfhlth", "stfedu", "stfeco", "stfgov", "stfdem"),
  pol_score  = c("pltinvt", "pltcare", "trstplt")
  )

scaleScores <- scoreItems(keys = scaleKeys, items = ess_fin, impute = "none")

ess_fin <- data.frame(ess_fin, scaleScores$scores)

mod_pa <- '
## Specify the structural relations:
ins_score ~ female + age + eduyrs + hi_pol_interest + lrscale
sat_score ~ female + age + eduyrs + hi_pol_interest + lrscale
pol_score ~ female + age + eduyrs + hi_pol_interest + lrscale
'

## Fit the path analysis:
fit_pa <- sem(mod_pa, data = ess_fin, fixed.x = FALSE)

## Summarize the results:
summary(fit_pa, fit.measures = TRUE, standardized = TRUE, rsquare = TRUE)

estSem <- parameterEstimates(fit_sem, standardized = TRUE)
estPa  <- parameterEstimates(fit_pa, standardized = TRUE)

x <- estSem |> filter(op == "~") |> select(lhs, rhs, std.all) |> rename(X = rhs, SEM = std.all)
y <- estPa |> filter(op == "~") |> select(std.all) |> rename(PA = std.all)

beta <- data.frame(x, y)

filter(beta, lhs == "institutions") |> select(-lhs)
filter(beta, lhs == "satisfaction") |> select(-lhs)
filter(beta, lhs == "politicians") |> select(-lhs)

xx <- estSem |>
  filter(op == "~") |>
  select(lhs, rhs, est, z, pvalue) |>
  rename(X = rhs, SEM_Est = est, SEM_Z = z, SEM_P = pvalue)
yy <- estPa |>
  filter(op == "~") |>
  select(est, z, pvalue) |>
  rename(PA_Est = est, PA_Z = z, PA_P = pvalue)

tests <- data.frame(xx, yy)

filter(tests, lhs == "institutions") |> select(-lhs)
filter(tests, lhs == "satisfaction") |> select(-lhs)
filter(tests, lhs == "politicians") |> select(-lhs)

data.frame(SEM = lavInspect(fit_sem, "r2") |> tail(3), PA = lavInspect(fit_pa, "r2") |> as.numeric()) |> knitr::kable(digits = 3)

join(x, y)

fitMeasures(fit_sem, "ntotal")
fitMeasures(fit_pa, "ntotal")

scaleScores$scores
scaleScores$alpha
ls(scaleScores)

scaleScores

condom <- read.csv(here::here(dataDir, "toradata.csv"), stringsAsFactors = TRUE)
head(condom)

mod_sem <- '
## Define the latent variables:
attitudes =~ attit_1 + attit_2 + attit_3
norms     =~ norm_1  + norm_2  + norm_3

## Define the structural model:
intent   ~ attitudes + norms
behavior ~ intent
'

out_sem <- sem(mod_sem, data = condom)

summary(out_sem)
inspect(out_sem, "est")

mod_sem2 <- '
## Define the latent variables:
attitudes =~ attit_1   + attit_2   + attit_3
norms     =~ norm_1    + norm_2    + norm_3
control   =~ control_1 + control_2 + control_3

## Define the structural model:
behavior ~ intent + control
intent   ~ attitudes + norms
'

out_sem2 <- sem(mod_sem2, data = condom)

summary(out_sem2)

semPaths(out_sem2, structural = TRUE)
?semPaths

