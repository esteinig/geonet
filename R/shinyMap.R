#' Helper Function: Shiny Map
#' 
#' Helper function to visualize map or globe projection in Shiny.

shinyMap <- function(maps, mode='globejs', time=FALSE){
  
  require(shiny)
  
  shinyApp(
    ui <- bootstrapPage(
      tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
      if (mode=='leaflet' | mode=='samples') {  
        leafletOutput("map", width = "100%", height = "100%")
        }
      else {
        globeOutput("globe",  width = "100%", height = "100%")
      },
      absolutePanel(bottom = 5, left = '40%',
                    if (time==T){
                    sliderInput("range", NULL, 1, length(maps),
                                value = length(maps), step = 1)
                    }
                    )
    ),
    
    
    server <- function(input, output, session) {
      
      if (mode=='leaflet' | mode=='samples') {
        output$map <- renderLeaflet({
          if (time==F) {
            maps[[1]]
          } else {
            maps[[input$range]]
          }
        })
        
      } else {
        output$globe <- renderGlobe({
          
          if (time==F) {
            maps[[1]]
          } else {
            maps[[input$range]]
          }
          
        })
      }
      
    }
  )
  
}