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

  observeEvent(input$refresh, {
    refresh()
  })
})
