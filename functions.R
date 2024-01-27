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

load.moje.loty <- function(id_biletu) {
  if(trimws(id_biletu) != "") {
    query = paste0("SELECT pa.imie, pa.nazwisko, pa.telefon, lo.kraj, lo.miasto, loty.data_lotu,
                   loty.godzina_lotu, loty.nr_stanowiska, st.nazwa, loty.odlot, rb.nazwa AS rodzaj_bagażu
                   FROM loty JOIN lotnisko lo USING(id_lotniska) JOIN status st USING(id_statusu)
                   JOIN bilet bi USING(id_lotu) JOIN pasazer pa USING(id_pasazera)
                   JOIN bagaz ba USING(id_biletu) JOIN rodzaj_bagazu rb USING(id_rodzaju)
                   WHERE bi.id_biletu = ",id_biletu,"")
    con = open.my.connection()
    res = dbSendQuery(con,query)
    moje.loty = dbFetch(res)
    dbClearResult(res)
    close.my.connection(con)
    return(moje.loty)
  }
}

add.pasazer <- function(imie, nazwisko, telefon) {
  if(trimws(imie)!="" && trimws(nazwisko)!="" && trimws(telefon)!="" && nchar(as.character(telefon)) == 9){
    query = paste0("INSERT INTO pasazer(imie, nazwisko, telefon) VALUES ('",imie,"', '",nazwisko,"', ",telefon,")")
    con = open.my.connection()
    res = dbSendQuery(con,query)
    komunikat = paste("Dodano użytkownika:", imie, nazwisko, telefon)
    dbClearResult(res)
    close.my.connection(con)
    cat(komunikat)
  }}

