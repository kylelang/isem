library(ggplot2)
library(lavaan)
library(psych)
library(semPlot)

source(here::here("code", "supportFunctions.R"))

x <- rnorm(50, 0, 3)
y <- 0.5 + 2 * x + 0.75 * x^2 + rnorm(10, 0, 5)

p0 <- data.frame(X = x, Y = y) |>
  ggplot(aes(X, Y)) +
  geom_point() +
  theme_classic()

p0 + geom_smooth(method = "lm", se = FALSE, formula = y ~ 1)
p0 + geom_smooth(method = "lm", se = FALSE, formula = y ~ x + I(x^2))
p0 + geom_line(color = "blue", linewidth = 1)

f1 <- paste(
  "y ~ x", 
  paste0("I(x^", 2:19, ")", collapse = " + "),
  sep = " + "
  ) |> as.formula()

colnames(bfi)

satMod <- '
A1 ~~ A1
A2 ~~ A1 + A2
A3 ~~ A1 + A2 + A3
O1 ~~ A1 + A2 + A3 + O1
O2 ~~ A1 + A2 + A3 + O1 + O2
O3 ~~ A1 + A2 + A3 + O1 + O2 + O3
'

indMod <- '
A1 ~~ A1
A2 ~~ A2
A3 ~~ A3
O1 ~~ O1
O2 ~~ O2
O3 ~~ O3
'

lavNames(satOut)

indOut <- cfa(indMod, data = bfi)
satOut <- cfa(satMod, data = bfi)

mod1 <- '
agree =~ A1 + A2 + A3
open  =~ O1 + O2 + O3
'

out1 <- cfa(mod1, data = bfi)

semPaths(out1)
semPaths(indOut)
semPaths(satOut)

?semPaths

sHat <- inspect(out1, "sigma")
sObs <- inspect(out1, "sampstat")$cov
se   <- sqrt(diag(sObs))

r <- s - sigma

s2 <- matrix(se)

w <- s2 %*% t(s2)

x <- (r / w)^2 |> sum()  

sqrt(x / 42)

w

((r / w)^2 |> sum()) / 2

/ q) |> sqrt()


fit1 <- fitMeasures(out1) |> as.list()

fit1$srmr

s2

s2[3] * s2[2]

x <- 0
for(i in 1:6) {
  for(j in 1:6) {
    x <- x + ( (sObs[i, j] - sHat[i, j]) / (se[i] * se[j]) )^2
  }
}

q <- 6 * 7
q

x

x / q

sqrt(x)

sqrt(x / 42)

fit1$srmr

out1 <- cfa(mod1, data = bfi)

indX2 <- -2 * (logLik(indOut) - logLik(satOut))
estX2 <- -2 * (logLik(out1) - logLik(satOut))

fit1 <- fitMeasures(out1)

fit1 |> length()

tmp <- fit1 |> tail(-8)

length(tmp)

ncp1 <- fit1$chisq - fit1$df
ncp0 <- fit1$baseline.chisq - fit1$baseline.df

1 - ncp1 / ncp0
fit1$cfi

fit1 |> head(23)
fit1 |> tail(-30)

inspect(out0, "cov.ov")

tmp <- (logLik(out1) - logLik(out0)) / n


f - abs(tmp)

exp(logLik(out1)) - exp(logLik(out0))

logLik(out1)

n <- fit1["ntotal"]
f <- fit1["fmin"]
x2 <- fit1["chisq"]
fit1

x <- 27.3
y <- 88.34

log(x / y)

log(x) - log(y)
