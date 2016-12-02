rm(list = ls())
library("jbkmisc")

r_script <- "_rposts/2016-12-02-replicating-nyt-weather-app.R"

spin_jekyll_post(r_script)

sessionInfo()
