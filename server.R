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

  output$bilety.pasazer <- renderDataTable({
    if(trimws(input$id_biletu) != ""){
      load.moje.loty(input$id_biletu)
    } else if(trimws(input$telefon) != ""){
      load.moje.loty.2(input$telefon)
    }},
    options = list(
      pageLength = 10,
      lengthChange = FALSE,
      searching = FALSE,
      info = FALSE
    )
  )

  output$status.tab <- renderDataTable(
    load.status.tab(input$id_lotu), # wywołanie funkcji z example_functions.r
    options = list(
      pageLength = 10,
      lengthChange = FALSE,
      searching = FALSE,
      info = FALSE
    )
  )

  observeEvent(input$szukaj, {
    if(trimws(input$id_biletu) != ""){
      load.moje.loty(input$id_biletu)
    } else if(trimws(input$telefon) != ""){
      load.moje.loty.2(input$telefon)
    }
    })

  observeEvent(input$pasazer.to.add, {
    output$info <- renderPrint(add.pasazer(input$imie,
                                           input$nazwisko,
                                           input$telefon))
  })

  observeEvent(input$update.status,{
    output$info_2 <- renderPrint(update.status(input$id_lotu,
                                             input$nazwa,
                                             input$opoznienie))
    })


  observeEvent(input$refresh, {
    refresh()
  })
})

