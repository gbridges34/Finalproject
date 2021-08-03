#create some useful variables
vars <- c("LotArea", "BldgType", "HouseStyle", "OverallQual", "OverallCond", "1stFlrSF", "FullBath", "TotRmsAbvGrd", "GarageCars", "GarageArea", "SalePrice")
#vars2 <- vars %>% select(-c("SalePrice"))  ##
plotTypes <- c("scatterPlot", "barPlot")

#packages to be read in
library(shiny)
library(shinydashboard)
library(readr)
library(tidyverse)
library(caret)
library(DT)
library(dplyr)
library(ggplot2)
library(plotly)
library(ranger)
# using shinydashboard for some nice features and to accommodate multiple pages
shinyUI(dashboardPage(
    #withMathJax(), if I can figure it out 
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
                    verbatimTextOutput("summaryPrint")),
                    
                    #if the user picks plot
                    
                    conditionalPanel("input.summOrPlot == 'plot'", selectInput("plotTypePick", "pick a plot type", plotTypes, selected = "barPlot"),
                    conditionalPanel("input.plotTypePick == 'barPlot'", selectInput("varBar", "pick a variable", vars, selected = "HouseStyle"),
                        plotlyOutput("plotObject")             
                                     ),
                    conditionalPanel("input.plotTypePick == 'scatterPlot'", selectInput("varScatterX", "which variable for X?", vars)),  
                    conditionalPanel("input.plotTypePick == 'scatterPlot'", selectInput("VarScatterY", "which variable for Y?", vars, selected = "SalePrice"), plotOutput("plotObject2"))
                                     )
                    
                    
                    
                    
                    
                    
            
                    
                    
                    
                    
                    
                    
                    
)
                    ),
#start modeling tab
            tabItem(tabName = "modeling",
                    tabBox(
                            tabPanel("Modeling Info", 
                                     "Multiple Linear Regression is very interpretable but is more rigid than tree based bethods because you are fitting one line to the whole data set. Regression Trees are very intuitive, which is good when for instance trying to explain the decision process to a client, but tend to have higher variance because the method changes dramatically when a different data split is used to fit the model. Bagged trees refer to a model that uses all the possible predictors to form a tree model over and over and averages the result. Random Forests are similar to bagged trees but are generally better than bagging because they avoid a single predictor dominating the results since it uses a random subset of predictors each time the algorithm runs (and thus they are less correlated). A rule of thumb, like the one shown below using MathJax, is sometimes used when trying to pick a number of predictors to use in Random Forests.  Tree based methods, including Random Forests, are better for prediction than interpretation.",
                                     uiOutput("ex1")),
                            
                        tabPanel("Model Fitting",
                                 
                                 actionButton("fitModels", "Fit Models"),
                                 textOutput("modelExplanation"),
                                 sliderInput("split", "How much of the data should go in the test set?", 0, 100, 30),
                                 selectizeInput(inputId = "modelVar", label = "which variables would you like to use?", choices = vars, multiple = TRUE),
                                 selectInput("repeatedOrNot", "what method would you like to use for cross-validation?",choices = c("repeated CV", "CV")),
                                 numericInput("numFolds", "how many folds would you like to use?", value = 5, min = 1, max = 100)
                                 ),
                        tabPanel("Prediction",
                                 numericInput("lotArea", "Lot Area", 0),
                                 selectInput("buildType", "BldgType", choices = c("1Fam", "2fmCon", "Duplex", "Twnhs", "TwnhsE", "")),
                                 selectInput("houseStyle", "HouseStyle", choices = c("1.5Fin", "1.5Unf", "1Story", "2.5Fin", "2.5Unf", "2Story", "SFoyer", "SLvl")),
                                 numericInput("OverQual", "Overall Quality", min = 1, max = 10, step = 1, value = 1),
                                 numericInput("OverCond", "Overall Condition", min = 1, max = 10, step = 1, value = 1),
                                 numericInput("1sf", "First Floor Square Feet", min = 0, value = 1),
                                 numericInput("fullBath", "Full Bathrooms", min = 0, value = 1, step = 1),
                                 numericInput("totRoomsAboveGround", "Total Rooms Above Ground", min = 0, value = 1),
                                 numericInput("garageCars", "Garage Capacity (in # of cars)", min = 0, value = 0, max = 15),
                                 numericInput("garageArea", "Garage Area", min = 0, value = 0)
                                 ),
                                
    
                        
                        width = 12
                    )
                    )
        )
    )
))