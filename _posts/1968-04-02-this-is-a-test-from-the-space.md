---
title: This is a test from the space
output: html_fragment
categories: R
layout: post
featured_image: /images/this-is-a-test-from-the-space/ploting-1.png
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
|1491  |  0.83|Premium   |D     |SI1     |  61.3|    58|  2990| 6.03| 6.00| 3.69|
|12237 |  1.01|Good      |G     |VS2     |  63.1|    55|  5199| 6.36| 6.38| 4.02|
|537   |  0.70|Very Good |D     |SI1     |  62.3|    59|  2827| 5.67| 5.70| 3.54|
|51593 |  0.70|Very Good |H     |VS1     |  61.5|    58|  2394| 5.66| 5.72| 3.50|
|23810 |  1.70|Good      |H     |SI1     |  63.9|    56| 11869| 7.61| 7.53| 4.84|
|13217 |  1.20|Good      |I     |SI1     |  64.4|    61|  5458| 6.52| 6.59| 4.22|

And this is who we can plot! :D


```r
ggplot(test) +
  geom_point(aes(x = carat, y = price, color = price, shape = cut)) +
  facet_wrap(~color) + 
  theme_fivethirtyeight() + 
  scale_color_continuous_tableau() + 
  theme(legend.position = "none")
```

<img src="/images/this-is-a-test-from-the-space/ploting-1.png" title="plot of chunk ploting" alt="plot of chunk ploting" style="display: block; margin: auto;" />

## h2! 
Lorem lorem lorem
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

