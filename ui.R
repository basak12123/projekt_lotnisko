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
               textInput(inputId = 'id_biletu',
               label = 'Podaj numer biletu'),
               actionButton(inputId = 'szukaj',
                            label = 'Szukaj'),
               dataTableOutput('bilety.pasazer')),

      tabPanel('Dodaj pasażera',
               textInput(inputId = 'imie',
                         label = 'Imię'),
               textInput(inputId = 'nazwisko',
                         label = 'Nazwisko'),
               textInput(inputId = 'telefon',
                         label = 'Telefon'),
               actionButton(inputId = 'pasazer.to.add',
                            label = 'Dodaj'))

    )
  )
))

