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
  query =  paste0("SELECT w.kraj, w.miasto, w.data_lotu, w.godzina_lotu, s.nazwa, l.opoznienie, w.wolne_miejsca
                FROM ile_wolnych_miejsc w JOIN loty l USING(id_lotu) JOIN status s USING(id_statusu)
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
  query = paste0("SELECT w.kraj, w.miasto, w.data_lotu, w.godzina_lotu, s.nazwa, l.opoznienie, w.wolne_miejsca
                FROM ile_wolnych_miejsc w JOIN loty l USING(id_lotu) JOIN status s USING(id_statusu)
                 WHERE odlot = FALSE AND kraj = '",
                 kraj,"'")
  con = open.my.connection()
  res = dbSendQuery(con,query)
  odloty = dbFetch(res)
  dbClearResult(res)
  close.my.connection(con)
  return(odloty)
}

load.moje.loty <- function(telefon) {
  if(trimws(telefon) != "") {
    query = paste0("SELECT imie, nazwisko, kraj, miasto, data_lotu, godzina_lotu, nr_stanowiska, nazwa, odlot
                   FROM loty JOIN lotnisko USING(id_lotniska) JOIN status USING(id_statusu)
                   JOIN bilet USING(id_lotu) JOIN pasazer USING(id_pasazera)
                   WHERE telefon = ",telefon,"")
    con = open.my.connection()
    res = dbSendQuery(con,query)
    moje.loty = dbFetch(res)
    dbClearResult(res)
    close.my.connection(con)
    return(moje.loty)
  }
}

