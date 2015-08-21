---
title: This is a test from the space
output: html_fragment
categories: R
layout: post
featured_image: /images/this-is-a-test-from-the-space/featured_image-1.png
---
# The setup when you spin!
This usually is `echo=FALSE


```r
rm(list = ls())
library("printr")
knitr::opts_knit$set(root.dir  = normalizePath(".."))
```

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
|10188 |  1.33|Premium   |F     |SI2     |  60.4|    60|  4737| 7.17| 7.11| 4.31|
|34273 |  0.25|Very Good |H     |VVS1    |  61.6|    56|   467| 4.07| 4.10| 2.51|
|46207 |  0.51|Ideal     |G     |VVS2    |  62.0|    57|  1750| 5.10| 5.13| 3.17|
|39601 |  0.30|Ideal     |I     |VS1     |  61.0|    58|   491| 4.30| 4.33| 2.63|
|19550 |  1.02|Ideal     |D     |VS1     |  60.5|    56|  8181| 6.55| 6.48| 3.94|
|38827 |  0.42|Ideal     |G     |VS2     |  61.9|    57|  1048| 4.83| 4.79| 2.98|

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

<img src="/images/this-is-a-test-from-the-space/ploting-1.png" title="plot of chunk ploting" alt="plot of chunk ploting" style="display: block; margin: auto;" />

## This is a h2! 

I can load a data



```r
mtcars <- readr::read_csv("data/mtcars.csv")
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

# To generate the featured image.

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



