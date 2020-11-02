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
library(billboarder)#for D3.js charts
library(shinyWidgets)
tr <- read.transactions('./transactions.csv', format = 'basket', sep=',')

transactions <- as(tr, "transactions")
rules1 <- apriori(transactions, parameter = list(supp = 0.003269976, conf = 0.01, maxlen=3), control = list(verbose = FALSE))