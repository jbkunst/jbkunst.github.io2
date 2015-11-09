#' ---
#' title: ggplot with a highcharts taste
#' output: html_fragment
#' categories: R
#' layout: post
#' featured_image: /images/featured-image/ggplot-with-a-highcharts-taste.png
#' ---
#+ setup, echo=FALSE
rm(list = ls())
knitr::opts_chunk$set(warning = FALSE, fig.showtext = TRUE, dev = "CairoPNG", fig.width = 8)

#' Update 2015-11-07: This is modification from an old post. Finnaly I made a pull request and was accepted by [Jeffrey Arnold](https://github.com/jrnold)
#' 
#' At work I use ggplot2 almost for everything. I really like the mid term between high level (highcharts) and low-level (like d3 for example). 
#' The deafult theme for ggplot it's good, and really good if you compare with the old looking R base graphics, and there is 
#' more: the [ggthemes](https://github.com/jrnold/ggthemes) package which have some themes for ggplot objects. However, I miss 
#' the elegant and modern touch, for example in [highcharts](http://www.highcharts.com/demo/column-basic/).
#' 
#' So I decide to play around the <strong>theme</strong> function to replicate the look and feel of highcharts. The main tasks were:
#' 
#' * Change the font to a more modern one.
#' * Remove grid lines (minor ones).
#' * Use a more plain color palette.
#' * Reduce bar's width.
#' * Put a white background.
#' * Put the lenged at bottom.
#' 
#' The chosen font was [Open Sans](http://www.google.com/fonts/specimen/Open+Sans) (an ultra used font nowadays) which you can use in R 
#' with [showtext](http://cran.r-project.org/web/packages/showtext/index.html) package.

library("showtext")
library("ggplot2")

font.add.google("Open Sans", "myfont")
showtext.auto()

data(diamonds)

data <- subset(diamonds, color %in% c("E", "F", "G") & cut %in% c("Ideal", "Premium", "Good"))

data$indicator <- ifelse(data$color %in% c("G" ), 1, 0)

colors_hc <- c("#7CB5EC", "#313131", "#F7A35C",
               "#90EE7E", "#7798BF", "#AAEEEE",
               "#FF0066", "#EEAAEE", "#55BF3B",
               "#DF5353", "#7798BF", "#AAEEEE")


theme_hc <- function(){
  theme(
    text                = element_text(family = "myfont", size = 12),
    title               = element_text(hjust = 0), 
    axis.title.x        = element_text(hjust = .5),
    axis.title.y        = element_text(hjust = .5),
    panel.grid.major.y  = element_line(color = 'gray', size = .3),
    panel.grid.minor.y  = element_blank(),
    panel.grid.major.x  = element_blank(),
    panel.grid.minor.x  = element_blank(),
    panel.border        = element_blank(),
    panel.background    = element_blank(),
    legend.position     = "bottom",
    legend.title        = element_blank()
  )
}

#' The theme is ready. Now to plot.

ggplot(data) +
  geom_bar(aes(cut), width = .4, fill = colors_hc[1]) +
  ggtitle("An interesting title for a bar plot") +
  xlab("Cut") + ylab("Amount") +
  scale_y_continuous(labels = scales::comma) +
  theme_hc()

#' As you can see, the plot look more clean without the gridlines and the background. This cause less confusion (and maybe less detail) 
#' because generate more space.


ggplot(data) +
  geom_bar(aes(color, fill = cut), position = "dodge", width = .4) +
  ggtitle("Another interesting title") +
  xlab("Cut") + ylab("Amount") +
  scale_y_continuous(labels = scales::comma) +
  scale_fill_manual(values = colors_hc) +
  theme_hc()

#' Finally,

ggplot(data) +
  geom_density(aes(x, fill = cut, color = cut), alpha = I(0.5)) +
  ggtitle("Density plot") +  xlab("x") + ylab("Density") +
  scale_y_continuous(labels = scales::percent) +
  scale_fill_manual(values = colors_hc) +
  xlim(4, 8) +
  theme_hc()

#' In my humble option, it look great. What do you think? 
