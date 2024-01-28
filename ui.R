library(shiny)
library(shinyjs)
library(shinythemes)
library(shinyTime)
source(file = 'functions.r')


shinyUI(fluidPage(
  theme = shinytheme("darkly"),
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

      tabPanel('Loty pasażera',
               textInput(inputId = 'id_biletu',
                         label = 'Podaj numer biletu'),
               textInput(inputId = 'telefon.2',
                         label = 'Podaj numer telefonu'),
               actionButton(inputId = 'szukaj',
                            label = 'Szukaj'),
               dataTableOutput('bilety.pasazer'),
               dataTableOutput('bilety.pasazer.2')),

      tabPanel('Zaktualizuj status',
               selectInput(inputId = 'id_lotu',
                           label = 'Wybierz lot',
                           choices = load.id.lotu()),

               dataTableOutput('status.tab'),

               selectInput(inputId='nazwa',
                           label='wybierz status',
                           choices=load.status()),

               textInput(inputId = 'opoznienie',
                         label = 'Podaj opoznienie'),

               actionButton(inputId = 'update.status',
                            label = 'zaaktualizuj'),
               verbatimTextOutput("info_2")),

      tabPanel('Dodaj pasażera',
               textInput(inputId = 'imie',
                         label = 'Imię'),
               textInput(inputId = 'nazwisko',
                         label = 'Nazwisko'),
               textInput(inputId = 'telefon',
                         label = 'Telefon'),
               actionButton(inputId = 'pasazer.to.add',
                            label = 'Dodaj'),
               verbatimTextOutput("info")),

      tabPanel('Dodaj lot',
               dateInput(inputId = 'data',
                         label = 'Data lotu'),
               timeInput(inputId = 'godzina',
                         label = 'Godzina lotu',
                         seconds = FALSE),
               selectInput(inputId = 'lotnisko',
                           label = 'Lotnisko',
                           choices = load.full.lotniska()),
               selectInput(inputId = 'stanowisko',
                         label = 'Stanowisko',
                         choices = 1:6),
               selectInput(inputId = 'samolot',
                           label = 'Samolot',
                           choices = load.samoloty()),
               selectInput(inputId = 'pilot',
                           label = 'Pilot',
                           choices = load.piloci()),
               selectInput(inputId = 'kierunek',
                           label = 'Czy odlatuje?',
                           choices = c(TRUE, FALSE)),
               actionButton(inputId = 'lot.to.add',
                            label = 'Dodaj'),
               verbatimTextOutput("info_3")),

      tabPanel('Dodaj bilet',
               selectizeInput(inputId = 'telefon_3',
                         label = 'Numer telefonu pasażera',
                         choices = load.numery.telefonu()),
               dateInput(inputId = 'data_2',
                         label = 'Data lotu'),
               selectInput(inputId = 'kierunek_2',
                              label = 'Kierunek',
                              choices = c('Odlot', 'Przylot')),
               selectInput(inputId = 'lot',
                           label = 'Wybierz lot',
                           choices = NULL),
               actionButton(inputId = 'bilet.to.add',
                            label = 'Dodaj'),
               verbatimTextOutput("info_4")),

      tabPanel('Usuń bilet',
               textInput(inputI = 'id_biletu',
                         label = 'Numer biletu'),
               actionButton(inputId = 'bilet.to.remove',
                            label = 'Usuń'),
               verbatimTextOutput("info_5"))

    )
  )
))

