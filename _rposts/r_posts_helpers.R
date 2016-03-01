spin_jekyll <- function(r_script){
  
  #### packages ####
  library("knitr")
  library("printr")
  library("stringr")
  #### pars ####
  t0 <- Sys.time()
  folder_name <<- gsub("^\\d{4}-\\d{2}-\\d{2}-|\\.R$", "", basename(r_script))
  image_folder <- sprintf("images/%s/", folder_name)
  
  #### options ####
  options(digits = 3, knitr.table.format = "markdown",
          encoding = "UTF-8", stringsAsFactors = FALSE)
  
  opts_chunk$set(fig.path = image_folder, fig.align = "center",
                 warning = FALSE, message = FALSE)
  
  opts_knit$set(root.dir  = normalizePath("."))
  
  #### removing widgets if exists ####
  if ( length(dir(sprintf("htmlwidgets/%s", folder_name), full.names = TRUE)) > 0) {
    fs <- dir(sprintf("htmlwidgets/%s", folder_name), full.names = TRUE)
    lapply(fs, file.remove)
  }
  
  knit_print.htmlwidget <<- function(x, ..., options = NULL){
    
    options(pandoc.stack.size = "2048m")
    
    wdgtclass <- setdiff(class(x), "htmlwidget")[1]
    wdgtrndnm <- paste0(sample(letters, size = 7), collapse = "")
    wdgtfname <- sprintf("htmlwidgets/%s/%s_%s.html", folder_name, wdgtclass, wdgtrndnm)
    
    suppressWarnings(try(dir.create(sprintf(sprintf("htmlwidgets/%s", folder_name)))))
    
    try(htmlwidgets::saveWidget(x, file = "wdgettemp.html", selfcontained = TRUE))
    
    file.copy("wdgettemp.html", wdgtfname, overwrite = TRUE)
    file.remove("wdgettemp.html")
    
    iframetxt <- sprintf("<iframe src=\"/%s\" height=\"500\" ></iframe>", wdgtfname)
    
    knitr::asis_output(iframetxt)
  }
  
  

  #### knitting ####
  message(sprintf("knitting %s", basename(r_script)))
  
  #spin(r_script, envir = new.env())
  knit2html(spin(r_script, knit = FALSE), force_v1 = TRUE,  envir = new.env())
  
  r_md <- sub(".R$", ".md", basename(r_script))
  r_rmd <- sub(".R$", ".Rmd", basename(r_script))
  r_html <- sub(".R$", ".html", basename(r_script))
  
  #### changing images' url ####
  message("changing url path of images")
  r_md_txt <- readLines(r_md)
  r_md_txt <- gsub("<img src=\"images/", "<img src=\"/images/", r_md_txt)
  
  #### moving files ####
  message("moving md file to _posts/ folder")
  writeLines(r_md_txt, sprintf("_posts/%s", r_md))
  
  ##### removing temp files ####
  message("removing temporal files")
  file.remove(r_md)
  file.remove(r_html)
  file.remove(file.path("_rposts", r_rmd))
  
  if (file.exists(sprintf("_rposts/%s", r_html))) {
    file.remove(sprintf("_rposts/%s", r_html))
  }
  
  #### finished ####
  message(sprintf("ready: %s", sprintf("_posts/%s", r_md)))
  diff <- Sys.time() - t0
  message(sprintf("time to spin: %s %s", round(diff, 2), attr(diff, "units")))
  invisible()
  
}

iframeFromWidget <- function(wdgt, filename, height = 400){
  
  htmlwidgets::saveWidget(wdgt, file = filename, selfcontained = TRUE, libdir = NULL)
  file.copy(filename, sprintf("htmlwidgets/%s", filename), overwrite = TRUE)
  file.remove(filename)
  
  tplt <- '<iframe src="/htmlwidgets/{{ fn }}" height={{ h }}"></iframe>'
  
  whisker::whisker.render(tplt, list(fn = filename, h = height))
  
}

