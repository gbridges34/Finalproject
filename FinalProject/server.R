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
#create some useful variables
vars <- c("LotArea", "BldgType", "HouseStyle", "OverallQual", "OverallCond", "1stFlrSF", "FullBath", "TotRmsAbvGrd", "GarageCars", "GarageArea", "SalePrice")
plotTypes <- c("scatterPlot", "barPlot")
data <- data %>% select(all_of(vars))
#begin server function

shinyServer(function(input, output) {
    
#render the summary statistics when user picks summary and a  variable
    #output$summaryPrint <- renderUI(summary(input$summVarPick))
    
#create datatable for data page
    output$datatable <- DT::renderDataTable({
        data
    })

# Downloadable csv of selected dataset ----
    output$downloadData <- downloadHandler(
        filename = function() {
            paste("file", ".csv", sep = "")
        },
        content = function(file) {
            write.csv(data, file, row.names = FALSE)
        }
    )
    
    
    
})
