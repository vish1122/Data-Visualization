#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)
library(DT)
library(dplyr)
library(readr)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  mapdata <- reactive({
    data <- data1 %>%
      filter(neighbourhood_group %in% input$boro1 &
               room_type %in% input$roomtype1 &
               price >= input$priceslide[1] &
               price <= input$priceslide[2] &
                number_of_reviews >= input$reviewslide[1] &
               number_of_reviews <= input$reviewslide[2])
    print(nrow(data))
    data
  })
  
  #map
  output$map <- renderLeaflet({
    leaflet() %>% 
      addProviderTiles("Esri.WorldStreetMap") %>% 
      addLegend(position = "bottomleft", 
                pal= factpal,
                values = unique(room)
                )%>%
      setView(lng = -73.9772, lat = 40.7527, zoom = 11)
  })
    
 
  
  # observe an event
 observe({
  proxy <- leafletProxy("map",data = mapdata()) %>% 
      #clearMarkerClusters() %>% 
     clearMarkers() %>%
       #circle
     addCircleMarkers(lng = ~longitude, lat = ~latitude,
                      radius = 0.5, stroke = T, opacity = 0.5,
                      color = ~factpal(room_type),
                      group = "CIRCLE",
                      popup = ~paste('<b><font color="Black">','Listing Information','</font></b><br/>',
                                      'Room Type:', room_type,'<br/>',
                                     'Price:', price,'<br/>',
                                   'Number of Reviews:', number_of_reviews,'<br/>',
                                     'Minimum Night:', minimum_nights,'<br/>',
                                      'Description:', name,'<br/>')) 
      
     
 })

#graph for neighbourhood and room type 
  graph1df <- reactive({
   data1 %>%
    select(neighbourhood_group,room_type,price) %>%
    filter(data1$price >= input$price_slide[1] &
             data1$price <= input$price_slide[2] &
             data1$number_of_reviews >= input$review_slide[1] &
             data1$number_of_reviews <= input$review_slide[2]) %>%
    group_by(neighbourhood_group,room_type) %>%
    summarise(n=n())

})

 output$graph1 <- renderPlotly({

   plot_ly(graph1df(), x = ~n,y = ~room_type, type = "bar",color = ~neighbourhood_group,
           showlegend = TRUE) %>%
     layout(xaxis = list(title = "count"),
            yaxis = list(title = ""),
            barmode ='dodge', font = t)
 })
 #distribution of price
 output$graph2 <- renderPlot({
   ggplot(listings_2_, aes(x = neighbourhood_group, log(price), color = neighbourhood_group)) +
     geom_violin() + geom_boxplot(aes(fill = neighbourhood_group,alpha = 0.2)) +
     ggtitle("Distribution of Price")
 })

 #estimated distribution of availability
 output$graph3 <- renderPlot({
   ggplot(data1, aes(x = occupancy)) + geom_bar(aes(fill = neighbourhood_group))+ theme_fivethirtyeight() + ggtitle("Time of Availability")

 })


 # host properties
output$graph4 <- renderPlot({
ggplot(hostgraph,aes(y= n,fill = neighbourhood_group)) + geom_bar(aes(x = host_id),stat = "identity") + theme(axis.text.x = element_text(angle=90,hjust = 1))
  })
})

