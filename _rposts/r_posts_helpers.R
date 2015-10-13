iframeFromWidget <- function(wdgt, filename){

  htmlwidgets::saveWidget(wdgt, file = filename, selfcontained = TRUE, libdir = NULL)
  file.copy(filename, sprintf("htmlwidgets/%s", filename), overwrite = TRUE)
  file.remove(filename)
  
  tplt <- '<iframe src="/htmlwidgets/{{ fn }}" width=100% height=400></iframe>'
  
  whisker::whisker.render(tplt, list(fn = filename ))
  
}
