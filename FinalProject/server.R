#
library(shiny)
library(shinydashboard)
library(readr)
library(tidyverse)
library(caret)
library(DT)
library(dplyr)
library(ggplot2)
library(plotly)
#read in the data and select the columns that I want to use
dataHouses <- read_csv("train.csv")
#create some useful variables
vars <- c("LotArea", "BldgType", "HouseStyle", "OverallQual", "OverallCond", "1stFlrSF", "FullBath", "TotRmsAbvGrd", "GarageCars", "GarageArea", "SalePrice")
plotTypes <- c("scatterPlot", "barPlot")
dataHouses <- dataHouses %>% select(all_of(vars))
#begin server function

shinyServer(function(input, output, session) {
    output$ex1 <- renderUI({
        withMathJax(helpText('$$m=\\frac{p}{3}$$'))
    })
     
#render the summary statistics when user picks summary and a  variable
        answer <- reactive({input$summVarPick})
    output$summaryPrint <- renderPrint(summary(pull(data, answer())))
    
        barVariable <- reactive({input$varBar})
        scatterVariableX <- reactive({input$varScatterX})
        scatterVariableY <- reactive({input$varScatterY})
#create datatable for data page
    output$datatable <- DT::renderDataTable({
   dataHouses
    })

    output$plotObject <- renderPlotly({
        plotHouse <- ggplot(data = dataHouses, aes_string(barVariable()))
        plotHouse + geom_bar()
    })
    
    output$plotObject2 <- renderPlot({
        plotHouse2 <- ggplot(data = dataHouses, aes(x = scatterVariableX(), y = scatterVariableY()))
        plotHouse2 + geom_point()
    })
    
    output$modelExplanation <- renderText("We will fit three models in order to predict the sale price of the home. Specify which variables you would like to use and we will fit a multiple linear regression model, a regression tree model, and a random forest model")
# Downloadable csv of selected dataset ----
    output$downloadData <- downloadHandler(
        filename = function() {
            paste("file", ".csv", sep = "")
        },
        content = function(file) {
            write.csv(dataHouses, file, row.names = FALSE)
        }
    )
    
    
    
})
