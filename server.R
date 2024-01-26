# stworzenie aplikacji shiny

shinyServer(function(input, output) {
  observeEvent(input$refresh, {
    refresh()
  })
})
