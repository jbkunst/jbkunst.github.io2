---
title: This is a test from the space
output: html_fragment
categories: R
layout: post
featured_image: /images/this-is-a-test-from-the-space/featured_image-1.png
---



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
|43371 |  0.58|Ideal     |F     |SI1     |  61.4|    57|  1408| 5.33| 5.38| 3.29|
|29068 |  0.40|Very Good |E     |SI1     |  63.0|    57|   687| 4.65| 4.68| 2.94|
|38853 |  0.40|Premium   |G     |VVS2    |  61.1|    58|  1050| 4.76| 4.74| 2.90|
|43931 |  0.30|Ideal     |I     |VVS2    |  62.2|    56|   515| 4.27| 4.31| 2.67|
|25253 |  1.43|Premium   |D     |VS2     |  62.6|    59| 13873| 7.19| 7.21| 4.51|
|17077 |  1.20|Very Good |E     |SI1     |  61.0|    58|  6809| 6.83| 6.88| 4.18|

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


