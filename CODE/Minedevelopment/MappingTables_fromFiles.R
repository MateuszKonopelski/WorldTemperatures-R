#Import Mapping lists into data frames

#Wiki: ftp://ftp.ncdc.noaa.gov/pub/data/ghcn/daily/readme.txt


MapTimeStart <- Sys.time()
#----------------------------------------------------------------
#Station maps
Map_Stations_File <- "~/Documents/RDirectories/Temperature_Data/Data/MappingTables/ghcnd-stations.txt"
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

#clean memory
rm(ColWidths, ColChar, ColNum, Map_Stations_File)





#----------------------------------------------------------------
#Countries maps
Map_Countries_File <- "~/Documents/RDirectories/Temperature_Data/Data/MappingTables/ghcnd-countries.txt"
ColWidths = c(3, 47)

Map_Countries <- read.fwf(Map_Countries_File, widths = ColWidths,
                         header = FALSE, strip.white = TRUE, comment.char = "",
                         stringsAsFactors = FALSE)

colnames(Map_Countries) <- c("CODE","NAME") 
Map_Countries[1:2] <-lapply(Map_Countries[1:2], as.character) 

#clean memory
rm(ColWidths, Map_Countries_File)




#----------------------------------------------------------------
#States maps
Map_States_File <- "~/Documents/RDirectories/Temperature_Data/Data/MappingTables/ghcnd-states.txt"
ColWidths = c(3, 47)

Map_States <- read.fwf(Map_States_File, widths = ColWidths,
                          header = FALSE, strip.white = TRUE, comment.char = "",
                          stringsAsFactors = FALSE)

colnames(Map_States) <- c("CODE","NAME") 
Map_States[1:2] <-lapply(Map_States[1:2], as.character) 

#clean memory
rm(ColWidths, Map_States_File)



#----------------------------------------------------------------
#Inventory maps
Map_Inventory_File <- "~/Documents/RDirectories/Temperature_Data/Data/MappingTables/ghcnd-inventory.txt"
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

#Tiemof execution
MapTimeEnd <- Sys.time()
MapTimeExec <- MapTimeEnd - MapTimeStart


#clean memory
rm(ColWidths, ColChar, ColNum, ColInt,  Map_Inventory_File, MapTimeStart, MapTimeEnd)
