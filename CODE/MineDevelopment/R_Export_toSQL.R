
################################################################################
################################################################################

#R_Export_toSQL
require(RSQLite)
require(sqldf)

#set directory
setwd("~/Documents/PROJECTS/Temperature_Data/Data/Test_ghcnd_all/100")

#check if db exists, fi yes, delete
if (file.exists("gcnd_all_100.sqlite") == TRUE) {file.remove("gcnd_all_100.sqlite") == TRUE}

#Create new SQLite db
db <- dbConnect(SQLite(),dbname = "gcnd_all_100.sqlite")

#check if ghcn in db exists, if yes, delete.
if (dbExistsTable(db, name = "ghcn") == TRUE) {dbRemoveTable(db, "ghcn")}

#write into db, table ghcn from Data table
dbWriteTable(conn = db, name = "ghcn", value = Data, row.names = FALSE)


#check time of execution
TimeEnd <- Sys.time()
Method2_TimeExec <- TimeEnd - TimeStart

if (file.exists("ExecTime_gcnd_all_100.txt") == TRUE) {file.remove("ExecTime_gcnd_all_100.txt") == TRUE}
write(Method2_TimeExec, file = "ExecTime_gcnd_all_100.txt")



#Clear Global Environment
rm(list=ls())
