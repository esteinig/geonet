#'Geonet Options
#'
#'Get options for map projections with Leaflet and globeJS. For details on the effect of these options,
#'please see the manual or the documentation for Leaflet and globeJS.
#'
#'@param jitter        Randomly displace nodes by given amount of Longitude / Latitude. [ float, 0 ]
#'@param nodeColour    Name of column containing colours for the halo of each node. [ string, 'Colour' ]
#'@param nodeSize      Name of column containing sizes for the halo of each node. [ string, 'Size' ]
#'@param nodeFill      Name of column containing fill colours for each node. [ string, 'nodeColour' ]
#'@param timeData      Name of column containing time points for each node. [ string, 'Time' ]
#'@param filterValue   Name of column containing the data to filter edges by. [ string, 'ID' ]
#'@param edgeColours   Colours for un-filtered and filtered edges. [ vector, c('yellow', 'red') ]
#'@param containHTML   Switch for writing data as self-contained HTML. [ bool, FALSE ]
#'
#'@param leaflet.mapStyle        Map style for Leaflet. [ string, 'CartoDB.DarkMatter' ]
#'@param leaflet.mapView         Initial view given by Longitude, Latitude, Zoom. [ vector, c(0,0,3) ]
#'@param leaflet.lineData        Edge width and opacity. [ vector, c(1.5, 0.7) ]
#'@param leaflet.infoData        Names of columns whose data to show in node popups. [ vector, c('ID') ]
#'@param leaflet.nodeOpacity     Node halo opacity. [ float, 0.5 ]
#'@param leaflet.fillOpacity     Node fill opacity. [ float, 0.2 ]
#'@param leaflet.popupTitle      Popup title [ string, "Sample" ]
#'@param leaflet.edgePopup       Switch to add infoData to edges. [ bool, FALSE ]
#'@param leaflet.legend          Switch to add a legend to map. [ bool, FALSE ]
#'@param leaflet.legendLabels    Legend labels. [ vector, c('Label1', 'Label2', 'Label3') ]
#'@param leaflet.legendColours   Colours for each legend entry. [ vector, c('red', 'green', 'yellow') ]
#'@param leaflet.legendPosition  Legend position [ string, 'bottomleft' ]
#'@param leaflet.timeLayers      Switch to generate a single map with one layer for each time point subgraph. [ bool, FALSE ]
#'@param leaflet.nodeLayers      List of layer headers (names) and associated list (value) specifiying column names for node colour, size and fill. [ list, NULL ]
#'@param leaflet.clusterPoints   Cluster points on map (use only in sample mode) [ bool, FALSE ]
#'
#'@param globe.atmosphere       Enable atmosphere. [ bool, FALSE ]
#'@param globe.arcHeight        Arc height. [ float, 0.6 ]
#'@param globe.arcWidth         Arc width. [ float, 2 ]
#'@param globe.arcOpacity       Arc opacity [ float, 0.5 ]
#'@param globe.pointSize        Bar width [ float, 1 ]
#'@param globe.backgroundColour Background colour. [ string, 'black' ]
#'@param globe.bodyColour       Globe body colour. [ string, '#0000ff' ]
#'@param globe.emissiveColour   Globe emissive colour. [ string, '#0000ff' ]
#'@param globe.lightColour      Environmental light colour. [ string, '#aaeeff' ]
#'@param globe.viewField        Initial field of view. [ int, 35 ]
#'@param globe.rotLatitude      Initial view rotational Latitude. [ float, 0 ]
#'@param globe.rotLongitude     Initial view rotational Longitude. [ float, 0 ]
#'@param globe.renderer         Renderer for globeJS. [ string, 'auto' ]
#'@param globe.surfaceImage     File path or URL of image to plot on globe surface. [ str, system.file("images/world.jpg", package = "threejs") ]
#'
#'@usage getOptions(jitter = 0, nodeColour = 'Colour', nodeSize = 'Size', nodeFill = nodeColour, ...)
#'
#'@return list of options for map projection with Leaflet and globeJS
#'
#'@export

