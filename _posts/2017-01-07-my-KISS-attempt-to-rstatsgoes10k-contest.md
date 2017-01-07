---
title: "My KISS Attempt to rstatsgoes10k Contest"
author: "Joshua Kunst"
output:
 html_document:
   toc: true
 github_document:
   always_allow_html: yes
   toc: true
categories: R
layout: post
featured_image: /images/featured-image/rstatsgoes10k.gif
---



Last year [eoda.de](https://blog.eoda.de/2016/12/21/rstatsgoes10k-eoda-is-hosting-a-contest-in-celebration-of-r/)
launched a contest to predict when the R packages will be 10k. So this
is a really good opportunity to use (finally) the `forecastHybrid` package developed by 
[Peter Ellis](http://ellisp.github.io/) and David Shaub.

> This will be a really KISS-naive-simply-raw try to get a
> reasonable prediction. No transformations, no CV. etc. But you can do better!
> -- <cite>The writer.</cite>
 
![](/images/featured-image/rstatsgoes10k.gif "Naive Attempt to rstatsgoes10k")

Let's load the packages!



```r
library(dplyr)
library(rvest)
library(janitor)
library(lubridate)
library(highcharter)
library(forecast)
library(forecastHybrid)
library(zoo)
options(highcharter.theme = hc_theme_smpl())
```

The data will be extracted from the list of packages by date from CRAN.
Then we'll make some wrangling to get the cumulative sum of the packages
by day.


```r
packages <- "https://cran.r-project.org/web/packages/available_packages_by_date.html" %>% 
  read_html() %>% 
  html_table() %>%
  .[[1]] %>% 
  tbl_df()

names(packages) <- tolower(names(packages))

packages <- mutate(packages, date = ymd(date))

glimpse(packages)
```

```
## Observations: 9,858
## Variables: 3
## $ date    <date> 2017-01-07, 2017-01-07, 2017-01-07, 2017-01-07, 2017-...
## $ package <chr> "AER", "c212", "caseMatch", "clustRcompaR", "dat", "gd...
## $ title   <chr> "Applied Econometrics with R", "Methods for Detecting ...
```

```r
c(min(packages$date), max(packages$date))
```

```
## [1] "2005-10-29" "2017-01-07"
```

```r
data <- packages %>% 
  group_by(date) %>% 
  summarise(n = n()) %>% 
  left_join(data_frame(date = seq(min(packages$date), max(packages$date), by = 1)),
            ., by = "date")

data <- data %>% 
  mutate(
    n = ifelse(is.na(n), 0, n),
    cumsum = cumsum(n)
  )

tail(data)
```



|date       |  n| cumsum|
|:----------|--:|------:|
|2017-01-02 | 14|   9710|
|2017-01-03 | 29|   9739|
|2017-01-04 | 28|   9767|
|2017-01-05 | 37|   9804|
|2017-01-06 | 46|   9850|
|2017-01-07 |  8|   9858|

```r
hchart(data, "line", hcaes(date, cumsum)) %>% 
  hc_title(text = "Just in CRAN, what if we sum GH, BioC? How many would be?")
```

<iframe src="/htmlwidgets/my-KISS-attempt-to-rstatsgoes10k-contest/highchart_yzadrnp.html"></iframe> <a href="/htmlwidgets/my-KISS-attempt-to-rstatsgoes10k-contest/highchart_yzadrnp.html" target="_blank">open</a>


A little weird the effect in the 2014. Let's drop some past
information and create some auxiliar variables.



```r
data <- filter(data, year(date) >= 2013)

date_first <- first(data$date)
date_last <- last(data$date)
```

To use the package we need first a time series object:


```r
z <- zooreg(data$cumsum, start = date_first, frequency = 1)
tail(z)
```

```
## 2017-01-02 2017-01-03 2017-01-04 2017-01-05 2017-01-06 2017-01-07 
##       9710       9739       9767       9804       9850       9858
```

 Now we can use the `forecastHybrid::hybridModel` function. In this case
 I removed the `tbats` model due the long time to fit, the long time to 
 make CV and the long long time to make the predictions (in my previous tests).
 So, in the spirit to be parsimonious and KISS we will remove this model
 from the fit.


```r
# hm <- hybridModel(z, models = "aefns", weights = "cv.errors", errorMethod = "MASE")
# saveRDS(hm, "data/rstatsgoes10k/hm.rds")
hm <- readRDS("data/rstatsgoes10k/hm.rds")
hm
```

```
## Hybrid forecast model comprised of the following models: auto.arima, ets, thetam, nnetar
## ############
## auto.arima with weight 0.368 
## ############
## ets with weight 0.37 
## ############
## thetam with weight 0.2 
## ############
## nnetar with weight 0.061
```

It is really simple to get the forecasts. After the calculate them we will
create a `data_frame` to filter and see what day R will have 10k 
packages according this methodology.


```r
H <- 20
fc <- forecast(hm, h = H)

data_fc <- fc %>% 
  as_data_frame() %>% 
  mutate(date = date_last + days(1:H)) %>% 
  clean_names() %>% 
  tbl_df()
```

So let't see the point forecast and the _optimistic_ prediction
which is the upper limit from the 95% interval.


```r
data_preds <- bind_rows(
  data_fc %>%
    filter(point_forecast >= 10000) %>%
    mutate(name = "Prediction") %>%
    head(1) %>% 
    rename(y = point_forecast),
  data_fc %>%
    filter(hi_95 >= 10000) %>%
    mutate(name = "Optimitstic prediction") %>%
    head(1) %>% 
    rename(y = hi_95)
)

select(data_preds, name, date, y)
```



|name                   |date       |     y|
|:----------------------|:----------|-----:|
|Prediction             |2017-01-16 | 10008|
|Optimitstic prediction |2017-01-11 | 10008|

> So soon!! (warning: according to this). 

Now, let's visualize the result.



```r
highchart() %>% 
  hc_title(text = "rstatsgoes10k") %>%
  hc_subtitle(text = "Predictions via <code>forecastHybrid</code> package", useHTML = TRUE) %>% 
  hc_xAxis(type = "datetime",
           crosshair = list(zIndex = 5, dashStyle = "dot",
                            snap = FALSE, color = "gray"
           )) %>% 
  hc_add_series(filter(data, date >= ymd(20161001)), "line", hcaes(date, cumsum),
                name = "Packages") %>% 
  hc_add_series(data_fc, "line", hcaes(date, point_forecast),
                name = "Prediction", color = "#75aadb") %>% 
  hc_add_series(data_fc, "arearange", hcaes(date, low = lo_95, high = hi_95),
                name = "Prediction Interval (95%)", color = "#75aadb", fillOpacity = 0.3) %>% 
  hc_add_series(data_preds, "scatter", hcaes(date, y, name = name),
                name = "Predicctions to 10K", color = "blue",
                tooltip = list(pointFormat = ""), zIndex = -4,
                marker = list(symbol = "circle", lineWidth= 1, radius= 4,
                              fillColor= "transparent", lineColor= NULL),
                dataLabels = list(enabled = TRUE, format = "{point.name}<br>{point.x:%Y-%m-%d}",
                                  style = list(fontWeight = "normal"))) %>% 
  hc_tooltip(shared = TRUE, valueDecimals = 0)
```

<iframe src="/htmlwidgets/my-KISS-attempt-to-rstatsgoes10k-contest/highchart_osvdnka.html"></iframe> <a href="/htmlwidgets/my-KISS-attempt-to-rstatsgoes10k-contest/highchart_osvdnka.html" target="_blank">open</a>

Simple, right? Maybe the that will not be the day where R hit 10k packages but its
doesn't matter. The __really important fact here__ is all this is product of many many 
developers joined by the community, and some Rheroes like HW, JO, JB, GC, JC, BR, MA,
DR, JS, KR and many others who have astonished us package by package or show our work
in the social media . Thanks to everybody I can using this versatile and powerful language
happily day by day.
