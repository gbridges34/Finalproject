
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
            tabItem(tabName = "data"),
            tabItem(tabName = "dexp"),
            tabItem(tabName = "modeling")
        )
    )
))