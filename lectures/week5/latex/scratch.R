library(ggplot2)

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
