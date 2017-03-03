---
title: "Giving a Thematic Touch to your Interactive Chart"
author: "Joshua Kunst"
output:
 html_document:
   toc: true
   keep_md: yes
categories: R
layout: post
featured_image: /images/featured-image/thematic-chart.gif
---



## Preliminars

Usually (mainly at work) I made a chart and when I  present it nobody cares
about the style, if the chart comes from an excel spreadsheet, paint or
intercative chart, or colors, labels, font, or things I like to care.
That's sad for me but it's fine: the data/history behind and how you present
it is what matters. And surely I'm overreacting.

But hey! That's not implies you only must do always clean chart or tufte style plots.
Sometimes you can play with the topic of your chart and  give some _thematic touch_.

The first example that come to my mind is the _Iraq's bloody toll_ visualization:

![Iraq's bloody toll](http://cdn3.i-scmp.com/sites/default/files/styles/980w/public/2013/07/17/iraqdeaths.jpg)


So. We'll use some resources to try:

- Add some context of the topic before the viewer read something.
- Hopefully keep in the viewer's memory :) in a _gooood_ way.

Keeping the message intact, ie, don't abuse adding many element so the user 
don't lose the main point of the chart.

## The tools



```r
library(tidyverse) 
library(highcharter)
library(lubridate)
library(rvest)
library(janitor)
library(stringr)
library(jsonlite)
library(countrycode)
options(highcharter.debug = TRUE)
```

## Example I: Oil Spills

We can reuse the _bloody toll_ effect, using with _Oil Spills_ data. 

The [ourworldindata.org](https://ourworldindata.org/oil-spills/) website have 
a descriptive study Max Roser.

> Max Roser (2016) - 'Oil Spills'. Published online at OurWorldInData.org. 
> Retrieved from: https://ourworldindata.org/oil-spills/ [Online Resource]

They start with:

> Over the past 4 decades - the time for which we have data - oil spills
> decreased dramatically. Although oil spills also happen on land, 
> marine oil spills are considered more serious as the spilled oil is less containable

Let's load the data and make the basic chart.



```r
json <- read_lines("https://ourworldindata.org/wp-content/uploads/nvd3/nvd3_multiBarChart_Oil/multiBarChart_Oil.html")
json <- json[seq(
  which(str_detect(json, "var xxx")),
  first(which(str_detect(json, "\\}\\]\\;")))
)]

json <- fromJSON(str_replace_all(json, "var xxx = |;$", ""))
json <- transpose(json)

str(json)
```

```
## List of 2
##  $ :List of 2
##   ..$ values:'data.frame':	43 obs. of  2 variables:
##   .. ..$ x: num [1:43] 0.00 3.16e+10 6.31e+10 9.47e+10 1.26e+11 ...
##   .. ..$ y: int [1:43] 30 14 27 31 27 20 26 16 23 32 ...
##   ..$ key   : chr ">700 Tonnes"
##  $ :List of 2
##   ..$ values:'data.frame':	43 obs. of  2 variables:
##   .. ..$ x: num [1:43] 0.00 3.16e+10 6.31e+10 9.47e+10 1.26e+11 ...
##   .. ..$ y: int [1:43] 7 18 48 28 90 96 67 69 59 60 ...
##   ..$ key   : chr "7-700 Tonnes"
```

```r
dspills <- map_df(json, function(x) {
  df <- as.data.frame(x[["values"]])
  df$key <- x[["key"]]
  tbl_df(df)
  df
})

glimpse(dspills)
```

```
## Observations: 86
## Variables: 3
## $ x   <dbl> 0.00e+00, 3.16e+10, 6.31e+10, 9.47e+10, 1.26e+11, 1.58e+11...
## $ y   <int> 30, 14, 27, 31, 27, 20, 26, 16, 23, 32, 13, 7, 4, 13, 8, 8...
## $ key <chr> ">700 Tonnes", ">700 Tonnes", ">700 Tonnes", ">700 Tonnes"...
```

The data is ready. So we can make an staked area chart. I used _areaspline_
here to make a _liquid_ effect. 


```r
hcspills <- hchart(dspills, "areaspline", hcaes(x, y, group = "key")) %>% 
  hc_plotOptions(series = list(stacking = "normal")) %>% 
  hc_xAxis(type = "datetime") %>% 
  hc_title(text = "Number of Oil Spills Over the Past 4 Decades")
hcspills
```

<iframe src="/htmlwidgets/giving-a-thematic-touch-to-your-interactive-chart/highchart_lamygqn.html"></iframe> <a href="/htmlwidgets/giving-a-thematic-touch-to-your-interactive-chart/highchart_lamygqn.html" target="_blank">open</a>

Yay, the spills are decreasing over time. So we can do:

- Add a _deep sea_ background.
- Reverse the `yAxis` to the give the _fall_ effect. 
- Add a dark colors to simulate the _oil_.
- Add the credits for give the _serious_ (? ;) ) touch.


```r
hcspills2 <- hcspills %>% 
  hc_colors(c("#000000", "#222222")) %>% 
  hc_title(
    align = "left",
    style = list(color = "black")
  ) %>% 
  hc_credits(
    enabled = TRUE,
    text = "Data from ITOPF.com",
    href = "http://www.itopf.com/knowledge-resources/data-statistics/statistics/"
  ) %>% 
  hc_plotOptions(series = list(marker = list(enabled = FALSE))) %>% 
  hc_chart(
    divBackgroundImage = "http://www.drodd.com/images14/ocean-wallpaper30.jpg",
    backgroundColor = hex_to_rgba("white", 0.50)
  ) %>% 
  hc_tooltip(sort = TRUE, table = TRUE) %>% 
  hc_legend(align = "right", verticalAlign = "top",
            layout = "horizontal") %>% 
  hc_xAxis(opposite = TRUE, gridLineWidth = 0,
           title = list(text = "Time", style = list(color = "black")),
           lineColor = "black", tickColor = "black",
           labels = list(style = list(color = "black"))) %>% 
  hc_yAxis(reversed = TRUE, gridLineWidth = 0, lineWidth = 1, lineColor = "black",
           tickWidth = 1, tickLength = 10, tickColor = "black",
           title = list(text = "Oil Spills", style = list(color = "black")),
           labels = list(style = list(color = "black"))) %>% 
  hc_add_theme(hc_theme_elementary())

hcspills2
```

<iframe src="/htmlwidgets/giving-a-thematic-touch-to-your-interactive-chart/highchart_awoxmrp.html"></iframe> <a href="/htmlwidgets/giving-a-thematic-touch-to-your-interactive-chart/highchart_awoxmrp.html" target="_blank">open</a>


## Example II: Winter Olympic Games

Here we will take the data and chart the participating nations over the 
years.



```r
tables <- read_html("https://en.wikipedia.org/wiki/Winter_Olympic_Games") %>% 
  html_table(fill = TRUE)

dgames <- tables[[5]]
dgames <- clean_names(dgames)
dgames <- dmap_if(dgames, is.character, str_trim)

dgames <- dgames[-1, ]
dgames <- filter(dgames, !games %in% c("1940", "1944"))
dgames <- filter(dgames, !year %in% seq(2018, by = 4, length.out = 4))
```

Not sure how re-read data to get the right column types. So a dirty trick. 


```r
tf <- tempfile(fileext = ".csv")
write_csv(dgames, tf)
dgames <- read_csv(tf)

dgames <- mutate(dgames,
                 nations = str_extract(nations, "\\d+"),
                 nations = as.numeric(nations))

glimpse(dgames)
```

```
## Observations: 22
## Variables: 14
## $ games         <chr> "I", "II", "III", "IV", "V", "VI", "VII", "VIII"...
## $ year          <int> 1924, 1928, 1932, 1936, 1948, 1952, 1956, 1960, ...
## $ host          <chr> "Chamonix, France", "St. Moritz, Switzerland", "...
## $ opened_by     <chr> "Undersecretary Gaston Vidal", "President Edmund...
## $ dates         <chr> "25 January Â– 5 February", "11Â–19 February", "4Â–...
## $ nations       <dbl> 16, 25, 17, 28, 28, 30, 32, 30, 36, 37, 35, 37, ...
## $ competitors   <int> 258, 464, 252, 646, 669, 694, 821, 665, 1091, 11...
## $ competitors_2 <int> 247, 438, 231, 566, 592, 585, 687, 521, 892, 947...
## $ competitors_3 <int> 11, 26, 21, 80, 77, 109, 134, 144, 199, 211, 205...
## $ sports        <int> 6, 4, 4, 4, 4, 4, 4, 4, 6, 6, 6, 6, 6, 6, 6, 6, ...
## $ disci_plines  <int> 9, 8, 7, 8, 9, 8, 8, 8, 10, 10, 10, 10, 10, 10, ...
## $ events        <int> 16, 14, 14, 17, 22, 22, 24, 27, 34, 35, 35, 37, ...
## $ top_nation    <chr> "NorwayÂ (NOR)", "NorwayÂ (NOR)", "United StatesÂ (...
## $ ref           <chr> "[2]", "[3]", "[4]", "[5]", "[6]", "[7]", "[8]",...
```

Let's see the first chart:


```r
hcgames <- hchart(dgames, "areaspline", hcaes(year, nations, name = host), name = "Nations") %>% 
  hc_title(text = "Number of Participating Nations in every Winter Olympic Games") %>%
  hc_xAxis(title = list(text = "Time")) %>% 
  hc_yAxis(title = list(text = "Nations"))
  
hcgames
```

<iframe src="/htmlwidgets/giving-a-thematic-touch-to-your-interactive-chart/highchart_bsqvpfr.html"></iframe> <a href="/htmlwidgets/giving-a-thematic-touch-to-your-interactive-chart/highchart_bsqvpfr.html" target="_blank">open</a>

With that increase of nations in 1980 we can:

- Use a white color to simulate a big snowed mountain.
- Put a relevant background.
- Put some flags for each host.
- And work on the tooltip to show more information.



```r
urlico <- "url(https://raw.githubusercontent.com/tugmaks/flags/2d15d1870266cf5baefb912378ecfba418826a79/flags/flags-iso/flat/24/%s.png)"

dgames <- dgames %>% 
  mutate(country = str_extract(host, ", .*$"),
         country = str_replace(country, ", ", ""),
         country = str_trim(country)) %>% 
  mutate(countrycode = countrycode(country, origin = "country.name", destination = "iso2c")) %>% 
  mutate(marker = sprintf(urlico, countrycode),
         marker = map(marker, function(x) list(symbol = x)),
         flagicon = sprintf(urlico, countrycode),
         flagicon = str_replace_all(flagicon, "url\\(|\\)", "")) %>% 
  rename(men = competitors_2, women = competitors_3)

glimpse(dgames)
```

```
## Observations: 22
## Variables: 18
## $ games        <chr> "I", "II", "III", "IV", "V", "VI", "VII", "VIII",...
## $ year         <int> 1924, 1928, 1932, 1936, 1948, 1952, 1956, 1960, 1...
## $ host         <chr> "Chamonix, France", "St. Moritz, Switzerland", "L...
## $ opened_by    <chr> "Undersecretary Gaston Vidal", "President Edmund ...
## $ dates        <chr> "25 January Â– 5 February", "11Â–19 February", "4Â–1...
## $ nations      <dbl> 16, 25, 17, 28, 28, 30, 32, 30, 36, 37, 35, 37, 3...
## $ competitors  <int> 258, 464, 252, 646, 669, 694, 821, 665, 1091, 115...
## $ men          <int> 247, 438, 231, 566, 592, 585, 687, 521, 892, 947,...
## $ women        <int> 11, 26, 21, 80, 77, 109, 134, 144, 199, 211, 205,...
## $ sports       <int> 6, 4, 4, 4, 4, 4, 4, 4, 6, 6, 6, 6, 6, 6, 6, 6, 6...
## $ disci_plines <int> 9, 8, 7, 8, 9, 8, 8, 8, 10, 10, 10, 10, 10, 10, 1...
## $ events       <int> 16, 14, 14, 17, 22, 22, 24, 27, 34, 35, 35, 37, 3...
## $ top_nation   <chr> "NorwayÂ (NOR)", "NorwayÂ (NOR)", "United StatesÂ (U...
## $ ref          <chr> "[2]", "[3]", "[4]", "[5]", "[6]", "[7]", "[8]", ...
## $ country      <chr> "France", "Switzerland", "United States", "German...
## $ countrycode  <chr> "FR", "CH", "US", "DE", "CH", "NO", "IT", "US", "...
## $ marker       <list> ["url(https://raw.githubusercontent.com/tugmaks/...
## $ flagicon     <chr> "https://raw.githubusercontent.com/tugmaks/flags/...
```

```r
urlimg <- "http://jkunst.com/images/add-style/winter_olimpics.jpg"
ttvars <- c("year", "nations", "sports", "competitors", "women", "men", "events")
tt <- tooltip_table(
  ttvars,
  sprintf("{point.%s}", ttvars), img = tags$img(src="{point.flagicon}", style = "text-align: center;")
)

hcgames2 <- hchart(dgames, "areaspline", hcaes(year, nations, name = host), name = "Nations") %>% 
  hc_colors(hex_to_rgba("white", 0.8)) %>% 
  hc_title(
    text = "Number of Participating Nations in every Winter Olympic Games",
    align = "left",
    style = list(color = "white")
  ) %>% 
  hc_credits(
    enabled = TRUE,
    text = "Data from Wipiedia",
    href = "https://en.wikipedia.org/wiki/Winter_Olympic_Games"
  ) %>% 
  hc_xAxis(
    title = list(text = "Time", style = list(color = "white")),
    gridLineWidth = 0,
    labels = list(style = list(color = "white"))
  ) %>% 
  hc_yAxis(
    lineWidth = 1,
    tickWidth = 1,
    tickLength = 10,
    title = list(text = "Nations", style = list(color = "white")),
    gridLineWidth = 0,
    labels = list(style = list(color = "white"))
  ) %>% 
  hc_chart(
    divBackgroundImage = urlimg,
    backgroundColor = hex_to_rgba("black", 0.10)
    ) %>% 
  hc_tooltip(
    headerFormat = as.character(tags$h4("{point.key}", tags$br())),
    pointFormat = tt,
    useHTML = TRUE,
    backgroundColor = "transparent",
    borderColor = "transparent",
    shadow = FALSE,
    style = list(color = "white", fontSize = "0.8em", fontWeight = "normal"),
    positioner = JS("function () { return { x: this.chart.plotLeft + 15, y: this.chart.plotTop + 0 }; }"),
    shape = "square"
  ) %>% 
  hc_plotOptions(
    series = list(
      states = list(hover = list(halo = list(size  = 30)))
    )
  ) %>% 
  hc_add_theme(hc_theme_elementary())

hcgames2
```

<iframe src="/htmlwidgets/giving-a-thematic-touch-to-your-interactive-chart/highchart_xezfvur.html"></iframe> <a href="/htmlwidgets/giving-a-thematic-touch-to-your-interactive-chart/highchart_xezfvur.html" target="_blank">open</a>

## My Favorite Bonus



```r
library(rwars)

swmovies <- get_all_films()

swdata <- map_df(swmovies$results, function(x){
  data_frame(
    movie = x$title,
    species = length(x$species),
    planets = length(x$planets),
    characters = length(x$characters),
    vehicles = length(x$vehicles),
    release = x$release_date
  )
}) 

swdata <- gather(swdata, key, number, -movie, -release) %>% 
  arrange(release)

hchart(swdata, "line", hcaes(x = movie, y = number, group = key),
       color = c("#e5b13a", "#4bd5ee", "#4AA942", "#FAFAFA")) %>% 
  hc_title(
    text = "Diversity in <span style=\"color:#e5b13a\"> STAR WARS</span> movies",
    useHTML = TRUE
  ) %>% 
  hc_yAxis(gridLineColor = "#666666") %>% 
  hc_tooltip(table = TRUE, sort = TRUE) %>% 
  hc_credits(
    enabled = TRUE,
    text = "Source: SWAPI via rwars package",
    href = "https://swapi.co/"
  ) %>%
  hc_chart(
    backgroundColor = hex_to_rgba("black", "0.2"),
    divBackgroundImage = "http://www.wired.com/images_blogs/underwire/2013/02/xwing-bg.gif"
  ) %>% 
  hc_add_theme(hc_theme_flatdark())
```

<iframe src="/htmlwidgets/giving-a-thematic-touch-to-your-interactive-chart/highchart_lurjewm.html"></iframe> <a href="/htmlwidgets/giving-a-thematic-touch-to-your-interactive-chart/highchart_lurjewm.html" target="_blank">open</a>


What do you think? I had fun, so for me this worth every background I used.

![giphy gif](https://media.giphy.com/media/HLhJ9g20qAR0I/giphy.gif) [source](http://www.youtube.com/watch?v=dByCkxXQxoI)

