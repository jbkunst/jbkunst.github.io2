#' ---
#' title: This is a test from the space
#' output: html_fragment
#' categories: R
#' layout: post
#' featured_image: /images/this-is-a-test-from-the-space/featured_image-1.png
#' ---

#' # The setup when you spin!

#' This usually is `echo=FALSE
#+ setup, echo=TRUE
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
p <- ggplot(test) +
  geom_point(aes(x = carat, y = price, color = price, shape = cut)) +
  facet_wrap(~color) + 
  theme_fivethirtyeight() + 
  scale_color_continuous_tableau() + 
  theme(legend.position = "none")
p


#' ## This is a h2! 
#' 
#' I can load a data
#' 
mtcars <- readr::read_csv("data/mtcars.csv")
head(mtcars)


#' # To generate the featured image.
#' 
#' According with http://yihui.name/knitr/options/, dpi: (72; numeric) the
#' DPI (dots per inch) for bitmap devices (dpi * inches = pixels) so:
#' 
desire_width_px <- 720
desire_height_px <- 480
dpi <- 72
fig.width <- desire_width_px / dpi
fig.height <- desire_height_px / dpi

fig.width
fig.height

#' This template need a 720 x 480 image. So at the final of the script
#' I generate a chunk named *featured_image*, with parameters: echo=FALSE,
#' fig.width=10, fig.height=6.7, dpi=72 and fig.show='hide'.

#+ featured_image, echo=FALSE, dpi=72, fig.width=10, fig.height = 6.7, fig.show='hide'
p 
