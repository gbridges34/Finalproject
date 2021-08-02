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
colnames(dataHouses) <- make.names(colnames(dataHouses))
#create some useful variables
vars <- c("LotArea", "BldgType", "HouseStyle", "OverallQual", "OverallCond", "FullBath", "TotRmsAbvGrd", "GarageCars", "GarageArea", "SalePrice")
removeSale <- c("SalePrice")
varsPredict <- vars[! vars %in% removeSale]
plotTypes <- c("scatterPlot", "barPlot")
dataHouses <- dataHouses %>% select(all_of(vars))
#begin server function

shinyServer(function(input, output, session) {
    #fits for model fitting tab
    mlrFit <- train(SalePrice ~ ., data = dataHouses, 
                    method = "lm", 
                    preProcess = c("center", "scale"),
                    trControl = trainControl(method = "cv", number = 10))
    regTreeFit <- train(SalePrice ~ ., data = dataHouses, 
                    method = "rpart", 
                    preProcess = c("center", "scale"),
                    trControl = trainControl(method = "cv", number = 10))
    rfFit <- train(SalePrice ~ ., data = dataHouses, 
                    method = "rf", 
                    preProcess = c("center", "scale"),
                    trControl = trainControl(method = "cv", number = 10))
    
    
        
        
        
    output$ex1 <- renderUI({
        withMathJax(helpText('$$m=\\frac{p}{3}$$'))
    })
     
#render the summary statistics when user picks summary and a  variable
        answer <- reactive({input$summVarPick})
    output$summaryPrint <- renderPrint(summary(pull(data, answer())))
    #create additional reactive variables as needed
        barVariable <- reactive({input$varBar})
        scatterVariableX <- reactive({input$varScatterX})
        scatterVariableY <- reactive({input$varScatterY})
        splitData <- .7
        train <- sample(1:nrow(dataHouses), size = nrow(dataHouses)*splitData)
        test <- dplyr::setdiff(1:nrow(dataHouses), train)
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
