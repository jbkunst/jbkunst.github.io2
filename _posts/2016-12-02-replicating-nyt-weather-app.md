---
title: "Replicating NYT Weather App"
author: "Joshua Kunst"
output:
 html_document:
   toc: true
   keep_md: yes
categories: R
layout: post
featured_image: /images/featured-image/replicating-nyt-weather-app.png
---


So much time since my last post so I want to post something, no matter 
what it is, but I hope this will be somehow helpfull

In this post I will show some new features for the next version of
`highcharter` package. The main feature added is `hc_add_series` now is 
a __generic__ function! This mean you can add the `data` argument
can be numeric, data frame, time series (ts, xts, ohlc) amonth others
so the syntaxis will be a little cleaner.

What we'll do here? We'll make an interactive version of the 
_well-well-know-and-a-little-repeated_ Tufte weather chart.

![](http://www.edwardtufte.com/bboard/images/00014g-837.gif "Weather Chart")

There are good ggplot versions if you can start 
[https://rpubs.com/tyshynsk/133318]() and
[https://rpubs.com/bradleyboehmke/weather_graphic]().

But our focus will be replicate the New York Time App: 
[__How Much Warmer Was Your City in 2015?__][1] where you can choose among
__over 3K cities__!. So let's start. So we need a interactive charting
library and shiny.

[1]: http://www.nytimes.com/interactive/2016/02/19/us/2015-year-in-weather-temperature-precipitation.html

## Data

If you search/explore in the devTools in the previous link you can
know where is the path of the used data. So to be clear:

> All the data used in this post is from http://www.nytimes.com
> -- <cite>Me.</cite>





We'll load the `tidyverse`, download the data, and create an auxiliar 
variable `dt` to store the date time in numeric format.


```r
library(printr)
library(tidyverse)
library(highcharter)
library(lubridate)
library(stringr)
library(forcats)

url_base <- "http://graphics8.nytimes.com/newsgraphics/2016/01/01/weather/assets"
file <- "new-york_ny.csv" # "san-francisco_ca.csv"
url_file <- file.path(url_base, file)

data <- read_csv(url_file)
data <- mutate(data, dt = datetime_to_timestamp(date))

head(data)
```



|date       | month| temp_max| temp_min| temp_rec_max| temp_rec_min| temp_avg_max| temp_avg_min|temp_rec_high |temp_rec_low | precip_value| precip_actual| precip_normal|precip_rec |snow_rec | annual_average_temperature| departure_from_normal| total_precipitation| precipitation_departure_from_normal|       dt|
|:----------|-----:|--------:|--------:|------------:|------------:|------------:|------------:|:-------------|:------------|------------:|-------------:|-------------:|:----------|:--------|--------------------------:|---------------------:|-------------------:|-----------------------------------:|--------:|
|2015-01-01 |     1|       39|       27|           62|           -4|           39|           28|NULL          |NULL         |         0.00|          5.23|          3.65|NULL       |NULL     |                         NA|                    NA|                  NA|                                  NA| 1.42e+12|
|2015-01-02 |     1|       42|       35|           68|            2|           39|           28|NULL          |NULL         |         0.00|            NA|            NA|NULL       |NULL     |                         NA|                    NA|                  NA|                                  NA| 1.42e+12|
|2015-01-03 |     1|       42|       33|           64|           -4|           39|           28|NULL          |NULL         |         0.71|            NA|            NA|NULL       |NA       |                         NA|                    NA|                  NA|                                  NA| 1.42e+12|
|2015-01-04 |     1|       56|       41|           66|           -3|           39|           27|NULL          |NULL         |         1.01|            NA|            NA|NULL       |NULL     |                         NA|                    NA|                  NA|                                  NA| 1.42e+12|
|2015-01-05 |     1|       49|       21|           64|           -4|           38|           27|NULL          |NULL         |         1.01|            NA|            NA|NULL       |NULL     |                         NA|                    NA|                  NA|                                  NA| 1.42e+12|
|2015-01-06 |     1|       22|       19|           72|           -2|           38|           27|NULL          |NULL         |         1.06|            NA|            NA|NULL       |NULL     |                         NA|                    NA|                  NA|                                  NA| 1.42e+12|

## Setup

Due the data is ready we'll start to create the chart (a highchart object):



```r
hc <- highchart() %>%
  hc_xAxis(type = "datetime", showLastLabel = FALSE,
           dateTimeLabelFormats = list(month = "%B")) %>% 
  hc_tooltip(shared = TRUE, useHTML = TRUE,
             headerFormat = as.character(tags$small("{point.x: %b %d}", tags$br()))) %>% 
  hc_plotOptions(series = list(borderWidth = 0, pointWidth = 4)) %>% 
  hc_add_theme(hc_theme_smpl())

hc
```

<iframe src="/htmlwidgets/replicating-nyt-weather-app/highchart_ljwskxz.html"></iframe> <a href="/htmlwidgets/replicating-nyt-weather-app/highchart_ljwskxz.html" target="_blank">open</a>

> _No data to display_. All acording to the plan XD.

## Temperature Data

We'll select the temperature columns from the data and do some wrangling,
gather, spread, separate and recodes to get a nice __tidy data frame__.



```r
dtempgather <- data %>% 
  select(dt, starts_with("temp")) %>% 
  select(-temp_rec_high, -temp_rec_low) %>% 
  rename(temp_actual_max = temp_max,
         temp_actual_min = temp_min) %>% 
  gather(key, value, -dt) %>% 
  mutate(key = str_replace(key, "temp_", "")) 

dtempspread <- dtempgather %>% 
  separate(key, c("serie", "type"), sep = "_") %>% 
  spread(type, value)

temps <- dtempspread %>% 
  mutate(serie = factor(serie, levels = c("rec", "avg", "actual")),
         serie = fct_recode(serie, Record = "rec", Normal = "avg", Observed = "actual"))

head(temps)
```



|       dt|serie    | max| min|
|--------:|:--------|---:|---:|
| 1.42e+12|Observed |  39|  27|
| 1.42e+12|Normal   |  39|  28|
| 1.42e+12|Record   |  62|  -4|
| 1.42e+12|Observed |  42|  35|
| 1.42e+12|Normal   |  39|  28|
| 1.42e+12|Record   |  68|   2|

Now whe can add this data to the _highchart_ object using `hc_add_series`:


```r
hc <- hc %>% 
  hc_add_series(temps, type = "columnrange",
                hcaes(dt, low = min, high = max, group = serie),
                color = c("#ECEBE3", "#C8B8B9", "#A90048")) 

hc
```

<iframe src="/htmlwidgets/replicating-nyt-weather-app/highchart_jgcwqay.html"></iframe> <a href="/htmlwidgets/replicating-nyt-weather-app/highchart_jgcwqay.html" target="_blank">open</a>

A really similar chart of what we want!

The original chart show records of temprerature. So 
we need to filter the days with temperature records using the columns
`temp_rec_high` and `temp_rec_low`, then some gathers and tweaks. Then
set some options to show the points, like use fill color and some longer
radius.


```r
records <- data %>%
  select(dt, temp_rec_high, temp_rec_low) %>% 
  filter(temp_rec_high != "NULL" | temp_rec_low != "NULL") %>% 
  dmap_if(is.character, str_extract, "\\d+") %>% 
  dmap_if(is.character, as.numeric) %>% 
  gather(type, value, -dt) %>% 
  filter(!is.na(value)) %>% 
  mutate(type = str_replace(type, "temp_rec_", ""),
         type = paste("This year record", type))

pointsyles <- list(
  symbol = "circle",
  lineWidth= 1,
  radius= 4,
  fillColor= "#FFFFFF",
  lineColor= NULL
)

head(records)
```



|       dt|type                  | value|
|--------:|:---------------------|-----:|
| 1.44e+12|This year record high |    95|
| 1.44e+12|This year record high |    97|
| 1.45e+12|This year record high |    74|
| 1.45e+12|This year record high |    67|
| 1.45e+12|This year record high |    67|
| 1.45e+12|This year record high |    68|

```r
hc <- hc %>% 
  hc_add_series(records, "point", hcaes(x = dt, y = value, group = type),
                marker = pointsyles)

hc
```

<iframe src="/htmlwidgets/replicating-nyt-weather-app/highchart_nidtayp.html"></iframe> <a href="/htmlwidgets/replicating-nyt-weather-app/highchart_nidtayp.html" target="_blank">open</a>

We're good.

## Precipitation Data

A nice feture of the NYTs app is and the chart is show the precipitaion by
month. This data is in other axis. So we need to create a list with 2 axis 
using the `create_yaxis` helper and the adding this axis to the chart.


```r
axis <- create_yaxis(
  naxis = 2,
  heights = c(3,1),
  sep = 0.05,
  turnopposite = FALSE,
  showLastLabel = FALSE,
  startOnTick = FALSE)
```


Manually add titles (I know this can be more elegant) and options.



```r
axis[[1]]$title <- list(text = "Temperature")
axis[[1]]$labels <- list(format = "{value}?F")

axis[[2]]$title <- list(text = "Precipitation")
axis[[2]]$min <- 0

hc <- hc_yAxis_multiples(hc, axis)

hc
```

<iframe src="/htmlwidgets/replicating-nyt-weather-app/highchart_iyewkoc.html"></iframe> <a href="/htmlwidgets/replicating-nyt-weather-app/highchart_iyewkoc.html" target="_blank">open</a>

The 2 axis are ready, now we need add the data. We will add 12 series 
-one for each month- but we want to asociate 1 legend for all these 12 
series, so we need to use `id` and `linkedTo` parameters and obviously. 
That's why the `id` will be a `'p'` for the firt element and then NA
to the other 11. And then linked this 11 to the first series (`id = 'p'`).


```r
precip <- select(data, dt, precip_value, month)

hc <- hc %>%
  hc_add_series(precip, type = "area", hcaes(dt, precip_value, group = month),
                name = "Precipitation", color = "#008ED0", lineWidth = 1,
                yAxis = 1, fillColor = "#EBEAE2", 
                id = c("p", rep(NA, 11)), linkedTo = c(NA, rep("p", 11)))
```

The same way we'll add the normal precipitations by month.



```r
precipnormal <- data %>% 
  select(dt, precip_normal, month) %>% 
  group_by(month) %>% 
  filter(row_number() %in% c(1, n())) %>%
  ungroup() %>% 
  fill(precip_normal)

hc <- hc %>% 
  hc_add_series(precipnormal, "line", hcaes(x = dt, y = precip_normal, group = month),
                name = "Normal Precipitation", color = "#008ED0", yAxis = 1,
                id = c("np", rep(NA, 11)), linkedTo = c(NA, rep("np", 11)),
                lineWidth = 1)
```


## Volia

Curious how the chart looks? Me too! Nah, I saw the chart before this post.



```r
hc
```

<iframe src="/htmlwidgets/replicating-nyt-weather-app/highchart_nbmedoh.html"></iframe> <a href="/htmlwidgets/replicating-nyt-weather-app/highchart_nbmedoh.html" target="_blank">open</a>

With R you can create a press style chart with some wrangling and charting. 
Now with a little of love we can make the code resuable to make a shiny app.

<iframe src="https://jbkunst.shinyapps.io/shiny-nyt-temp/" width="100%" height="750px"
style="border:none;"></iframe>

## Homework

Someone put the grid lines for the 2 axis as the original NYT app please to
these charts! I will grateful if someone code that details.

See you :B!

![giphy gif](https://media.giphy.com/media/xT0GqGrvB5PgQYSKGc/giphy.gif) [source](https://www.instagram.com/p/BGVGtVJvi5X/?taken-by=napkinapocalypse&hl=en)

