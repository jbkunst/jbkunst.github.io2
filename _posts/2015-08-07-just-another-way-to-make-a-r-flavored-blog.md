---
title: Just another way to make a R flavored blog
output: html_fragment
categories: R
layout: post
featured_image: /images/just-another-way-to-make-a-r-flavored-blog/github_fork_game.png
---

## **This post is in active development**!

![](/images/just-another-way-to-make-a-r-flavored-blog/github_fork_game_wide.png)
[image source](http://biasedvideogamerblog.com/gamerreview)

This usually is "echo=FALSE"


```r
rm(list = ls())
library("printr")
knitr::opts_knit$set(root.dir  = normalizePath(".."))
```

## Considerations

1. Use h2 `##` in R files to spin, because h1 is reserved for title post.
1. At the begin of R script write a chunk of R code loading the print package
1. 
This post have some considerations to have when write a post via: 
r script > spind > md and testing r srcipt > html_fragment:


```r
print(getwd())
```

```
## [1] "C:/Users/jkunst/Documents/r/jbkunst.github.io"
```

```r
print(knitr::opts_knit$get("root.dir"))
```

```
## [1] "C:\\Users\\jkunst\\Documents\\r\\jbkunst.github.io"
```

this should be equal when knit via ctrl+ shift + K
## Testing knitr::spin on this R script

Load libraries



```r
library("ggplot2")
library("ggthemes")
library("dplyr")
```

this is how we show tables


```r
test <- sample_n(diamonds, 1000)
head(test)
```



|      | carat|cut       |color |clarity | depth| table| price|    x|    y|    z|
|:-----|-----:|:---------|:-----|:-------|-----:|-----:|-----:|----:|----:|----:|
|47353 |  0.50|Premium   |D     |VS2     |  62.9|    61|  1845| 5.03| 4.96| 3.14|
|18805 |  1.51|Good      |F     |SI2     |  64.2|    61|  7695| 7.24| 7.19| 4.63|
|7947  |  1.07|Premium   |F     |SI2     |  58.2|    58|  4319| 6.79| 6.72| 3.93|
|23936 |  1.26|Ideal     |G     |VVS2    |  61.4|    55| 12066| 6.96| 6.99| 4.29|
|1346  |  0.63|Ideal     |D     |VVS2    |  62.6|    56|  2962| 5.47| 5.49| 3.43|
|25388 |  2.00|Very Good |G     |SI2     |  64.0|    58| 14074| 7.86| 7.95| 5.06|

And this is who we can plot! :D


```r
p <- ggplot(test) +
  geom_point(aes(x = carat, y = price, color = price, shape = cut)) +
  facet_wrap(~color) + 
  theme_fivethirtyeight() + 
  scale_color_continuous_tableau() + 
  theme(legend.position = "none")
p
```

<img src="/images/just-another-way-to-make-a-r-flavored-blog/ploting-1.png" title="plot of chunk ploting" alt="plot of chunk ploting" style="display: block; margin: auto;" />

### This is a h3! 

I can load a data



```r
mtcars <- readr::read_csv("data/mtcars.csv")
```

Showing a table


```r
head(mtcars)
```



|  mpg| cyl| disp|  hp| drat|   wt| qsec| vs| am| gear| carb|
|----:|---:|----:|---:|----:|----:|----:|--:|--:|----:|----:|
| 21.0|   6|  160| 110| 3.90| 2.62| 16.5|  0|  1|    4|    4|
| 21.0|   6|  160| 110| 3.90| 2.88| 17.0|  0|  1|    4|    4|
| 22.8|   4|  108|  93| 3.85| 2.32| 18.6|  1|  1|    4|    1|
| 21.4|   6|  258| 110| 3.08| 3.21| 19.4|  1|  0|    3|    1|
| 18.7|   8|  360| 175| 3.15| 3.44| 17.0|  0|  0|    3|    2|
| 18.1|   6|  225| 105| 2.76| 3.46| 20.2|  1|  0|    3|    1|

## To generate the featured image.

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



## Markdown references

1. http://milanaryal.com/2015/writing-on-github-pages-and-jekyll-using-markdown/
1. http://ajoz.github.io/2014/06/29/i-want-my-github-flavored-markdown/
1. https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet#line-breaks
1. https://george-hawkins.github.io/basic-gfm-jekyll/redcarpet-extensions.html#hard-wrap
