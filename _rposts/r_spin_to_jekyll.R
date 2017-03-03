rm(list = ls())
library("jbkmisc")

r_script <- "_rposts/2017-03-03-giving-a-thematic-touch-to-your-interactive-chart.R"

stopifnot(file.exists(r_script))

spin_jekyll_post(r_script)

sessionInfo()
