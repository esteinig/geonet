#' Helper Function: Filter Status
#' 
#' Helper function to get filter status for each edge in the network.
#' 

getFilterStatus <- function(src, target, data, filter, filterValue) {
  
  category <- filterValue 
  
  src_value <- data[[src, category]]
  
  target_value <- data[[target, category]]

  # Return 1 for T, 0 for F in loop over Edges / Arcs
  
  if (filter == 'same'){
    
    if (src_value == target_value) 1 else 0
    
  } else if (filter == 'different') {
    
    if (src_value != target_value) 1 else 0
    
  } else if (filter == 'link') {
    
    # Link or Between Filter
      
  } else { 0 }
  
}