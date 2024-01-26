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

