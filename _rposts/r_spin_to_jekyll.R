rm(list = ls())
library("jbkmisc")

r_script <- "_rposts/2017-01-07-my-KISS-attempt-to-rstatsgoes10k-contest.R"

stopifnot(file.exists(r_script))

spin_jekyll_post(r_script)

sessionInfo()
