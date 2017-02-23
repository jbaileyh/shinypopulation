#server
library(shiny)
library(leaflet)
library(markdown)

cities <- read.csv("data/cities.csv")

cities2 <- data.frame(matrix(ncol = 17, nrow = nrow(cities)))

for (j in 1:nrow(cities)){
  for (i in 1:16){
    cities2[j,i] <- (cities[j,6+i] - cities[j,7]) / 1000
  }
}

colnames(cities2) <- colnames(cities)[7:23]
cities[,7:23] <- cities2

precols <- cities[,c(1,3,4,5)]

shinyServer(function(input,output){
  
  df_subset <- reactive({
    a <- cities[,colnames(cities)== paste0("pop", input$year)]
    a <- cbind(precols, a)
    colnames(a)[5] <- "year"
    return(a)
  })
  

  output$map <- renderLeaflet({
    leaflet(cities) %>% 
    addProviderTiles(providers$CartoDB.Positron) %>%
    fitBounds(~min(Longitude), ~min(Latitude), ~max(Longitude), ~max(Latitude)) %>%
      addMiniMap(tiles = providers$CartoDB.Positron,
                 toggleDisplay = TRUE,  aimingRectOptions = list(color = "#55DA3D", weight = 1, clickable = TRUE),
                 shadowRectOptions = list(color = "#55DA3D", weight = 1, clickable = TRUE,
                                          opacity = 0.5, fillOpacity = 0.5))})
  
  

    
  observe({
    data <- df_subset()
    
    leafletProxy("map", data = data) %>%
        clearShapes() %>%
        addCircles(lng = ~Longitude, lat = ~Latitude, weight = 1,
                   radius = ~as.numeric(year) * 50000, color = ~"#55DA3D", fillOpacity = 0.6,
                   popup = paste("<b>Country:</b>", data$Country, '<br>',
                                 "<b>City: </b>", data$City, '<br>',
                                 "<b>Change in population since 1950</b>:",data$year,"million"
                                 ))
                   
    })
  
})
  
