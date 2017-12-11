#' Geonet Map Projection
#' 
#' Generate a map projection of sample data and undirected networks with Leaflet or globeJS.
#'
#' @param data     Data frame containing meta data for each vertex (ordered as vertices in graph); requires columns 'ID', 'Longitude', 'Latitude', 'Colour', 'Size'.
#' @param graph    Undirected network, iGraph [ NULL ]
#' @param mode     Mapping mode, one of: 'leaflet', 'globejs', 'sample' [ string, 'sample' ]
#' @param filter   Enable colour filter for edges, one of: 'different', 'same', 'off' [ string, 'off' ]
#' @param time     Decompose graph and map subgraphs by time points [ bool, FALSE ]
#' @param save     Save visualization as project in current working directory [ bool, FALSE ]
#' @param shiny    Show results in simple Shiny App [ bool, FALSE ]
#' @param project  Project name for saving output [ string, 'project' ]
#' @param options  List of options from geonetOptions() [ list, geonetOptions() ]
#' 
#' @return list of map objects
#' 
#' @usage geonet(g, d, mode = 'globejs', filter = 'off', .. , options = geonetOptions())
#' 
#' @export

geonet <- function(data, graph=NULL, mode='globejs', filter='off', time=FALSE, shiny=FALSE, save=FALSE,
                   project='project', options=geonetOptions() ) {
  
  require(threejs)
  require(htmlwidgets)
  require(igraph)
  require(leaflet)
  require(htmltools)
  require(shiny)
  
  message('Geonet R')
  
  if (is.null(graph)) {
	  graph <- graph.ring(n=nrow(data))
	  no.edges = TRUE # Hacking replacement graph, needs to be implemented properly.
  } else {
    no.edges = FALSE
  }
  
  if( options[['jitter']] > 0 ) {
    data[['Latitude']] <- jitter(data[['Latitude']], amount = options[['jitter']])
    data[['Longitude']] <- jitter(data[['Longitude']], amount = options[['jitter']])
  }
  
  V(graph)$name <- seq_len(vcount(graph))
  
  if (time==TRUE){
    message("Decomposing graph by time points...")
    graphs <- getTimeGraphs(graph, data=data, options=options)
  } else {
    graphs <- list(graph)
  }
  
  map.data <- lapply(graphs, function(graph) { getProjectionData(graph=graph, data=data, mode=mode, filter=filter, no.edges=no.edges, options=options) })
  names(map.data) <- names(graphs)
  
  print(map.data)
  
  message('Getting projections...')
  maps <- getProjection(data=data, meta=data, map.data=map.data, mode=mode, time=time, filter=filter, options=options)
  
  if (save==TRUE){
    message('Saving...')
    saveProject(graphs=graphs, maps=maps, mode=mode, time=time, project=project, options=options) 
    
  }
  
  if (shiny==T){
    message('Running Shiny...')
    shinyMap(maps=maps, mode=mode, time=time)
  } else {
    return(maps)
  }
  
}