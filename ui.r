#ui
library(shiny)
library(leaflet)
library(markdown)

shinyUI(bootstrapPage(
  
  tags$style(HTML(".js-irs-0 .irs-single, .js-irs-0 .irs-bar-edge, .js-irs-0 .irs-bar {background: #55DA3D}")),
  list(tags$head(tags$style("body {background-color: #CDD2D4; }"))),
  
  headerPanel(
    h1(title = "Urban Population Growth","Change in Urban Population from 1950-2025", 
       style = "font-family:  'Quicksand', sans-serif;
       font-weight: 500; color: ##232323; background-color:#CDD2D4")),
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  leafletOutput("map", width = "100%", height = "100%"),
  absolutePanel(bottom = 10, left = 10,draggable = TRUE,
                wellPanel(style = "font-family:  'Quicksand', sans-serif;
       font-weight: 500; color:#333333; background-color:#F5F5F3",
                  HTML(markdownToHTML(fragment.only=TRUE, text=c(
                    "Select a year or press play to see <br/> the change 
                    in urban population since 1950"
                  ))),
                sliderInput(inputId = "year", value = 1950,
                min = 1950, max = 2025, label = NULL,
                step = 5, animate = TRUE, sep = ""),
                HTML(markdownToHTML(fragment.only=TRUE, text=c(
                  "<b>Year Selected:</b> (TODO)" 
                )))), 
                style = "opacity: 0.92" 
  )
))


