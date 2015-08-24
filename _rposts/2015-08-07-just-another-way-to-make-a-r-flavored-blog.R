#' ---
#' title: Just another way to make a R flavored blog
#' output: html_fragment
#' categories: R
#' layout: post
#' featured_image: /images/just-another-way-to-make-a-r-flavored-blog/github_fork_game.png
#' ---
#' 
#' ## **This post is in active development**!
#' 

#' ![](/images/just-another-way-to-make-a-r-flavored-blog/github_fork_game_wide.png)
#' [image source](http://biasedvideogamerblog.com/gamerreview)
#' 
#' This usually is "echo=FALSE"
#+ setup, echo=TRUE
rm(list = ls())
library("printr")
knitr::opts_knit$set(root.dir  = normalizePath(".."))

#' ## Considerations
#' 
#' 1. Use h2 `##` in R files to spin, because h1 is reserved for title post.
#' 1. At the begin of R script write a chunk of R code loading the print package
#' 1. 


#' This post have some considerations to have when write a post via: 
#' r script > spind > md and testing r srcipt > html_fragment:

print(getwd())
print(knitr::opts_knit$get("root.dir"))

#' this should be equal when knit via ctrl+ shift + K



#' ## Testing knitr::spin on this R script
#' 
#' Load libraries
#' 
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

#' ### This is a h3! 
#' 
#' I can load a data
#' 
mtcars <- readr::read_csv("data/mtcars.csv")

#' Showing a table
head(mtcars)


#' ## To generate the featured image.
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

#+ featured_image, echo=FALSE, dpi=72, fig.width=16, fig.height = 10, fig.show='hide'
p 


#' ## Markdown references
#' 
#' 1. http://milanaryal.com/2015/writing-on-github-pages-and-jekyll-using-markdown/
#' 1. http://ajoz.github.io/2014/06/29/i-want-my-github-flavored-markdown/
#' 1. https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet#line-breaks
#' 1. https://george-hawkins.github.io/basic-gfm-jekyll/redcarpet-extensions.html#hard-wrap