geonetOptions <- function(jitter=0, nodeColour='Colour', nodeSize='Size', nodeFill=nodeColour, timeData='Time', filterValue=c('ID'), 
                          edgeColours=c('yellow', 'red'), containHTML=FALSE, 
                             
                          leaflet.mapStyle='CartoDB.DarkMatter', leaflet.infoData = c('ID'), leaflet.lineData=c(1.5, 0.7), leaflet.mapView=c(0,0,3),
                          leaflet.nodeOpacity=0.5, leaflet.fillOpacity=0.2, leaflet.clusterPoints=FALSE, leaflet.timeLayers=FALSE, leaflet.edgePopup=FALSE,
                          leaflet.nodeLayers=NULL, leaflet.legend=FALSE, leaflet.legendTitle='Legend', leaflet.legendColours=c('red', 'green', 'yellow'), 
                          leaflet.legendLabels=c('Label1', 'Label2', 'Label3'), leaflet.legendPosition = 'bottomleft', leaflet.popupTitle="Sample",
                             
                          globe.arcHeight=0.6, globe.arcWidth=2, globe.arcOpacity=0.5, globe.atmosphere=FALSE,
                          globe.backgroundColour='black', globe.bodyColour="#0000ff", globe.emissiveColour='#0000ff',
                          globe.lightColour="#aaeeff", globe.viewField=35, globe.rotLatitude=0, globe.rotLongitude=0,
                          globe.pointSize=1, globe.renderer='auto', globe.surfaceImage=system.file("images/world.jpg", package = "threejs")) {
  
  opts <- list(
    'jitter' = jitter,
    'nodeColour' = nodeColour,
    'nodeSize' = nodeSize,
    'filterValues'= filterValue,
    'edgeColours' = edgeColours,
    'nodeFill' = nodeFill,
    'timeData' = timeData,
    'containHTML' = containHTML,
    
    'leaflet.nodeOpacity' = leaflet.nodeOpacity,
    'leaflet.infoData' = leaflet.infoData,
    'leaflet.clusterPoints' = leaflet.clusterPoints,
    'leaflet.mapView' = leaflet.mapView,
    'leaflet.mapStyle' = leaflet.mapStyle,
    'leaflet.edgePopup' = leaflet.edgePopup,
    'leaflet.lineData' = leaflet.lineData,
    'leaflet.timeLayers' = leaflet.timeLayers,
    'leaflet.nodeLayers' = leaflet.nodeLayers,
    'leaflet.legend' = leaflet.legend,
    'leaflet.legendColours' = leaflet.legendColours,
    'leaflet.legendLabels' = leaflet.legendLabels,
    'leaflet.legendTitle' = leaflet.legendTitle,
    'leaflet.fillOpacity' = leaflet.fillOpacity,
    'leaflet.legendPosition' = leaflet.legendPosition,
	'leaflet.popupTitle'=leaflet.popupTitle,
    
    'globe.arcsHeight' = globe.arcHeight,
    'globe.arcsWidth' = globe.arcWidth,
    'globe.arcsOpacity' = globe.arcOpacity,
    
    'globe.atmosphere' = globe.atmosphere,
    'globe.backgroundColour' = globe.backgroundColour,
    'globe.bodyColour' = globe.bodyColour,
    'globe.emissiveColour' = globe.emissiveColour,
    'globe.lightColour' = globe.lightColour,
    'globe.viewField' = globe.viewField,
    'globe.rotLatitude' = globe.rotLatitude,
    'globe.rotLongitude' = globe.rotLongitude,
    'globe.pointSize' = globe.pointSize,
    'globe.renderer' = globe.renderer,
    'globe.globeSurface' = globe.surfaceImage
    
  )
  
  
  return(opts)
  
} 