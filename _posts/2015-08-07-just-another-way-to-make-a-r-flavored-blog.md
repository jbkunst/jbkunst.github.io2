---
title: Just another way to make a R flavored blog
output: html_fragment
categories: R
layout: post
featured_image: /images/just-another-way-to-make-a-r-flavored-blog/github_fork_game.png
---

## This post is in active development!

Load libraries



```r
library("ggplot2")
library("dplyr")
library("jbkmisc")
library("printr")
blog_setup()
```

This usually is "echo=FALSE"


```r
rm(list = ls())
ls()
```

```
## character(0)
```

### Considerations ####

1. Use h3 `###` in R files to spin, because h1 is reserved for title post and h2 is IMO to big and i dont want
to change css XD.
1. Other consideration


![giphy gif](https://media.giphy.com/media/J7NAxMWW5Q6cg/giphy.gif) [source](http://prostheticknowledge.tumblr.com/post/112532178216/rhapsody-in-grey-music-project-from-brian-foo)

### Style ####

*This is single asterisc*.

**This is double asterics**

Single `code? this is working`  
### Show and load data frames ####


```r
head(cars)
```



| speed| dist|
|-----:|----:|
|     4|    2|
|     4|   10|
|     7|    4|
|     7|   22|
|     8|   16|
|     9|   10|

```r
test <- sample_n(diamonds, 1000)

head(test)
```



| carat|cut       |color |clarity | depth| table| price|    x|    y|    z|
|-----:|:---------|:-----|:-------|-----:|-----:|-----:|----:|----:|----:|
|  0.57|Ideal     |E     |VS2     |  61.5|    57|  2491| 5.35| 5.32| 3.28|
|  1.53|Very Good |J     |SI1     |  61.7|    58|  7730| 7.43| 7.47| 4.60|
|  0.41|Very Good |F     |SI1     |  62.9|    56|   755| 4.71| 4.73| 2.97|
|  1.23|Premium   |F     |SI2     |  61.7|    57|  5695| 6.89| 6.86| 4.24|
|  1.21|Very Good |J     |VS2     |  63.0|    57|  4691| 6.73| 6.77| 4.25|
|  2.02|Ideal     |I     |SI2     |  61.7|    57| 13229| 8.12| 8.05| 4.99|

```r
getwd()
```

```
## [1] "C:/Users/Joshua K/Documents/Dev/jbkunst.github.io"
```

```r
mtc <- readr::read_csv("data/mtcars.csv")
```

Showing a table


```r
print(head(mtc))
```

```
## Source: local data frame [6 x 11]
## 
##     mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb
##   (dbl) (int) (dbl) (int) (dbl) (dbl) (dbl) (int) (int) (int) (int)
## 1  21.0     6   160   110  3.90  2.62  16.5     0     1     4     4
## 2  21.0     6   160   110  3.90  2.88  17.0     0     1     4     4
## 3  22.8     4   108    93  3.85  2.32  18.6     1     1     4     1
## 4  21.4     6   258   110  3.08  3.21  19.4     1     0     3     1
## 5  18.7     8   360   175  3.15  3.44  17.0     0     0     3     2
## 6  18.1     6   225   105  2.76  3.46  20.2     1     0     3     1
```

### Printing htmlwidgets objects ####

To print htmlwidgets object we rewrite the *knit_print.htmlwidget* function:


```r
knit_print.htmlwidget
```

```
## function(x, ..., options = NULL){
## 
##     options(pandoc.stack.size = "2048m")
## 
##     wdgtclass <- setdiff(class(x), "htmlwidget")[1]
##     wdgtrndnm <- paste0(sample(letters, size = 7), collapse = "")
##     wdgtfname <- sprintf("htmlwidgets/%s/%s_%s.html", folder_name, wdgtclass, wdgtrndnm)
## 
##     suppressWarnings(try(dir.create(sprintf(sprintf("htmlwidgets/%s", folder_name)))))
## 
##     try(saveWidget(x, file = "wdgettemp.html", selfcontained = TRUE))
## 
##     file.copy("wdgettemp.html", wdgtfname, overwrite = TRUE)
##     file.remove("wdgettemp.html")
## 
##     iframetxt <- sprintf("<iframe src=\"/%s\" height=\"500\" ></iframe>", wdgtfname)
## 
##     asis_output(iframetxt)
##   }
## <environment: 0x0000000003743378>
```

```r
library("highcharter")



x <- hchart(AirPassengers) %>%  
  hc_title(text = "Testing knit_print.htmlwidget") %>% 
  hc_add_theme(hc_theme_smpl())

x
```

<iframe src="/htmlwidgets/just-another-way-to-make-a-r-flavored-blog/highchart_kpxufrd.html" height="500" ></iframe>

```r
library("d3heatmap")
d3heatmap(mtcars, scale = "column")
```

<iframe src="/htmlwidgets/just-another-way-to-make-a-r-flavored-blog/d3heatmap_lvnsrpc.html" height="500" ></iframe>

### Show external images ####

![](/images/just-another-way-to-make-a-r-flavored-blog/github_fork_game_wide.png)
[image source](http://biasedvideogamerblog.com/gamerreview)
### Plotting ####



```r
p <- ggplot(test) +
  geom_point(aes(x = carat, y = price, color = price, shape = cut)) +
  facet_wrap(~color)
p
```

<img src="/images/just-another-way-to-make-a-r-flavored-blog/ploting-1.png" title="plot of chunk ploting" alt="plot of chunk ploting" style="display: block; margin: auto;" />

### To generate the featured image ####

According with http://yihui.name/knitr/options/, dpi: (72; numeric) the
DPI (dots per inch) for bitmap devices (dpi * inches = pixels) so:



```r
desire_width_px <- 720
desire_height_px <- 480
dpi <- 72
fig.width <- desire_width_px / dpi
fig.height <- desire_height_px / dpi

fig.width
```

```
## [1] 10
```

```r
fig.height
```

```
## [1] 6.67
```

This template need a 720 x 480 image. So at the final of the script
I generate a chunk named *featured_image*, with parameters: echo=FALSE,
fig.width=10, fig.height=6.7, dpi=72 and fig.show='hide'.



### Markdown references ####

1. http://milanaryal.com/2015/writing-on-github-pages-and-jekyll-using-markdown/
1. http://ajoz.github.io/2014/06/29/i-want-my-github-flavored-markdown/
1. https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet#line-breaks
1. https://george-hawkins.github.io/basic-gfm-jekyll/redcarpet-extensions.html#hard-wrap
