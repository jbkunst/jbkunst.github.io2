#' ---
#' title: This is a test from the space
#' output: html_fragment
#' categories: R
#' layout: post
#' featured_image: /images/this-is-a-test-from-the-space/ploting-1.png
#' ---
#+ setup, echo=FALSE
rm(list = ls())
library("printr")
knitr::opts_knit$set(root.dir  = normalizePath(".."))

#' This post have some considerations to have when write a post via: 
#' r script > spind > md and testing r srcipt > html_fragment:

print(getwd())
print(knitr::opts_knit$get("root.dir"))

#' this should be equal when knit via ctrl+ shift + K

#' Load libraries
library("ggplot2")
library("ggthemes")
library("dplyr")

#' this is how we show tables
test <- sample_n(diamonds, 1000)
head(test)

#' And this is who we can plot! :D

#+ ploting
ggplot(test) +
  geom_point(aes(x = carat, y = price, color = price, shape = cut)) +
  facet_wrap(~color) + 
  theme_fivethirtyeight() + 
  scale_color_continuous_tableau() + 
  theme(legend.position = "none")


#' ## h2! 
#' Lorem lorem lorem
#' I can load a data
mtcars <- readr::read_csv("data/mtcars.csv")
head(mtcars)
