#'Helper Function: Time Graphs
#'
#'Helper function to get time-point subgraphs.

getTimeGraphs <- function(g, data, options=NULL) {
  
  # Gets subgraphs of g by unique time point, returns named list of time subgraphs.
  
  time.t <- sort( unique(data[[ options[['timeData']] ]]), na.last=NA )
  
  message('Removing vertices with time NA...')
  
  time.graphs <- lapply(time.t, function(t) {
    
    keep <- which( data[[ options[['timeData']] ]] <= t )
    time.graph <- induced_subgraph(g, keep, impl='auto')
    
    return(time.graph)
    
    
  })
  
  names(time.graphs) <- time.t
  
  return(time.graphs)
  
}