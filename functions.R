library("RPostgres")

open.my.connection <- function() {
  con <- dbConnect(RPostgres::Postgres(),dbname = 'template1',
                   host = 'localhost',
                   port = 5434,
                   user = 'postgres',
                   password = '')
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
                   loty.godzina_lotu, loty.nr_stanowiska, st.nazwa AS status
                   FROM loty JOIN lotnisko lo USING(id_lotniska) JOIN status st USING(id_statusu)
                   JOIN bilet bi USING(id_lotu) JOIN pasazer pa USING(id_pasazera)
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
                   loty.godzina_lotu, loty.nr_stanowiska, st.nazwa AS status, loty.odlot
                   FROM loty JOIN lotnisko lo USING(id_lotniska) JOIN status st USING(id_statusu)
                   JOIN bilet bi USING(id_lotu) JOIN pasazer pa USING(id_pasazera)
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
  if(nazwa != 'Opóźniony'){
    query = paste0("UPDATE loty SET id_statusu = (SELECT s.id_statusu FROM status s WHERE s.nazwa='",nazwa,
                   "'), opoznienie = NULL WHERE id_lotu=",id_lotu)
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
    cat("Zmieniono status lotu ", id_lotu," na ",nazwa)
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
    query = paste0("DELETE FROM bilet WHERE id_biletu=",id)
    con = open.my.connection()
    res = dbSendQuery(con,query)
    dbClearResult(res)
    close.my.connection(con)
    cat("Usunięto bilet")
}

load.biletid.with.bagaz <- function(){
  query = "SELECT DISTINCT id_biletu FROM bagaz ORDER BY id_biletu"
  con = open.my.connection()
  res = dbSendQuery(con,query)
  bilety = dbFetch(res)
  dbClearResult(res)
  close.my.connection(con)
  return(bilety)
}

load.bagaz <- function(bilet){
  query = paste0("SELECT * FROM bagaz_pasazera WHERE id_biletu =",bilet)
  con = open.my.connection()
  res = dbSendQuery(con,query)
  bagaze = dbFetch(res)
  dbClearResult(res)
  close.my.connection(con)
  return(bagaze)
}

load.id.biletu <- function(){
  query = "SELECT id_biletu FROM bilet"
  con = open.my.connection()
  res = dbSendQuery(con,query)
  bilety = dbFetch(res)
  dbClearResult(res)
  close.my.connection(con)
  return(bilety)
}

load.rodzaj.bagazu <- function(){
  query = "SELECT nazwa FROM rodzaj_bagazu"
  con = open.my.connection()
  res = dbSendQuery(con,query)
  rodzaje = dbFetch(res)
  dbClearResult(res)
  close.my.connection(con)
  return(rodzaje)
}

get.id.bagazu.from.nazwa <- function(nazwa){
  query = paste0("SELECT id_rodzaju FROM rodzaj_bagazu WHERE nazwa='",nazwa,"'")
  con = open.my.connection()
  res = dbSendQuery(con,query)
  id = dbFetch(res)
  dbClearResult(res)
  close.my.connection(con)
  return(id)
}

add.bagaz <- function(id_biletu, rodzaj){
  id = get.id.bagazu.from.nazwa(rodzaj)
  query = paste0("INSERT INTO bagaz(id_rodzaju, id_biletu) VALUES (",id,",",id_biletu,")")
  con = open.my.connection()
  res = dbSendQuery(con,query)
  dbClearResult(res)
  close.my.connection(con)
  cat("Dodano bagaż")
}

load.bilety <- function(id){
  query = paste0("SELECT l.id_lotu, p.telefon, ltn.kraj, ltn.miasto, l.data_lotu, l.godzina_lotu FROM bilet
                 JOIN loty l USING(id_lotu)
                 JOIN lotnisko ltn USING(id_lotniska)
                 JOIN pasazer p USING(id_pasazera)
                 WHERE id_biletu=",id)
  con = open.my.connection()
  res = dbSendQuery(con,query)
  bilety = dbFetch(res)
  dbClearResult(res)
  close.my.connection(con)
  return(bilety)
}

load.samoloty.2 <- function() {
  query = "SELECT id_samolotu FROM samolot"
  con = open.my.connection()
  res = dbSendQuery(con,query)
  samoloty = dbFetch(res)
  dbClearResult(res)
  close.my.connection(con)
  return(append(samoloty, " - ", after = 0))
}

load.pilot <- function() {
  query = "SELECT id_pilota FROM pilot"
  con = open.my.connection()
  res = dbSendQuery(con,query)
  pilot = dbFetch(res)
  dbClearResult(res)
  close.my.connection(con)
  return(append(pilot, " - ", after = 0))
}

load.samoloty.3 <- function(id_samolotu) {
  query = paste0("SELECT * FROM samolot WHERE id_samolotu = ", id_samolotu)
  con = open.my.connection()
  res = dbSendQuery(con,query)
  samoloty = dbFetch(res)
  dbClearResult(res)
  close.my.connection(con)
  return(samoloty)
}

load.pilot.2 <- function(id_pilota) {
  query = paste0("SELECT * FROM pilot WHERE id_pilota = ", id_pilota)
  con = open.my.connection()
  res = dbSendQuery(con,query)
  pilot = dbFetch(res)
  dbClearResult(res)
  close.my.connection(con)
  return(pilot)
}

add.bagaz <- function(id_biletu, rodzaj){
  id = get.id.bagazu.from.nazwa(rodzaj)
  query = paste0("INSERT INTO bagaz(id_rodzaju, id_biletu) VALUES (",id,",",id_biletu,")")
  con = open.my.connection()
  res = dbSendQuery(con,query)
  dbClearResult(res)
  close.my.connection(con)
  cat("Dodano bagaż")
}

deactivate.function <- function(id, rodzaj) {
  if(rodzaj == 1){
    query = paste0("UPDATE pilot SET aktywny = FALSE WHERE id_pilota = ",id,"")
    con = open.my.connection()
    res = dbSendQuery(con,query)
    dbClearResult(res)
    close.my.connection(con)
    cat("Dezaktywowano pilota")
  }
  if(rodzaj == 2){
    query = paste0("UPDATE samolot SET aktywny = FALSE WHERE id_samolotu = ",id,"")
    con = open.my.connection()
    res = dbSendQuery(con,query)
    dbClearResult(res)
    close.my.connection(con)
    cat("Dezaktywowano samolot")
  }
}

activate.function <- function(id, rodzaj) {
  if(rodzaj == 1){
    query = paste0("UPDATE pilot SET aktywny = TRUE WHERE id_pilota = ",id,"")
    con = open.my.connection()
    res = dbSendQuery(con,query)
    dbClearResult(res)
    close.my.connection(con)
    cat("Dezaktywowano pilota")
  }
  if(rodzaj == 2){
    query = paste0("UPDATE samolot SET aktywny = TRUE WHERE id_samolotu = ",id,"")
    con = open.my.connection()
    res = dbSendQuery(con,query)
    dbClearResult(res)
    close.my.connection(con)
    cat("Dezaktywowano samolot")
  }
}
