
#Loading Required Packages
library(shiny)
library(shinydashboard)
library(tidyverse)
library(dplyr)
library(data.table) #needed to read large files fast
library(DT)
library(knitr)
library(arules)#for Rule Mining
library(arulesViz)
library(visNetwork)#network net
library(igraph)
library(RColorBrewer)

library(shinyWidgets)
tr <- read.transactions('./market_basket.csv', format = 'basket', sep=',')

#transactions <- as(tr, "transactions")
rules1 <- apriori(tr, parameter = list(supp = 0.003269976, conf = 0.01, maxlen=3), control = list(verbose = FALSE))


shinyUI(dashboardPage(skin = "red",
                      dashboardHeader(title = 'SANTANDER'),
                      
                      dashboardSidebar(
                        sidebarUserPanel("Santander Team"),
                        sidebarMenu(
                          menuItem("Basket Analysis", tabName = 'order', icon=icon(' fa-shopping-cart')),
                          menuItem("Network", tabName = "data", icon=icon(' fa-bezier-curve'))
                        )
                      ),
                      
                      dashboardBody(
                        
                        tabItems(
                          #BASKET ANALYSIS        
                          tabItem(tabName = "order", 
                                  dropdownButton(
                                    tags$h3("List of Input"), 
                                    sliderInput(inputId = 'sup',
                                                label = 'Support Level',
                                                value = 0.001269976,
                                                min = .00001, max = .009),
                                    sliderInput(inputId = 'conf',
                                                label = 'Confidence Level',
                                                value = 0.01,
                                                min = 0.01, max = 1),
                                    circle = FALSE, status = "danger", icon = icon("sliders"), width = "325px", label = "Select Support and Confidence", 
                                    tooltip = tooltipOptions(title = "Click to see inputs !")
                                  ),
                                  
                                  
                                  fluidRow(title = "Item Frequency", status = "danger", DT::dataTableOutput("rules")),
                                  # fluidRow(title = "Top Assosiation Rules ", align='right', plotOutput('rules' ))
                                  
                                  downloadButton('downloadData', 'Download Rules as CSV', style="color: #fff; background-color: #f70a0a; border-color: #e81c1c")
                                  
                                  
                          ),        
                          
                          
                          
                          #NETWORK
                          tabItem(tabName = "data", 
                                  dropdownButton(
                                    tags$h3("List of Input"), 
                                    selectInput(inputId = 'xcol', label = 'How many rules', choices = c(5, 10, 15, 20, 25, 30, 35, 40, 45, 50,55, 60,
                                                                                                        65,70,75,80,85,90,95,100)),
                                    circle = FALSE, status = "danger", icon = icon("gear"), width = "200px", label = "Select Number of Rules",
                                    tooltip = tooltipOptions(title = "Click to see inputs !")
                                  ),
                                  fluidRow(align= "center", status = "primary", visNetworkOutput("network", width = "85%", height="570px")))
                          
                        )
                      ) )
)

