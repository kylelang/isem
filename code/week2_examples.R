### Title:    Lecture 2 Code Examples
### Author:   Kyle M. Lang
### Created:  2023-08-17
### Modified: 2023-08-17

rm(list = ls(all = TRUE))

source("supportFunctions.R")

library(dplyr)
library(lavaan)
library(tidySEM)

#install.packages("tidySEM", repos = "https://cloud.r-project.org")

dataDir <- "../data/"

diabetes <- readRDS(paste0(dataDir, "diabetes.rds"))

mod1 <- '
## Define the structural relations:
bp + glu ~ age + male

## Do not allow the input variables to covary:
age ~~ 0 * male
'

out <- diabetes %>% 
  mutate(male = ifelse(sex == "male", 1, 0)) %>% 
  sem(mod1, data = ., fixed.x = FALSE)

partSummary(out, 7:10)

prepare_graph(out)

l <- matrix(c("age", "male", "bp", "glu"), ncol = 2)

p <- prepare_graph(out, rect_width = 1, rect_height = 1, variance_diameter = 0.5, layout = l) 

(e <- edges(p))

e[2, 6] <- "left"
e[6, 5:6] <- "right"

e

edges(p) <- e

plot(p)

prepare_graph(out,layout = l, edges = e) %>% plot()

graph_sem(out, layout = get_layout(out, layout_algorithm = "layout_as_star"))
get_layout(out, "layout_nicely")
get_nodes(out)
get_edges(out)
