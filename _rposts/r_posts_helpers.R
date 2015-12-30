spin_jekyll <- function(r_script){
  
  t0 <- Sys.time()
    
  try(detach(package:printr, unload = TRUE))
  library("knitr")
  
  folder_name <- gsub("^\\d{4}-\\d{2}-\\d{2}-|\\.R$", "", basename(r_script))
  image_folder <- sprintf("images/%s/", folder_name)
  
  options(digits = 3,
          knitr.table.format = "markdown",
          encoding = "UTF-8",
          stringsAsFactors = FALSE)
  
  opts_chunk$set(fig.path = image_folder,
                 warning = FALSE,
                 message = FALSE,
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
  
  diff <- Sys.time() - t0
  message(sprintf("time to spin: %s %s", round(diff, 2), attr(diff, "units")))
  
  invisible()
  
}

iframeFromWidget <- function(wdgt, filename, height = 400){

  htmlwidgets::saveWidget(wdgt, file = filename, selfcontained = TRUE, libdir = NULL)
  file.copy(filename, sprintf("htmlwidgets/%s", filename), overwrite = TRUE)
  file.remove(filename)
  
  tplt <- '<iframe src="/htmlwidgets/{{ fn }}" height={{ h }} style="border:none; background:transparent; overflow:hidden; width:100%;"></iframe>'
  
  whisker::whisker.render(tplt, list(fn = filename, h = height))
  
}

print.htmlwidget <- function(x) {
  iframeFromWidget(x, paste0(class(x)[1], "_", paste0(sample(letters, size = 7), collapse = ""), ".html", collapse = ""))
}

