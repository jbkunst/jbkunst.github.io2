iframeFromWidget <- function(wdgt, filename, height = 400){

  htmlwidgets::saveWidget(wdgt, file = filename, selfcontained = TRUE, libdir = NULL)
  file.copy(filename, sprintf("htmlwidgets/%s", filename), overwrite = TRUE)
  file.remove(filename)
  
  tplt <- '<iframe src="/htmlwidgets/{{ fn }}" height={{ h }} style="border:none; background:transparent; overflow:hidden; width:100%;"></iframe>'
  
  whisker::whisker.render(tplt, list(fn = filename, h = height))
  
}

