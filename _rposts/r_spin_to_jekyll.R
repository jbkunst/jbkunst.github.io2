rm(list = ls())
r_script <- "_rposts/2015-10-07-rchess-a-chess-package-for-r.R"

spin_jekyll <- function(r_script){
  
  try(detach(package:printr, unload=TRUE))
  library("knitr")
  
  folder_name <- gsub("^\\d{4}-\\d{2}-\\d{2}-|\\.R$", "", basename(r_script))
  image_folder <- sprintf("images/%s/", folder_name)
  
  options(digits = 3, knitr.table.format = "markdown",
          encoding = "UTF-8", stringsAsFactors = FALSE)
  
  opts_chunk$set(fig.path = image_folder,
                 warning = FALSE, message = FALSE,
                 fig.align = "center")
  
  message(sprintf("knitting %s", basename(r_script)))
  spin(r_script, envir = new.env())
  
  r_md <- sub(".R$", ".md", basename(r_script))
  r_html <- sub(".R$", ".html", basename(r_script))
  
  message("changing url path of images")
  r_md_txt <- readLines(r_md)
  r_md_txt <- gsub("<img src=\"images/", "<img src=\"/images/", r_md_txt)
  
  message("moving md file to _posts/ folder")
  writeLines(r_md_txt, r_md)
  file.copy(from = r_md, to = sprintf("_posts/%s", r_md), overwrite = TRUE)
  
  message("removing temporal files")
  file.remove(r_md)
  file.remove(r_html)
  
  if (file.exists(sprintf("_rposts/%s", r_html))) {
    file.remove(sprintf("_rposts/%s", r_html))
  }
  
  message(sprintf("ready: %s", sprintf("_posts/%s", r_md)))
  invisible()
  
}


spin_jekyll(r_script)

