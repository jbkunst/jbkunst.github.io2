#' ---
#' title: "How to: Weather Radials"
#' author: "Joshua Kunst"
#' output:
#'  html_document:
#'    toc: true
#'    keep_md: yes
#' categories: R
#' layout: post
#' featured_image: /images/how-to-weather-radialss/weatherradials.png
#' ---

#+ echo=FALSE, message=FALSE, warning=FALSE
#### setup ws packages ####
rm(list = ls())
knitr::opts_chunk$set(message = FALSE, warning = FALSE,
                      fig.showtext = TRUE, dev = "CairoPNG")

library("dplyr")
library("readr")
library("highcharter")
library("stringr")
library("lubridate")
library("jbkmisc")
library("printr")
blog_setup()

#' 
#' **EDIT**: Highcharts v4.2.4 S  support colum range on polar coords. 
#' 
#' TLDR: Creating weather radials with highcarter and ggplot2.
#' 
#' ![weather radials](/images/how-to-weather-radialss/weatherradials.png)
#' 
#' I was surfing by the deep seas of the web and I found the *Brice Pierre de la Briere*'s 
#' [blocks](http://bl.ocks.org/bricedev) and I saw the *weather radials* which originally are
#' [poster collection](http://weather-radials.com/). Brice use D3 and he used D3 very well
#' and I love D3 but I'm in a rookie level to do something like him. **D3 is not for everybody**
#' and surely not for me, I would love to lear more but family, work and R has priority over D3 so
#' how can I do something like that. Well I have highcharter. So let's try. 
#' 
#' We'll use the same data as Brice (https://www.wunderground.com/).

df <- read_csv("http://bl.ocks.org/bricedev/raw/458a01917183d98dff3c/sf.csv")

df[1:4, 1:4]

names(df) <- names(df) %>% 
  str_to_lower() %>% 
  str_replace("\\s+", "_")

df <- df %>% 
  mutate(id = seq(nrow(df)),
         date2 = as.Date(ymd(date)),
         tmstmp = datetime_to_timestamp(date2),
         month = month(ymd(date)))

dsmax <- df %>%
  select(x = tmstmp,
         y = max_temperaturec) %>% 
  list.parse3()
 
dsmin <- df %>% 
  select(x = tmstmp, y = min_temperaturec) %>% 
  list.parse3()


#' 
#' ## First try
#' 
#' Here we test and chart the data in the most simple way. A line time.
#'  
hc <- highchart() %>% 
  hc_chart(
    type = "line"
    ) %>%
  hc_xAxis(
    type = "datetime",
    tickInterval = 30 * 24 * 3600 * 1000,
    labels = list(format = "{value: %b}")
  ) %>% 
  hc_yAxis(
    min = 0,
    labels = list(format = "{value}?C")
  ) %>% 
  hc_add_series(
    data = dsmax, name = "max"
  ) %>% 
  hc_add_series(
    data = dsmin, name = "min"
    ) %>% 
  hc_add_theme(
    hc_theme_smpl()
    )

hc

#' 
#' Everything seem fine.
#' 
#' ## Second Step
#' 
#' We' change the type to column, stack and see what is the result
#' 


hc <- hc %>% 
  hc_chart(
    type = "column"
    ) %>% 
  hc_plotOptions(
    series = list(
      stacking = "normal"
    )
  )

hc

#' 
#' Not so close.
#' 
#' ## 3rd Step Column Range
#' 
#' If you see the previous chart we stacked so we sum the min and max 
#' and the data don't reflect the value (min,max) what we want. 
#' So we need to create the difference between the max and min.
#' That can be done with the colum range chart.

ds <- df %>% 
  mutate(color = colorize_vector(mean_temperaturec, "A")) %>% 
  select(
    x = tmstmp,
    low = min_temperaturec,
    high = max_temperaturec,
    name = date2,
    color = color
  ) %>% 
  list.parse3()
ds

# Some tooltips to make it a little *intercative*
x <- c("low", "high")
y <- sprintf("{point.%s}", tolower(x))
tltip <- tooltip_table(x, y)

hc <- highchart() %>% 
  hc_chart(
    type = "columnrange"
  ) %>%
  hc_plotOptions(
    series = list(
      stacking = "normal",
      showInLegend = FALSE
    )
  ) %>% 
  hc_tooltip(
    useHTML = TRUE,
    headerFormat = as.character(tags$small("{point.x:%d %B, %Y}")),
    pointFormat = tltip
  ) %>% 
  hc_xAxis(
    gridLineWidth = 0.5,
    type = "datetime",
    tickInterval = 30 * 24 * 3600 * 1000,
    labels = list(format = "{value: %b}")
  ) %>% 
  hc_add_series(data = ds, name = "temp")

hc 

#' ## Final Step
#' 
#' Change to polar coordinates.

hc %>% 
  hc_chart(polar = TRUE) %>% 
  hc_yAxis(
    max = 35,
    min = -10,
    showFirstLabel = FALSE
    ) %>% 
  hc_add_theme(
    hc_theme_smpl()
  )

#' 
#' Yay :D! A beautiful chart same as the d3 version and only using R. So sweet!
#'
#' I'm happy with the result. This is not a standar chart but is
#' a king of *artistic*. What do you think? Any other examples to test
#' this type of chart?
#' 
#' ## Bonus Track: ggplot2 version
#' 
#' It's *really really* easy to do this type of chart in ggplot2 using
#' `geom_linerange` and `geom_polar`:

library("ggplot2")
library("viridis")
library("scales")

ggplot(df, aes(date2,
               ymin = min_temperaturec,
               ymax = max_temperaturec,
               color = mean_temperaturec)) + 
  geom_linerange(size = 1.3, alpha = 0.75) +
  scale_color_viridis(NULL, option = "A") +
  scale_x_date(labels = date_format("%b"), breaks = date_breaks("month")) + 
  ylim(-10, 35) + 
  labs(title = "San Francisco Wather Radial",
       subtitle = "It would be nice if someone do this with the animation package",
       caption = "Other example for ggplot2 vs base #boring but #fun",
       x = NULL, y = NULL) +
  coord_polar() + 
  theme_jbk() +
  theme(legend.position = "bottom")

#' Nice!
#' 
#' Searching I found someone do 
#' [this](https://www.quora.com/R-programming-language/What-is-the-most-elegant-plot-you-have-made-using-ggplot2):
#' 
#' > Always exist someone who did what you did before you.
#' 
#' At least I share the code! :D.

giphy("http://giphy.com/gifs/how-i-met-your-mother-barney-stinson-high-five-13IGxUKu7ucp68")

