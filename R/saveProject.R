#'Helper Function: Save Project
#'
#'Helper function to save project HTML.

saveProject <- function(graphs, maps, mode='globejs', project='geonet', time=FALSE, options=NULL) {
  
  wd <- getwd()
  outdir <- file.path(wd, project)
  if(dir.exists(outdir)){
    unlink(outdir, recursive = T)
  }
  dir.create(outdir)
  setwd(outdir)
  
  times <- names(graphs)
  
  sapply(seq_along(graphs), function(i) {
    
    file <- paste0(project,'_', times[i], '.gml')
    write.graph(graphs[[i]], file, format='gml')
    
  })
  
  sapply(seq_along(maps), function(i) {
    
    if (mode=='globejs') {
      
      if (length(maps) > 1){
        file <- paste0(project, '_globe', times[i], '.html')
      } else {
        file <- paste0(project, '_globe', '.html')
      }
      
      saveWidget(maps[[i]], file, selfcontained = options[['containHTML']]) 
      
    } else if (mode=='leaflet' | mode=='sample') {
      
      if (length(maps) > 1){
        file <- paste0(project, '_leaflet', times[i], '.html')
      } else {
        file <- paste0(project, '_leaflet', '.html')
      }
      
      saveWidget(maps[[i]], file, selfcontained = options[['containHTML']])
      
    } else if (mode=='popgraph') {
      
      file <- paste0(project, '_popgraph', times[i], '.pdf')
      ggsave(file, maps[[i]])
      
    }
    
    
  })
  
  setwd(wd)
  
}