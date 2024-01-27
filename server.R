shinyServer(function(input, output) {

  output$odloty.tab <- renderDataTable(
    load.odloty(input$kraj), # wywołanie funkcji z example_functions.r
    options = list(
      pageLength = 10,
      lengthChange = FALSE,
      searching = FALSE,
      info = FALSE
    )
  )

  output$przyloty.tab <- renderDataTable(
    load.przyloty(input$kraj_2), # wywołanie funkcji z example_functions.r
    options = list(
      pageLength = 10,
      lengthChange = FALSE,
      searching = FALSE,
      info = FALSE
    )
  )

  output$bilety.pasazer <- renderDataTable(
    load.moje.loty(input$id_biletu), # wywołanie funkcji z example_functions.r
    options = list(
      pageLength = 10,
      lengthChange = FALSE,
      searching = FALSE,
      info = FALSE
    )
  )

  observeEvent(input$szukaj,
               load.moje.loty(input$id_biletu))

  observeEvent(input$refresh, {
    refresh()
  })
})

