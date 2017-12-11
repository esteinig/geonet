#'Helper Function: Projection
#'
#'Helper function to construct network map projection.

getProjection <- function(data, meta, map.data, mode='globejs', time=FALSE, filter='off', options=NULL) {
  
  if( (mode=='leaflet' & time==T & options[['leaflet.timeLayers']]==T) | (mode=='samples' & time==T & options[['leaflet.timeLayers']]==T)){
    
    # Initiate layer adding to Leaflet with Time Data (separate because other modes do not support layering as in Leaflet)
    
        if (options[['leaflet.clusterPoints']]==T) {
          sample.cluster <- markerClusterOptions()
        } else {
          sample.cluster <- NULL
        }
        
        view <- options[['leaflet.mapView']]
        
        map <- leaflet() 
        
        map <- addProviderTiles(map, options[['leaflet.mapStyle']])
        
        map <- setView(map, view[1], view[2], zoom = view[3])
        
        for (i in seq_along(map.data)) {
          
          map.edges <- map.data[[i]][['map.edges']]
          map.nodes <- map.data[[i]][['map.nodes']]
          map.popups <- map.data[[i]][['map.popups']]
          
          edge.popups <- map.data[[i]][['edge.popups']]
          edge.colours <- map.data[[i]][['edge.colours']]
          
          if (options[['leaflet.edgePopup']]==F) {
              edge.popups <- NULL
            }
          
          map.edges <- data.frame(SourceLong=map.edges[,2], SourceLat=map.edges[,1],
                                  TargetLong=map.edges[,4], TargetLat=map.edges[,3])
          
          map <- addCircleMarkers(map, lng=meta$Longitude, lat=meta$Latitude, weight=as.numeric(as.character(meta[[options[["nodeColour"]]]])), opacity = options[['leaflet.nodeOpacity']],
                                  color=as.character(meta[[options[["nodeColour"]]]]), fillColor=as.character(meta[[options[["nodeFill"]]]]), fillOpacity=options[['leaflet.fillOpacity']],
                                  clusterOptions=sample.cluster, group=names(map.data)[i], popup=map.popups)
          
          if (mode=='leaflet'){
          
              line.options <- options[['leaflet.lineData']]
              
              line.weight <- line.options[1]
              line.opacity <- line.options[2]
                
                for (j in seq(1, nrow(map.edges))){
                  
                  # Need to add separate Polylines.
                  
                  map <- addPolylines(map, lng = c(as.numeric(map.edges[[j,'SourceLong']]), as.numeric(map.edges[[j,'TargetLong']])),
                                      lat = c(as.numeric(map.edges[[j,'SourceLat']]), as.numeric(map.edges[[j,'TargetLat']])),
                                      color=edge.colours[j], weight=line.weight, opacity=line.opacity, group=names(map.data)[i], popup=edge.popups)
                  
              }
            } 
          } 
        
        if (options[['leaflet.legend']] == TRUE){
          
          legend.colors <- options[['leaflet.legendColours']]
          names(legend.colors) <-  options[['leaflet.legendLabels']]
          
          map <- addLegend(map, position = options[['leaflet.legendPosition']], colors=legend.colors, labels=names(legend.colors), title=options[['leaflet.legendTitle']], opacity=1)
          
          
        }
        
        map <- addLayersControl(map,
                                baseGroups = names(map.data),
                                options = layersControlOptions(collapsed = FALSE)
                                )
        
        return(list(map))
    }
  
  ################### Standard Leaflet Rendering Mode ############################
  
  map.final <- lapply(map.data, function(md) {
    
    map.edges <- md[['map.edges']]
    map.nodes <- md[['map.nodes']]
    map.popups <- md[['map.popups']]
    
    edge.popups <- md[['edge.popups']]
    edge.colours <- md[['edge.colours']]
    
    graph.nodes <- md[['graph.nodes']]
    graph.edges <- md[['graph.edges']]
    
    if (mode=='globejs') {
        
        map <- globejs(lat=meta$Latitude, long=meta$Longitude, arcs=map.edges,
                       color=as.character(meta[[options[["nodeColour"]]]]), value=as.numeric(as.character(meta[[options[["nodeSize"]]]])), arcsColor=edge.colours,
                       arcsHeight = options[[ 'globe.arcsHeight' ]], arcsLwd = options[[ 'globe.arcsWidth' ]],
                       arcsOpacity = options[[ 'globe.arcsOpacity' ]], atmosphere = options[[ 'globe.atmosphere' ]],
                       bg = options[[ 'globe.backgroundColour' ]], bodycolor = options[[ 'globe.bodyColour' ]],
                       emissive=options[[ 'globe.emissiveColour' ]], lightcolor = options[[ 'globe.lightColour' ]],
                       fov=options[[ 'globe.viewField' ]], rotationlat=options[[ 'globe.rotLatitude' ]],
                       rotationlong=options[[ 'globe.rotLongitude' ]], pointsize=options[[ 'globe.pointSize' ]],
                       renderer=options[[ 'globe.renderer' ]], img=options[[ 'globe.globeSurface' ]])
      
      return(map)
      
      
    } else if (mode=='leaflet' | mode=='sample') {
      
      map.edges <- data.frame(SourceLong=map.edges[,2], SourceLat=map.edges[,1],
                              TargetLong=map.edges[,4], TargetLat=map.edges[,3])
      
      if (options[['leaflet.clusterPoints']]==T) {
        sample.cluster <- markerClusterOptions()
      } else {
        sample.cluster <- NULL
      }
      
      if (options[['leaflet.edgePopup']]==F) {
        edge.popups <- NULL
      }
      
      view <- options[['leaflet.mapView']]
      
      map <- leaflet() 
      
      map <- addProviderTiles(map, options[['leaflet.mapStyle']])
      
      map <- setView(map, view[1], view[2], zoom = view[3])
      
      # Circles
      
      if( !is.null( options[['leaflet.nodeLayers']] ) ) {
        
        # If node data columns are given as layers, create node layers with 
        # sizes and colours / fills in vector nodeLayers. 
        # List. Names = Layer Names, Values = vector giving columns in data for nodeColours, nodeSize and nodeFills
    
        layer.options <- options[['leaflet.nodeLayers']]
        
        # Define new colours and sizes based on given columns:
        
        for (i in seq_along(layer.options)) {
          
          layer.colours <- sapply(graph.nodes, function(n) {
            
            col <- c(as.character(data[[ n, layer.options[[i]][1] ]]))
            
            return(col)
            
          })
          
          layer.sizes <- sapply(graph.nodes, function(n) {
            
            size <- c(data[[ n, layer.options[[i]][2] ]])
            
            return(size)
            
          })
          
          layer.fills <- sapply(graph.nodes, function(n) {
            
            col <- c(as.character(data[[ n, layer.options[[i]][3] ]]))
            
            return(col)
            
          })
          
          # In each iteration add the grouped layer, group name is name of list with layer options
          
          map <- addCircleMarkers(map, lng=meta$Longitude, lat=meta$Latitude, weight=layer.sizes, opacity = options[['leaflet.nodeOpacity']],
                                  color=layer.colours, fillColor=layer.fills, fillOpacity = options[['leaflet.fillOpacity']],
                                  clusterOptions=sample.cluster, group=names(layer.options)[i], popup=map.popups)
          
        }
        
        map <- addLayersControl(map,
                                baseGroups = names(layer.options),
                                options = layersControlOptions(collapsed = TRUE),
                                position='topright'
        )
        
        
      } else {
        
        map <- addCircleMarkers(map, lng=meta$Longitude, lat=meta$Latitude, weight=as.numeric(as.character(meta[[options[["nodeSize"]]]])), opacity = options[['leaflet.nodeOpacity']],
                                fillColor=as.character(meta[[options[["nodeFill"]]]]), color=as.character(meta[[options[["nodeColour"]]]]), fillOpacity = options[['leaflet.fillOpacity']],
                                clusterOptions=sample.cluster, popup = map.popups)
        
        if (options[['leaflet.legend']] == TRUE){
          
          legend.colors <- options[['leaflet.legendColours']]
          names(legend.colors) <-  options[['leaflet.legendLabels']]
          
          map <- addLegend(map, position = options[['leaflet.legendPosition']], colors=legend.colors, labels=names(legend.colors), title=options[['leaflet.legendTitle']], opacity=1)
          
          
        }
        
      }
      
      if (mode=='leaflet') {
      
          line.options <- options[['leaflet.lineData']]
          
          line.weight <- line.options[1]
          line.opacity <- line.options[2]
          
            
            for (i in seq(1, nrow(map.edges))){
              
              map <- addPolylines(map, lng = c(as.numeric(map.edges[[i,'SourceLong']]), as.numeric(map.edges[[i,'TargetLong']])),
                                  lat = c(as.numeric(map.edges[[i,'SourceLat']]), as.numeric(map.edges[[i,'TargetLat']])),
                                  color=edge.colours[i], weight=line.weight, opacity=line.opacity, popup=edge.popups) 
              
            }          
      
      
      }
      
      return(map)
      
    }
  })
  
  names(map.final) <- names(map.data)
  
  return(map.final)
  
}