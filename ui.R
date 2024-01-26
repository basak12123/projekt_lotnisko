library(shiny)
library(shinyjs)
source(file = 'functions.r')


shinyUI(fluidPage(
  useShinyjs(),

  titlePanel("Lotnisko"),

  mainPanel(
    actionButton("refresh", "Refresh")
  )
))
