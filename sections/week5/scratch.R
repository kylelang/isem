install.packages("kableExtra")

library(lavaan)
library(dplyr)

dataDir <- "data"
ess <- readRDS(here::here(dataDir, "ess_round1.rds"))

mod_3f <- '
institutions =~ trstlgl + trstplc + trstun + trstep + trstprl
satisfaction =~ stfhlth + stfedu  + stfeco + stfgov + stfdem
politicians  =~ pltinvt + pltcare + trstplt
'

out_3f <- cfa(mod_3f, data = ess, std.lv = TRUE)

fit <- fitMeasures(out_3f) |> as.list()
x2 <- fit$chisq |> round(2)

x2

est <- inspect(out_3f, "est")
est$psi

colnames(ess)

summary(ess)

x <- ess |> select(lavNames(out_3f))
sapply(x, unique)
tidySEM::descriptives(x) |> select(name, mean, sd, min, max)

ess |> select(lavNames(out_3f)) |> summarize(across(var))

?descriptives
lavInspect(out_3f, "standardized")

desc <- c(
  "Title of dataset",
  "ESS round",
  "Edition",
  "Production date",
  "Country",
  "Respondent's identification number",
  "Trust in the legal system",
  "Trust in the police",
  "Trust in the United Nations",
  "Trust in the European Parliament",
  "Trust in country's parliament",
  "State of health services in country nowadays",
  "State of education in country nowadays",
  "How satisfied with present state of economy in country",
  "How satisfied with the national government",
  "How satisfied with the way democracy works in country",
  "Politicians interested in votes rather than peoples opinions",
  "Politicians in general care what people like respondent think",
  "Trust in politicians",
  "Allow many/few immigrants of same race/ethnic group as majority",
  "Allow many/few immigrants of different race/ethnic group from majority",
  "Allow many/few immigrants from richer countries in Europe",
  "Allow many/few immigrants from poorer countries in Europe",
  "Allow many/few immigrants from richer countries outside Europe",
  "Allow many/few immigrants from poorer countries outside Europe",
  "Qualification for immigration: christian background",
  "Qualification for immigration: be white",
  "Average wages/salaries generally brought down by immigrants",
  "Immigrants harm economic prospects of the poor more than the rich",
  "Immigrants take jobs away in country or create new jobs",
  "Taxes and services: immigrants take out more than they put in or less",
  "Immigration bad or good for country's economy",
  "Country's cultural life undermined or enriched by immigrants",
  "Immigrants make country worse or better place to live",
  "Immigrants make country's crime problems worse or better",
  "Richer countries should be responsible for accepting people from poorer countries",
  "Better for a country if almost everyone share customs and traditions",
  "Better for a country if a variety of different religions",
  "Country has more than its fair share of people applying refugee status",
  "People applying refugee status allowed to work while cases considered",
  "Government should be generous judging applications for refugee status",
  "Most refugee applicants not in real fear of persecution own countries",
  "Financial support to refugee applicants while cases considered",
  "Granted refugees should be entitled to bring close family members",
  "Gender",
  "Year of birth",
  "Highest level of education",
  "Years of full-time education completed",
  "How interested in politics",
  "Placement on left right scale",
  "A factor version of the 'cntry' variable",
  "A factor version of the 'gndr' variable"
  )

sapply(ess, class)

ccc <- colnames(ess)

xxx <- cbind(ccc, desc)

names(desc) <- ccc

desc

length(desc)
length(ccc)

mod_att <- '
## Immigration Policy:
ip =~ imrcntr + eimrcnt + eimpcnt + imsmetn + impcntr + imdfetn 

## Social Threat:
st =~ imbgeco + imbleco + imwbcnt + imwbcrm + imtcjob + imueclt

## Refugee Policy:
rp =~ gvrfgap + imrsprc + rfgbfml + rfggvfn + rfgawrk + rfgfrpc + shrrfg

## Cultural Threat:
ct =~ qfimchr + qfimwht + pplstrd + vrtrlg

## Economic Threat:
et =~ l*imwgdwn + l*imhecop 
'

mod_trust_att <- '
## Trust in Institutions:
institutions =~ trstlgl + trstplc + trstun + trstep + trstprl

## Satisfaction with the Political Situation:
satisfaction =~ stfhlth + stfedu  + stfeco + stfgov + stfdem

## Trust in Politicians:
politicians  =~ pltinvt + pltcare + trstplt

## Immigration Policy:
ip =~ imrcntr + eimrcnt + eimpcnt + imsmetn + impcntr + imdfetn 

## Social Threat:
st =~ imbgeco + imbleco + imwbcnt + imwbcrm + imtcjob + imueclt

## Refugee Policy:
rp =~ gvrfgap + imrsprc + rfgbfml + rfggvfn + rfgawrk + rfgfrpc + shrrfg

## Cultural Threat:
ct =~ qfimchr + qfimwht + pplstrd + vrtrlg

## Economic Threat:
et =~ l*imwgdwn + l*imhecop 
'

out_trust_att <- cfa(mod_trust_att, data = ess, std.lv = TRUE)
out_att <- cfa(mod_att, data = ess, std.lv = TRUE)

summary(out_trust_att)
fitMeasures(out_trust_att)
fitMeasures(out_att)

modificationIndices(out_trust_att, sort. = TRUE, minimum.value = minChange)

?modificationIndices

mod_trust_att2 <- paste(mod_trust_att, "imrcntr ~~ eimrcnt", sep = "\n")
out_trust_att2 <- cfa(mod_trust_att2, data = ess, std.lv = TRUE)

minChange <- fitMeasures(out_trust_att2, "chisq") * 0.1

fitMeasures(out_trust_att2)

modificationIndices(out_trust_att2, sort. = TRUE, minimum.value = minChange)

est <- lavInspect(out_trust_att, "standardized")

lambda <- est$lambda

lambda[lambda == 0] <- NULL

?print

print(lambda, zero.print = ".")
?sparseMatrix

Matrix::Matrix(lambda, sparse = TRUE)

aOut <- anova(out_trust_att, out_trust_att2)
aOut

?anova
