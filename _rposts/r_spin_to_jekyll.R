rm(list = ls())
library("jbkmisc")

r_script <- "_rposts/2016-01-14-presenting-highcharter.R"

# options(pandoc.stack.size = "4048m")
spin_jekyll_post(r_script)

# source("_rposts/r_posts_helpers.R")
# spin_jekyll(r_script)
