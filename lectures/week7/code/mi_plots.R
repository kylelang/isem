### Title:    Generate Measurement Invariance Plots for Lecture Slides
### Author:   Kyle M. Lang
### Created:  2023-10-11
### Modified: 2023-10-11

install.packages("ggsci", repos = "https://cloud.r-project.org")

library(ggplot2)
library(dplyr)
library(ggsci)

## Create some toy data:
x  <- seq(0, 10, length.out = 101)
y0 <- 4 + x

dat <- data.frame(x = rep(x, 3),
  y0 = rep(y0, 3),
  y1 = c(y0 - 2, y0, y0 + 1.5),
  y2 = c(4 + 0.5 * x, y0, 4 + 1.75 * x),
  y3 = c(y0, y0, y0 - 2),
  y4 = c(y0 + 1, y0, 3 + 0.5 * x),
  Group = factor(rep(c("BE", "DE", "NL"), each = length(y0)))
)

###-General Idea-------------------------------------------------------------###
color_style <- scale_color_jama

## Basic plot w/o any grouping:
p0 <- ggplot(dat, aes(x, y0)) + 
  scale_x_continuous(breaks = 0:10) +
  coord_cartesian(ylim = c(0, max(dat$y0)),
                  xlim = c(0, 10),
                  expand = FALSE) +
  theme_classic() +
  xlab("Latent Factor Level") +
  ylab("Observed Item Score")
p0

p0 + geom_line(linewidth = 1, color = pal_jama()(3)[3])

## Invariant measurement:
p1 <- ggplot(dat, aes(x, y0, linetype = Group, color = Group)) + 
  scale_x_continuous(breaks = 0:10) +
  coord_cartesian(ylim = c(0, max(dat$y0)),
                  xlim = c(0, 10),
                  expand = FALSE) +
  geom_line(linewidth = 1.5) +
  theme_classic() +
  color_style() +
  xlab("Latent Factor Level") +
  ylab("Observed Item Score") +
  guides(linetype = "none")
p1

## Weak holds, Strong violated:
p2 <- ggplot(dat, aes(x, y1, color = Group)) + 
  scale_x_continuous(breaks = 0:10) +
  coord_cartesian(ylim = c(0, max(dat$y1)),
                  xlim = c(0, 10),
                  expand = FALSE) +
  geom_line(linewidth = 1) +
  theme_classic() +
  color_style() +
  xlab("Latent Factor Level") +
  ylab("Observed Item Score")
p2

## Weak violated
p3 <- ggplot(dat, aes(x, y2, color = Group)) + 
  scale_x_continuous(breaks = 0:10) +
  coord_cartesian(ylim = c(0, max(dat$y2)),
                  xlim = c(0, 10),
                  expand = FALSE) +
  geom_line(linewidth = 1) +
  theme_classic() +
  color_style() +
  xlab("Latent Factor Level") +
  ylab("Observed Item Score")
p3

###-Illustrate Effects-------------------------------------------------------###

dat1 <- filter(dat, x == 5)
dat2 <- filter(dat, x == 6)
dat3 <- data.frame(dat1[3:5],
                   dat2[3:5],
                   Group = dat1$Group)

p2.1 <- p2 + geom_vline(xintercept = 5, linetype = 2)
p2.1

## Effects on levels:
p2.1 + geom_segment(data = dat1,
  mapping = aes(x = 0, xend = x, y = y1, yend = y1),
  linetype = 3,
  linewidth = 0.75)

## Effects of changes:
p2 + geom_vline(xintercept = c(5, 6), linetype = 2) + 
  geom_segment(data = dat1,
               mapping = aes(x = 0, xend = x, y = y1, yend = y1),
               linetype = 3) +
  geom_segment(data = dat2,
               mapping = aes(x = 0, xend = x, y = y1, yend = y1),
               linetype = 3) +
  geom_errorbar(data = dat3,
                mapping = aes(x = 0.5, ymin = y1, ymax = y1.1),
                width = 0.1,
                linewidth = 1)

## Effect on levels:
p3.1 <- p3 + geom_vline(xintercept = 5, linetype = 2)
p3.1

p3.1 + geom_segment(data = dat1,
  mapping = aes(x = 0, xend = x, y = y2, yend = y2),
  linetype = 3,
  linewidth = 0.75)

## Effect on changes:
p3 + geom_vline(xintercept = c(5, 6), linetype = 2) +
  geom_segment(data = dat1,
               mapping = aes(x = 0, xend = x, y = y2, yend = y2),
               linetype = 3) +
  geom_segment(data = dat2,
               mapping = aes(x = 0, xend = x, y = y2, yend = y2),
               linetype = 3) +
  geom_errorbar(data = dat3,
                mapping = aes(x = 0.5, ymin = y2, ymax = y2.1),
                width = 0.1,
                linewidth = 1)

###-Partial Invariance-------------------------------------------------------###

## Partial strong invariance:
p4 <- ggplot(dat, aes(x, y3, color = Group, linetype = Group)) + 
  scale_x_continuous(breaks = 0:10) + 
  coord_cartesian(ylim = c(0, max(dat$y3)),
                  xlim = c(0, 10),
                  expand = FALSE) +
  geom_line(linewidth = 1.25) +
  theme_classic() +
  color_style() +
  xlab("Latent Factor Level") +
  ylab("Observed Item Score") +
  guides(linetype = "none")
p4

## Partial weak invariance:
p5 <- ggplot(dat, aes(x, y4, color = Group)) +
  scale_x_continuous(breaks = 0:10) + 
  coord_cartesian(ylim = c(0, max(dat$y4)),
                  xlim = c(0, 10),
                  expand = FALSE) +
  geom_line(linewidth = 1) +
  theme_classic() +
  color_style() +
  xlab("Latent Factor Level") +
  ylab("Observed Item Score")
p5
