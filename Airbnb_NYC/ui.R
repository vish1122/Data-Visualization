#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
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

data1 <- read_csv("~/Desktop/project datasets/listings (2).csv")
data2 <- read_csv("~/Desktop/project datasets/neighbourhoods.csv")
data3 <- read.csv("~/Desktop/project datasets/reviews.csv")
data4 <- read_csv("~/Desktop/project datasets/calendar.csv")


# Define UI for application that draws a histogram
shinyUI(
  navbarPage(title = "Airbnb NYC Visualization", 
             id ="nav",
             
             theme = shinytheme("yeti"),
                  
  
  
    
 ####NYc map 
             tabPanel("NYC map",
                      div(class="outer",
                          tags$head(
                            includeCSS("styles.css")),
                          
                          leafletOutput(outputId = "map", width = "100%", height = "100%"),
                          
  absolutePanel(id = "controls",class = "panel panel-default",fixed = TRUE, draggable = TRUE, 
                top = 80, left = "auto", right = 20, bottom = "auto",
                width = 320, height = "auto", 
                
                h2("Airbnb In NYC"),
  checkboxGroupInput(inputId = "boro1", label = h4("Borough"),
                     choices = boro, selected = 'Manhattan'),
  checkboxGroupInput(inputId = "roomtype1", label = h4("Room Type"),
                     choices = room),
  sliderInput(inputId ="priceslide",label = h4("Price"),min = 10,max = 300,step = 20,
              pre = "$", sep = ",", value =c(10,500)),
sliderInput(inputId="reviewslide",label = h4("Reviews"),min = 5,max = 500, step = 30,
              value = c(5,500))
  
  
  )
  
  )
  ),
#   ###listings
  tabPanel("Listings, Boroughs and Price",
           fluidRow(
             column(3,
                      wellPanel(
                      h4("Listings by Boroughs and Type"),
                      sliderInput(inputId = "price_slide",label =strong("Price/Night"),min = 10, max = 1000, value=c(10,1000)),
                       sliderInput(inputId = "review_slide",label= strong("Reviews"), min = 10, max = 100,value = c(10,100))

                    )
             ),


             column(9,
                    wellPanel(
                    h3(""),
                    plotlyOutput(outputId= "graph1", height = 350),
                    br(),
                    plotOutput(outputId = "graph2", height = 350)
                    )

           )
                    )

  ),


 ### distribution of availability

          tabPanel("Occupancy Rate",
          fluidRow(

               column(3,
               h3(""),
              plotOutput(outputId= "graph3",width = 1000, height = 350)
 )


          )
          ),
### host properties
 tabPanel("Host Listings",
          fluidRow(
            column(3,
                   h3(""),
                   plotOutput(outputId= "graph4",width = 1000, height = 350)
            )
          )

                    )

)
)





  

                    
           
                      
           

  









