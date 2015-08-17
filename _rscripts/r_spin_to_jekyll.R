r_script <- "_rposts/2014-10-24-plotting-gtfs-data-with-r.R"


spin_jekyll <- function(r_script){
  
  message(sprintf("moving %s file to root directory", r_script))
  file.copy(from = r_script, to = basename(r_script), overwrite = TRUE)
  
  dir(sprintf("images/%s", basename(r_script)))
  
  
  image_folder <- sprintf("images/%s/",
                          gsub("\\d{4}-\\d{2}-\\d{2}-|.R$", "", basename(r_script)))
  message(sprintf("trying remove plots in %s", image_folder))
  
  for (f in dir(image_folder, full.names = TRUE)) {
    message(sprintf("removing: %s", f))
    file.remove(f)
  }
  
  message(sprintf("knitting %s", basename(r_script)))
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

