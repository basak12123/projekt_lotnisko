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
  query =  paste0("SELECT w.id_lotu, w.kraj, w.miasto, w.data_lotu, w.godzina_lotu, s.nazwa AS status, l.opoznienie, w.wolne_miejsca
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
  query = paste0("SELECT w.id_lotu, w.kraj, w.miasto, w.data_lotu, w.godzina_lotu, s.nazwa AS status, l.opoznienie, w.wolne_miejsca
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
                   loty.godzina_lotu, loty.nr_stanowiska, st.nazwa AS status, loty.odlot, rb.nazwa AS rodzaj_bagażu
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

load.moje.loty.2 <- function(telefon) {
  if(trimws(telefon) != "") {
    query = paste0("SELECT pa.imie, pa.nazwisko, pa.telefon, lo.kraj, lo.miasto, loty.data_lotu,
                   loty.godzina_lotu, loty.nr_stanowiska, st.nazwa AS status, loty.odlot, rb.nazwa AS rodzaj_bagażu
                   FROM loty JOIN lotnisko lo USING(id_lotniska) JOIN status st USING(id_statusu)
                   JOIN bilet bi USING(id_lotu) JOIN pasazer pa USING(id_pasazera)
                   JOIN bagaz ba USING(id_biletu) JOIN rodzaj_bagazu rb USING(id_rodzaju)
                   WHERE pa.telefon = ",telefon,"")
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

load.status <- function() {
  query = "SELECT DISTINCT nazwa FROM status"
  con = open.my.connection()
  res = dbSendQuery(con,query)
  status = dbFetch(res)
  dbClearResult(res)
  close.my.connection(con)
  return(status)
}

load.id.lotu <- function() {
  query = "SELECT id_lotu FROM loty ORDER BY id_lotu"
  con = open.my.connection()
  res = dbSendQuery(con,query)
  id_lotu = dbFetch(res)
  dbClearResult(res)
  close.my.connection(con)
  return(id_lotu)
}

load.status.tab <- function(id_lotu) {
  query = paste0("SELECT lo.kraj, lo.miasto, l.data_lotu, l.godzina_lotu, s.nazwa AS status, l.opoznienie
                 FROM loty l JOIN lotnisko lo USING(id_lotniska) JOIN status s USING(id_statusu)
                 WHERE l.id_lotu = ",id_lotu,"")
  con = open.my.connection()
  res = dbSendQuery(con,query)
  id_lotu = dbFetch(res)
  dbClearResult(res)
  close.my.connection(con)
  return(id_lotu)
}

update.status <- function(id_lotu, nazwa, opoznienie) {
  if(opoznienie == "" && nazwa != 'Opóźniony'){
    query = paste0("UPDATE loty SET id_statusu = (SELECT s.id_statusu FROM status s WHERE s.nazwa='",nazwa,
                   "') WHERE id_lotu=",id_lotu)
    con = open.my.connection()
    res = dbSendQuery(con,query)
    dbClearResult(res)
    close.my.connection(con)
    cat("Zmieniono status lotu ", id_lotu," na ",nazwa)
  } else if(nazwa == 'Opóźniony'){
    query = paste0("UPDATE loty SET id_statusu = (SELECT s.id_statusu FROM status s  WHERE s.nazwa='",nazwa,
                   "'), opoznienie ='",opoznienie,"' WHERE id_lotu=",id_lotu)
    con = open.my.connection()
    res = dbSendQuery(con,query)
    dbClearResult(res)
    close.my.connection(con)
    cat("Zmieniono status lotu ", id_lotu," na ",nazwa, " (opoznienie = ", opoznienie, " )")
  }
}

