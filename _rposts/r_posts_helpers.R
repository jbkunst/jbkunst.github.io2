spin_jekyll <- function(r_script){
  
  #### packages ####
  library("knitr")
  library("printr")
  library("stringr")
  #### pars ####
  t0 <- Sys.time()
  folder_name <- gsub("^\\d{4}-\\d{2}-\\d{2}-|\\.R$", "", basename(r_script))
  image_folder <- sprintf("images/%s/", folder_name)
  
  #### options ####
  options(digits = 3, knitr.table.format = "markdown",
          encoding = "UTF-8", stringsAsFactors = FALSE)
  
  opts_chunk$set(fig.path = image_folder, fig.align = "center",
                 warning = FALSE, message = FALSE)
  
  opts_knit$set(root.dir  = normalizePath("."))
  
  knit_print.htmlwidget <<- function(x, ..., options = NULL){
    
    wdgtclass <- setdiff(class(x), "htmlwidget")[1]
    wdgtrndnm <- paste0(sample(letters, size = 7), collapse = "")
    wdgtfname <- sprintf("htmlwidgets/%s/%s_%s.html", folder_name, wdgtclass, wdgtrndnm)
    
    suppressWarnings(try(dir.create(sprintf(sprintf("htmlwidgets/%s", folder_name)))))
    
    htmlwidgets::saveWidget(x, file = "wdgettemp.html", selfcontained = TRUE)
    
    file.copy("wdgettemp.html", wdgtfname, overwrite = TRUE)
    file.remove("wdgettemp.html")
    
    w <- ifelse(str_detect(x$width, "%"), x$width, paste0(x$width + 25, "px"))
    h <- ifelse(str_detect(x$height, "%"), x$width, paste0(x$height + 25, "px"))
    
    iframetxt <- sprintf("<iframe src=\"/%s\" width=\"%s\" height=\"%s\"></iframe>",
                         wdgtfname, w, h)
    
    knitr::asis_output(iframetxt)
  }
    
  
  #### removing widgets if exists ####
  if ( length(dir(sprintf("htmlwidgets/%s", folder_name), full.names = TRUE)) > 0) {
    fs <- dir(sprintf("htmlwidgets/%s", folder_name), full.names = TRUE)
    lapply(fs, file.remove)
  }
  
  #### knitting ####
  message(sprintf("knitting %s", basename(r_script)))
  
  spin(r_script, envir = new.env())
  
  r_md <- sub(".R$", ".md", basename(r_script))
  r_html <- sub(".R$", ".html", basename(r_script))
  
  #### changing images' url ####
  message("changing url path of images")
  r_md_txt <- readLines(r_md)
  r_md_txt <- gsub("<img src=\"images/", "<img src=\"/images/", r_md_txt)
  
  #### moving files ####
  message("moving md file to _posts/ folder")
  writeLines(r_md_txt, r_md)
  file.copy(from = r_md, to = sprintf("_posts/%s", r_md), overwrite = TRUE)
  
  ##### removing temp files ####
  message("removing temporal files")
  file.remove(r_md)
  file.remove(r_html)
  
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

