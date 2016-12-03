
################################################################################
################################################################################

#R_Export_toSQL
require(RSQLite)
require(sqldf)

setwd("~/Documents/PROJECTS/Temperature_Data/Data/Test_ghcnd_all/100")

db <- dbConnect(SQLite(),dbname = "gcnd_all_100.sqlite")

#dbRemoveTable(db, "ghcn")
dbWriteTable(conn = db, name = "ghcn", value = Data, row.names = FALSE)

TimeEnd <- Sys.time()

Method2_TimeExec <- TimeEnd - TimeStart
rm("TimeStart","TimeEnd")
Method2_TimeExec
