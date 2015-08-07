r_script <-"_rposts/2014-10-24-plotting-gtfs-data-with-r.R"


spin_jekyll <- function(r_script){
  
  message(sprintf("moving %s file to root directory", r_script))
  file.copy(from = r_script, to = basename(r_script), overwrite = TRUE)
  
  knitr::spin(basename(r_script))
  
  r_md <- sub(".R$", ".md", basename(r_script))
  r_html <- sub(".R$", ".html", basename(r_script))
  
  message("changing url path of images")
  r_md_txt <- readLines(r_md)
  r_md_txt <- gsub("<img src=\"images/", "<img src=\"/images/", r_md_txt)
  
  writeLines(r_md_txt, r_md)
  
  file.copy(from = r_md, to = sprintf("_posts/%s", r_md), overwrite = TRUE)
  
  message("removing temporal files")
  file.remove(basename(r_script))
  file.remove(r_md)
  file.remove(r_html)
  
  
  message(sprintf("ready: %s", sprintf("_posts/%s", r_md)))
  invisible()
  
}


spin_jekyll(r_script)

