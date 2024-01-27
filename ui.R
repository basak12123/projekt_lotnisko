library(shiny)
library(shinyjs)
source(file = 'functions.r')


shinyUI(fluidPage(
  useShinyjs(),

  titlePanel("Lotnisko"),

  mainPanel(

    actionButton("refresh", "Refresh"),


    tabsetPanel(


      tabPanel('Odloty',
               selectInput(inputId = 'kraj',
                           label = 'wybierz kraj',
                           choices = load.lotniska()),
               dataTableOutput('odloty.tab')),

      tabPanel('Przyloty',
               selectInput(inputId = 'kraj_2',
                           label = 'wybierz kraj',
                           choices = load.lotniska()),
               dataTableOutput('przyloty.tab')),

      tabPanel('loty pasażera',
               textInput(inputId = 'telefon',
               label = 'numer telefonu'),
               actionButton(inputId = 'szukaj.loty',
                            label = 'Szukaj'),
               dataTableOutput('bilety.pasazer'))
    )
  )
))

