#create some useful variables
vars <- c("LotArea", "BldgType", "HouseStyle", "OverallQual", "OverallCond", "1stFlrSF", "FullBath", "TotRmsAbvGrd", "GarageCars", "GarageArea", "SalePrice")
plotTypes <- c("scatterPlot", "barPlot")

#packages to be read in
library(shiny)
library(shinydashboard)
library(readr)
library(tidyverse)
library(caret)
library(DT)
library(dplyr)
# using shinydashboard for some nice features and to accommodate multiple pages
shinyUI(dashboardPage(
#application title and then the names of each page or tab to be referenced below as per syntax of shinydashboard
    dashboardHeader(title = "Predicting Home Prices", titleWidth = 350),
    dashboardSidebar(
        sidebarMenu(
            menuItem("About", tabName = "about"),
            menuItem("Data", tabName = "data"),
            menuItem("Data Exploration", tabName = "dexp"),
            menuItem("Modeling", tabName = "modeling")
                    )
                     ),
    
    dashboardBody(
        tabItems(
            tabItem(tabName = "about",
                    h4("This app is built to allow for exploration, subsetting, modeling and predicting with a dataset of home prices and other information associated with each listing such as lot size and number of rooms."),
                    h4("The dataset comes from an advanced regression competition put on by Kaggle, more information can be found here:"),
                    h4(tags$a(href = "https://www.kaggle.com/c/house-prices-advanced-regression-techniques/data?select=test.csv", "housing data")),
                    h4("The purpose of the about tab is to give an overview of what the app does and some information about the data. The purpose of the Data tab is to allow the user to scroll through the data, subset it and save the data to a file. The purpose of the Data Exploration tab is to allow the user to create numerical and graphical summaries of the data. The purpose of the Modeling tab is to allow the user to fit different models to the data, and make a prediction based on certain inputs"),
                    img(src = "House.jpg", height = 150, width = 300, align = "left" )),
            #data page
            tabItem(tabName = "data",
                    fluidPage(
                    h2("The Home Prices Dataset"),
                    DT::dataTableOutput("datatable"),
                    downloadButton("downloadData", "Download")
                    )
                        ),
            #Data Exploration page, used conditional panels to handle decision tree for user.
            tabItem(tabName = "dexp",
                    fluidPage(
                    selectInput("summOrPlot", "summary or plot?", c("summary", "plot")),
                    conditionalPanel("input.summOrPlot == 'summary'", selectInput("summVarPick","pick a variable", vars),
                    verbatimTextOutput("summaryPrint"),
                    ),
                    #if the user picks plot
                    
                    conditionalPanel("input.summOrPlot == 'plot'", selectInput("plotTypePick", "pick a plot type", plotTypes))
                    
                    
                    
                    
                    
                    
                    
)
                    ),
#start modeling tab
            tabItem(tabName = "modeling",
                    tabBox(
                        tabPanel("Modeling Info", "Muliple Linear Regression is very interpretable(?) but is more rigid than tree based bethods because you are fitting one line to the whole data set. Regression Trees are very intuitive, for instance if you were trying to explain the idea to a client, but tend to have higher variance. Random Forests are generally better than bagging because they avoid a single predictor dominating the results since it uses a random subset of predictors each time the algorithm runs"),
                        tabPanel("Model Fitting",
                                 sliderInput("split", "How much of the data should go in the test set?", 0, 100, 30),
                                 selectizeInput(inputId = "modelVar", label = "which variables would you like to use?", choices = vars, multiple = TRUE)
                                 ),
                        tabPanel("Prediction"),
                        width = 12
                    )
                    )
        )
    )
))