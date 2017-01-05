---
title: "Thematic Interactive Map"
author: "Joshua Kunst"
output:
 html_document:
   toc: true
   keep_md: yes
categories: R
layout: post
featured_image: /images/featured-image/thematic-interactive-map.gif
---



Last week all the _rstatsosphere_ see the beautiful 
[Timo Grossenbacher](timogrossenbacher.ch)
[work](timogrossenbacher.ch/2016/12/beautiful-thematic-maps-with-ggplot2-only/).

The last month, yep, the past year I've working on create maps
easily with [highcharter](http://jkunst.com/highcharter/).
When I saw this chart I took as  challege to replicate this nice
 map in using highcharter:

![](/images/featured-image/thematic-interactive-map.gif "Thematic intercative map")

So...



![giphy gif](https://media.giphy.com/media/eNweOH3UEi33a/giphy.gif) [source](http://wifflegif.com)

> Challenge accepted. it's gonna be legen...
> -- <cite>Me.</cite>


```r
# packages ----------------------------------------------------------------
library(dplyr)
library(rmapshaper)
library(maptools)
library(highcharter)
library(geojsonio)
library(readr)
library(viridis)
library(purrr)
```

## Data

The data used fhor this chart is the same using by Timo. But the workflow
was slightly modified:

1. Read the shapefile with `maptools::readShapeSpatial`.
2. Simplify the shapefile (optional step) using `rmapshaper::ms_simplify`.
3. Then transform the map data to geojson using `geojsonio::geojson_list`.




```r
# data --------------------------------------------------------------------
folder <- "data/thematicmap/"

map <- readShapeSpatial(file.path(folder, "gde-1-1-15.shp"))
map <- ms_simplify(map, keep = 1) # because ms_simplify fix the Ã¼'s
map <- geojson_list(map)

str(map, max.level = 1)
```

```
## List of 2
##  $ type    : chr "FeatureCollection"
##  $ features:List of 2324
##   .. [list output truncated]
##  - attr(*, "class")= chr "geo_list"
##  - attr(*, "from")= chr "SpatialPolygonsDataFrame"
```

```r
str(map$features[[7]], max.level = 5)
```

```
## List of 4
##  $ type      : chr "Feature"
##  $ id        : int 6
##  $ properties:List of 3
##   ..$ Secondary_  : chr "Knonau"
##   ..$ BFS_ID      : int 7
##   ..$ rmapshaperid: int 6
##  $ geometry  :List of 2
##   ..$ type       : chr "MultiPolygon"
##   ..$ coordinates:List of 1
##   .. ..$ :List of 1
##   .. .. ..$ :List of 7
##   .. .. .. ..$ : num [1:2] 676327 230767
##   .. .. .. ..$ : num [1:2] 675655 233007
##   .. .. .. ..$ : num [1:2] 676458 233252
##   .. .. .. ..$ : num [1:2] 679285 230257
##   .. .. .. ..$ : num [1:2] 679590 229402
##   .. .. .. ..$ : num [1:2] 678887 229152
##   .. .. .. ..$ : num [1:2] 676327 230767
```

```r
# this was to put the name on the tooltip
map$features <- map(map$features, function(x) {
  x$properties$name <- x$properties[["Secondary_"]] 
  x
})

data <- read_csv(file.path(folder, "avg_age_15.csv"))
data <- select(data, -X1)
data <- rename(data, value = avg_age_15)

# colors
no_classes <- 6

colors <- magma(no_classes + 2) %>% 
  rev() %>% 
  head(-1) %>% 
  tail(-1) %>% 
  gsub("FF$", "", .)

# brks <- quantile(data$value, probs = seq(0, 1, length.out = no_classes + 1))
brks <- c(min(data$value), c(40,42,44,46,48), max(data$value))
brks <- ifelse(1:(no_classes + 1) < no_classes, floor(brks), ceiling(brks))
```

## Map

Create the raw map is straightforward. The _main_ challege was replicate the 
relief feature of the orignal map. This took _some days_ to figure
how add the backgound image. I almost loose the hope but you know, new year,
so I tried a little more and it was possible :):

1. First I searched a way to transform the tif image to geojson. I wrote
a mail [@frzambra](https://twitter.com/frzambra) a geoRexpert :D. and
he kindly said me that I was wrong. And he was right. NEXT!
2. I tried with use `divBackgroundImage` but with this the image use all the
container... so... NEXT.
3. Finally surfing in the web I met `plotBackgroundImage` argument in highcharts
which is uesd to put and image only in plot container (inside de axis) and 
it works nicely. It was necessary hack the image using the `preserveAspectRatio`
(html world) to center the image but nothing magical. 




```r
urlimage <- "https://raw.githubusercontent.com/jbkunst/r-posts/master/061-beautiful-thematic-maps-with-ggplot2-highcharter-version/02-relief-georef-clipped-resampled.jpg"

highchart(type = "map") %>% 
  # data part
  hc_add_series(mapData = map, data = data, type = "map",
                joinBy = c("BFS_ID", "bfs_id"), value = "value",
                borderWidth = 0) %>% 
  hc_colorAxis(dataClasses = color_classes(brks, colors)) %>% 
  # functionality
  hc_tooltip(headerFormat = "",
             pointFormat = "{point.name}: {point.value}",
             valueDecimals = 2) %>% 
  hc_legend(align = "right", verticalAlign = "bottom", layout = "vertical",
            floating = TRUE) %>%
  hc_mapNavigation(enabled = FALSE) %>% # if TRUE to zoom the relief image dont zoom.
  # info
  hc_title(text = "Switzerland's regional demographics") %>% 
  hc_subtitle(text = "Average age in Swiss municipalities, 2015") %>% 
  hc_credits(enabled = TRUE,
             text = "Map CC-BY-SA; Author: Joshua Kunst (@jbkunst) based mostly on Timo Grossenbacher (@grssnbchr) work, Geometries: ThemaKart, BFS; Data: BFS, 2016; Relief: swisstopo, 2016") %>% 
  # style
  hc_chart(plotBackgroundImage = urlimage,
           backgroundColor = "transparent",
           events = list(
             load = JS("function(){ $(\"image\")[0].setAttribute('preserveAspectRatio', 'xMidYMid') }")
           ))
```

<iframe src="/htmlwidgets/thematic-interactive-map/highchart_ufzvsmh.html"></iframe> <a href="/htmlwidgets/thematic-interactive-map/highchart_ufzvsmh.html" target="_blank">open</a>

> DARY! Legendary.
> -- <cite>Me.</cite>

Same as the original/ggplot2 version. I'm very happy with the result.
But anyway, there are some details:

1. The image/relief need to be accesible in web. I don't know how
to add images as dependencies yet. I tried econding the image but didn't work.
2. I could not do the legend same as the original. So I used `dataClasses`
instead of `stops` in `hc_colorAxis`.
