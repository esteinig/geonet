#'Helper Function: Projection Data
#'
#'Helper function to transform graph and meta data to map projection format.

getProjectionData <- function(graph, data, mode='globejs', filter='off', no.edges=FALSE, options=NULL) {
  
  graph.edges <- get.edgelist(graph)
  graph.nodes <- V(graph)$name
  
  filter.state <- apply(graph.edges, 1, function(e) {
    
    getFilterStatus(as.numeric(e[1]), as.numeric(e[2]), data, filter, options[['filterValues']] )
    
  })
  
  edge.colours <- gsub(1, options[[ 'edgeColours' ]][2], filter.state)
  edge.colours <- gsub(0, options[[ 'edgeColours' ]][1], edge.colours)
  
  # Get geographical coordinate edge matrix for Graph
  
  map.matrix <- apply(graph.edges, 1, function(e) {
    
    # Construct matrix with edges Source Lat, Source Long, Target Lat, Target Long
    
    crd_src <- c(data[[as.numeric(e[1]), 'Latitude']], data[[as.numeric(e[1]), 'Longitude' ]])
    crd_target <- c(data[[as.numeric(e[2]), 'Latitude']], data[[as.numeric(e[2]), 'Longitude' ]])
    
    crds <- append(crd_src, crd_target)

    return(crds)
    
  })
  
  map.edges <- t(map.matrix)
  
  # Get node coordinates for Graph
  
  map.nodes <- sapply(graph.nodes, function(n) {
    
    # Construct matrix with nodes Latitude, Longitude
    
    crds <- c(data[[n, 'Latitude']], data[[n, 'Longitude']])
    
    return(crds)
    
  })
  
  map.nodes <- t(map.nodes)
  
  # Get node sizes and colours for Graph
  
  map.colours <- sapply(graph.nodes, function(n) {
    
    col <- c(as.character(data[[n, options[['nodeColour']] ]]))
    
    return(col)
    
  })
  
  map.sizes <- sapply(graph.nodes, function(n) {
    
    size <- c(data[[n, options[['nodeSize']] ]])
    
    return(size)
    
  })
  
  map.fills <- sapply(graph.nodes, function(n) {
    
    fill <- c(as.character(data[[n,  options[['nodeFill']] ]]))
    
    return(fill)
    
  })
  
  map.popups <- as.vector(sapply(graph.nodes, function(n) {
    
    popup <- paste0('<b>', options[['leaflet.popupTitle']], '</b><br/></br>')
    
    for (i in seq_along( options[['leaflet.infoData']] )) {
      
      popup <- paste0(popup, htmlEscape(options[['leaflet.infoData']][i]), ': ', data[[n, options[['leaflet.infoData']][i]]], '<br/>')
      
    }
    
    return(popup)
    
  }))
  
  edge.popups <- as.vector(apply(graph.edges, 1, function(e) {
    
    popup <- paste0('<b>Node 1 </b>', '<br/>', map.popups[e[1]], '<br/>', '<br/>', '<b>Node 2 </b>', '<br/>', map.popups[e[2]], '<br/>')
    
    return(popup)
    
  }))
  
  map.data <- list(
    'map.edges' = map.edges,
    'map.nodes' = map.nodes,
    'map.colours' = map.colours,
    'map.sizes' = map.sizes,
    'graph.edges' = graph.edges,
    'graph.nodes' = graph.nodes,
    'edge.colours' = edge.colours,
    'map.fills' = map.fills,
    'map.popups' = map.popups,
    'edge.popups' = edge.popups
  )
  
  if (no.edges){
    map.data["map.edges"] <- NULL
    map.data["edge.colours"] <- NULL
    map.data["edge.popups"] <- NULL
    map.data["graph.edges"] <- NULL
  }
  
  return(map.data)
}