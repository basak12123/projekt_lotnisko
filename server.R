shinyServer(function(input, output, session) {

  output$odloty.tab <- renderDataTable(
    load.odloty(input$kraj),
    options = list(
      pageLength = 10,
      lengthChange = FALSE,
      searching = FALSE,
      info = FALSE
    )
  )

  output$przyloty.tab <- renderDataTable(
    load.przyloty(input$kraj_2),
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
    } else if(trimws(input$telefon.2) != ""){
      load.moje.loty.2(input$telefon.2)
    }},
    options = list(
      pageLength = 10,
      lengthChange = FALSE,
      searching = FALSE,
      info = FALSE
    )
  )

  output$status.tab <- renderDataTable(
    load.status.tab(input$id_lotu.1),
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
    } else if(trimws(input$telefon.2) != ""){
      load.moje.loty.2(input$telefon.2)
    }
    })

  observeEvent(input$pasazer.to.add, {
    output$info <- renderPrint(add.pasazer(input$imie,
                                           input$nazwisko,
                                           input$telefon.2))
  })

  observeEvent(input$update.status.1,{
    output$info_2 <- renderPrint(update.status(input$id_lotu.1,
                                             input$nazwa.1,
                                             input$opoznienie.1))
    })

  observeEvent(input$lot.to.add, {
    output$info_3 <- renderPrint(add.lot(input$data,
                                       input$godzina,
                                       input$lotnisko,
                                       input$stanowisko,
                                       input$samolot,
                                       input$pilot,
                                       input$kierunek))
  })

  observe(updateSelectInput(session,
                            'lot',
                            choices = load.loty(input$data_2,
                                                input$kierunek_2)))

  observeEvent(input$bilet.to.add, {
    output$info_4 <- renderPrint(add.bilet(input$telefon_3,
                                           input$lot))
  })

  observe(output$bilety.table <- renderDataTable(
    load.bilety(input$id_biletu2),
    options = list(
      pageLength = 10,
      lengthChange = FALSE,
      searching = FALSE,
      info = FALSE
    )
  ))

  observeEvent(input$bilet.to.remove, {
    output$info_5 <- renderPrint(delete.bilet(input$id_biletu2))
  })

  observe(output$bagaz.tab <- renderDataTable(
    load.bagaz(input$id_biletu3),
    options = list(
      pageLength = 10,
      lengthChange = FALSE,
      searching = FALSE,
      info = FALSE
    )
  ))

  observeEvent(input$bagaz.to.add, {
    output$info_6 <- renderPrint(add.bagaz(input$id_biletu4,
                                           input$rodzaj))
  })

  observeEvent(input$refresh, {
    refresh()
  })
})

