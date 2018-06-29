library(shiny)
library(leaflet)
library(dplyr)
library(plotly)
library(maps)
library(ggplot2)
library(scales)
library(readr)
library(RColorBrewer)
library(lattice)
library(ggthemes)
library(plotly)
library(zipcode)
library(GGally)
library(sp)
library(rgdal)
library(leaflet.extras)
library(lubridate)
library(DT)
library(data.table)


data1 <- read_csv("~/Desktop/project datasets/listings (2).csv")
#data2 <- read_csv("~/Desktop/project datasets/neighbourhoods.csv")
#data3 <- read.csv("~/Desktop/project datasets/reviews.csv")
#data4 <- read_csv("~/Desktop/project datasets/calendar.csv")

### values
boro <- c("Bronx","Brooklyn","Manhattan","Queens","Staten Island")
room <- c("Entire home/apt","Private room","Shared room")
listings_2_ <- data1

### group of color for showing categorical value
factpal <- colorFactor(c("#FF5733","#32ff47","#3366FF"),unique(listings_2_$room_type))

#factpal <- colorQuantile("ylOrRd",listings_2_$room_type)
data1 <- data1 %>% mutate(price = ifelse(is.na(price),0,price))
### find the occupancy
data1$occupancy <- cut(data1$availability_365, breaks = 12,
                             labels = c("0-29","30-59","60-89","90-119","120-149","150-179","180-209", "210-239", "240-269", "270-299", "300-329", "330-365"))


#colnames(listings_2_) [colnames(listings_2_)=='id'] <- 'listing_id'
#### find number of properties 
hostgraph<-data1%>% group_by(neighbourhood_group) %>% count(host_id) %>% arrange(desc(n))%>%top_n(10) 
hostgraph$host_id <- as.character(hostgraph$host_id)
sapply(hostgraph, class)
