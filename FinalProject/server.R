#
library(shiny)
library(shinydashboard)
library(readr)
library(tidyverse)
library(caret)
library(DT)
library(dplyr)
#read in the data and select the columns that I want to use
data <- read_csv("train.csv")
data <- data %>% select(c("LotArea", ))
#begin server function

shinyServer(function(input, output) {

    output$distPlot <- renderPlot({


    })

})
