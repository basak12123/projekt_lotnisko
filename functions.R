library("RPostgres")

open.my.connection <- function() {
  con <- dbConnect(RPostgres::Postgres(),dbname = 'projekt_lotnisko', # nazwa naszej projektowej bazy
                   host = 'localhost',
                   port = 5432, # port ten sam co w psql - zwykle 5432
                   user = 'starling', # nasza nazwa użytkownika psql
                   password = 'pokora2002') # i nasze hasło tego użytkownika
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

load.full.lotniska <- function() {
  query = "SELECT * FROM lotnisko"
  con = open.my.connection()
  res = dbSendQuery(con,query)
  lotniska = dbFetch(res)
  dbClearResult(res)
  close.my.connection(con)
  lotniska = apply(lotniska, 1, function(lotnisko){
    paste0(lotnisko[1],", ",lotnisko[2],", ",lotnisko[3])
  }, simplify = FALSE)
  return(lotniska)
}
as.numeric(unlist(strsplit(unlist(load.full.lotniska()[1]), ","))[1])

load.samoloty <- function() {
  query = "SELECT id_samolotu FROM samolot"
  con = open.my.connection()
  res = dbSendQuery(con,query)
  samoloty = dbFetch(res)
  dbClearResult(res)
  close.my.connection(con)
  return(samoloty)
}

load.piloci <- function() {
  query = "SELECT id_pilota FROM pilot"
  con = open.my.connection()
  res = dbSendQuery(con,query)
  piloci = dbFetch(res)
  dbClearResult(res)
  close.my.connection(con)
  return(piloci)
}

add.lot <- function(data, godzina, lotnisko, nr_stanowiska, id_samolotu, id_pilot, odlot) {
  id_lotniska = as.numeric(unlist(strsplit(unlist(lotnisko), ","))[1])
    query = paste0("INSERT INTO loty(data_lotu, godzina_lotu, id_lotniska, nr_stanowiska, id_samolotu, id_pilot_1, odlot, id_statusu)
                   VALUES ('",data,"', '",godzina,"', ",id_lotniska,", ",nr_stanowiska,", ",id_samolotu,", ",id_pilot,", ",
                   odlot,", 1)")
    con = open.my.connection()
    res = dbSendQuery(con,query)
    dbClearResult(res)
    close.my.connection(con)
    cat("Dodano lot")
}

load.numery.telefonu <- function(){
  query = "SELECT telefon FROM pasazer"
  con = open.my.connection()
  res = dbSendQuery(con,query)
  numery = dbFetch(res)
  dbClearResult(res)
  close.my.connection(con)
  return(numery)
}

load.loty <- function(data, odlot){
  if(odlot == 'Odlot') {
    odlot <- TRUE
  }else{
    odlot <- FALSE
  }
  query = paste0("SELECT id_lotu, godzina_lotu, kraj, miasto FROM loty
    JOIN lotnisko USING(id_lotniska)
    WHERE odlot = ",odlot," AND data_lotu = '",data,"'")
  con = open.my.connection()
  res = dbSendQuery(con,query)
  loty = dbFetch(res)
  dbClearResult(res)
  close.my.connection(con)
  loty = apply(loty, 1, function(lot){
    paste0(lot[1],", ",lot[2],", ",lot[3],", ",lot[4])
  })
  return(loty)
}

id.pasazera.from.telefon <- function(telefon){
  query = paste0("SELECT id_pasazera FROM pasazer WHERE telefon=",telefon)
  con = open.my.connection()
  res = dbSendQuery(con,query)
  id = dbFetch(res)
  dbClearResult(res)
  close.my.connection(con)
  return(id)
}

add.bilet <- function(telefon, lot) {
  id_lotu = as.numeric(unlist(strsplit(unlist(lot), ","))[1])
  id_pasazera = id.pasazera.from.telefon(telefon)
  query = paste0("INSERT INTO bilet(id_pasazera, id_lotu) VALUES (",id_pasazera,", ",id_lotu,")")
  con = open.my.connection()
  res = dbSendQuery(con,query)
  dbClearResult(res)
  close.my.connection(con)
  cat("Dodano bilet")
}

delete.bilet <- function(id) {
  if(trimws(id) != "") {
    query = paste0("DELETE FROM bilet WHERE id_biletu=",id)
    con = open.my.connection()
    res = dbSendQuery(con,query)
    dbClearResult(res)
    close.my.connection(con)
    cat("Usunięto bilet")
  }
}
