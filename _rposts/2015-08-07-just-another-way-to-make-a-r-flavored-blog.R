#' ---
#' title: Just another way to make a R flavored blog
#' output: html_fragment
#' categories: R
#' layout: post
#' featured_image: /images/just-another-way-to-make-a-r-flavored-blog/github_fork_game.png
#' ---
#' 
#' ## This post is in active development!
#' 
#' Load libraries
#' 
library("ggplot2")
library("dplyr")
library("jbkmisc")
library("printr")
blog_setup()

#' This usually is "echo=FALSE"
#+ setup, echo=TRUE
rm(list = ls())
ls()


####' ### Considerations ####
#' 
#' 1. Use h3 `###` in R files to spin, because h1 is reserved for title post and h2 is IMO to big and i dont want
#' to change css XD.
#' 1. Other consideration
#' 

#+echo=FALSE
giphy()

####' ### Style ####
#' 
#' *This is single asterisc*.
#' 
#' **This is double asterics**
#' 
#' Single `code? this is working`  


####' ### Show and load data frames ####

head(cars)

test <- sample_n(diamonds, 1000)

head(test)

getwd()

mtc <- readr::read_csv("data/mtcars.csv")

#' Showing a table
print(head(mtc))

####' ### Printing htmlwidgets objects ####
#' 
#' To print htmlwidgets object we rewrite the *knit_print.htmlwidget* function:

knit_print.htmlwidget

library("highcharter")



x <- hchart(AirPassengers) %>%  
  hc_title(text = "Testing knit_print.htmlwidget") %>% 
  hc_add_theme(hc_theme_smpl())

x

library("d3heatmap")
d3heatmap(mtcars, scale = "column")



####' ### Show external images ####
#' 
#' ![](/images/just-another-way-to-make-a-r-flavored-blog/github_fork_game_wide.png)
#' [image source](http://biasedvideogamerblog.com/gamerreview)

####' ### Plotting ####
#' 
#+ ploting
p <- ggplot(test) +
  geom_point(aes(x = carat, y = price, color = price, shape = cut)) +
  facet_wrap(~color)
p

####' ### To generate the featured image ####
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

####' ### Markdown references ####
#' 
#' 1. http://milanaryal.com/2015/writing-on-github-pages-and-jekyll-using-markdown/
#' 1. http://ajoz.github.io/2014/06/29/i-want-my-github-flavored-markdown/
#' 1. https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet#line-breaks
#' 1. https://george-hawkins.github.io/basic-gfm-jekyll/redcarpet-extensions.html#hard-wrap


