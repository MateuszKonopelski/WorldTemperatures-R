#Import Mapping lists into data frames

#Wiki: ftp://ftp.ncdc.noaa.gov/pub/data/ghcn/daily/readme.txt


MapTimeStart <- Sys.time()
setwd("~/Documents/PROJECTS/Temperature_Data/Data/MappingTables")
downloadURL <- "ftp://ftp.ncdc.noaa.gov/pub/data/ghcn/daily/"

#----------------------------------------------------------------
#Station maps
Map_Stations_File <- "ghcnd-stations.txt"
download.file(paste(downloadURL,Map_Stations_File, sep=""), Map_Stations_File)

ColWidths = c(11, 9, 10, 7, 4, 31, 4, 4, 5)

Map_Stations <- read.fwf(Map_Stations_File, widths = ColWidths,
                         header = FALSE, strip.white = TRUE, comment.char = "",
                         stringsAsFactors = FALSE)

colnames(Map_Stations) <- c("ID","LATITUDE", "LONGITUDE", "ELEVATION", "STATE","NAME"
                    ,"GSN_FLAG","HCN/CRN_FLAG","WMO_ID") 
ColChar <-c("ID","STATE","NAME","GSN_FLAG","HCN/CRN_FLAG","WMO_ID")
ColNum <- c("LATITUDE","LONGITUDE","ELEVATION")
Map_Stations[ColChar] <-lapply(Map_Stations[ColChar], as.character) 
Map_Stations[ColNum] <-lapply(Map_Stations[ColNum], as.numeric) 



#----------------------------------------------------------------
#Countries maps
Map_Countries_File <- "ghcnd-countries.txt"
download.file(paste(downloadURL,Map_Countries_File, sep=""), Map_Countries_File)


ColWidths = c(3, 47)

Map_Countries <- read.fwf(Map_Countries_File, widths = ColWidths,
                         header = FALSE, strip.white = TRUE, comment.char = "",
                         stringsAsFactors = FALSE)

colnames(Map_Countries) <- c("CODE","NAME") 
Map_Countries[1:2] <-lapply(Map_Countries[1:2], as.character) 



#----------------------------------------------------------------
#States maps
Map_States_File <- "ghcnd-states.txt"
download.file(paste(downloadURL,Map_States_File, sep=""), Map_States_File)

ColWidths = c(3, 47)

Map_States <- read.fwf(Map_States_File, widths = ColWidths,
                          header = FALSE, strip.white = TRUE, comment.char = "",
                          stringsAsFactors = FALSE)

colnames(Map_States) <- c("CODE","NAME") 
Map_States[1:2] <-lapply(Map_States[1:2], as.character) 


#----------------------------------------------------------------
#Inventory maps
Map_Inventory_File <- "ghcnd-inventory.txt"
download.file(paste(downloadURL,Map_Inventory_File, sep=""), Map_Inventory_File)

ColWidths = c(11, 9, 10, 5, 5, 5)

Map_Inventory<- read.fwf(Map_Inventory_File, widths = ColWidths,
                         header = FALSE, strip.white = TRUE, comment.char = "",
                         stringsAsFactors = FALSE)

colnames(Map_Inventory) <- c("ID","LATITUDE", "LONGITUDE", "ELEMENT", "FIRSTYEAR","LASTYEAR")
ColChar <-c("ID","ELEMENT")
ColNum  <-c("LATITUDE","LONGITUDE")
ColInt  <-c("FIRSTYEAR","LASTYEAR")
Map_Inventory[ColChar] <-lapply(Map_Inventory[ColChar], as.character) 
Map_Inventory[ColNum] <-lapply(Map_Inventory[ColNum], as.numeric) 
Map_Inventory[ColInt] <-lapply(Map_Inventory[ColInt], as.integer) 






#----------------------------------------------------------------
#Create a SQL Lite db and copy the mappings into 4 separate tables


if (file.exists("ghcnd-mapping.sqlite") == TRUE) {file.remove("ghcnd-mapping.sqlite") == TRUE}
db <- dbConnect(SQLite(),dbname = "ghcnd-mapping.sqlite")
dbWriteTable(conn = db, name = "Map_Stations", value = Map_Stations, row.names = FALSE)
dbWriteTable(conn = db, name = "Map_Countries", value = Map_Stations, row.names = FALSE)
dbWriteTable(conn = db, name = "Map_States", value = Map_Stations, row.names = FALSE)
dbWriteTable(conn = db, name = "Map_Inventory", value = Map_Stations, row.names = FALSE)


#Tiemof execution
MapTimeEnd <- Sys.time()
MapTimeExec <- MapTimeEnd - MapTimeStart
if (file.exists("ExecTime_ghcnd-mapping.txt") == TRUE) {file.remove("ExecTime_ghcnd-mapping.txt") == TRUE}
write(MapTimeExec, file = "ExecTime_ghcnd-mapping.txt")




#----------------------------------------------------------------
#Clean the environment and folder

Map_List <- c(Map_Stations_File, Map_Countries_File, Map_States_File, Map_Inventory_File)

for (file in Map_List) {
    if (file.exists(file) == TRUE) {file.remove(file) == TRUE}
}

rm(list=ls())




