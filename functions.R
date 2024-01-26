library("RPostgres")

open.my.connection <- function() {
  con <- dbConnect(RPostgres::Postgres(),dbname = 'postgres', # nazwa naszej projektowej bazy
                   host = 'localhost',
                   port = 5434, # port ten sam co w psql - zwykle 5432
                   user = 'postgres', # nasza nazwa użytkownika psql
                   password = '') # i nasze hasło tego użytkownika
  return (con)
}

close.my.connection <- function(con) {
  dbDisconnect(con)
}

load.lotniska <- function() {
  query = "SELECT DISTINCT kraj FROM lotnisko"
  con = open.my.connection()
  res = dbSendQuery(con,query)
  lotniska = dbFetch(res)
  dbClearResult(res)
  close.my.connection(con)
  return(lotniska)
}

load.odloty <- function(kraj) {
  query = paste0("SELECT kraj, miasto, data_lotu, godzina_lotu, nazwa
                FROM loty JOIN lotnisko USING(id_lotniska) JOIN status USING(id_statusu)
                 WHERE odlot = TRUE AND kraj = '",
                 kraj,"'")
  con = open.my.connection()
  res = dbSendQuery(con,query)
  odloty = dbFetch(res)
  dbClearResult(res)
  close.my.connection(con)
  return(odloty)
}

load.przyloty <- function(kraj) {
  query = paste0("SELECT kraj, miasto, data_lotu, godzina_lotu, nazwa
                FROM loty JOIN lotnisko USING(id_lotniska) JOIN status USING(id_statusu)
                 WHERE odlot = FALSE AND kraj = '",
                 kraj,"'")
  con = open.my.connection()
  res = dbSendQuery(con,query)
  odloty = dbFetch(res)
  dbClearResult(res)
  close.my.connection(con)
  return(odloty)
}
