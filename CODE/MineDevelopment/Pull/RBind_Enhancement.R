#First import all .dly files from dir into dataframe using read_fwf and rbind

require(readr)
require(data.table)

setwd("~/Documents/PROJECTS/Temperature_Data/Data/Test_ghcnd_all/100")

#Prepare data
ColWidths <- c(11,4,2,4,rep(c(5,1,1,1),31))

#Import .dly to DataFrame
if (exists("Data_Raw") && is.data.frame(get("Data_Raw"))==TRUE)  {remove(Data_Raw)}

dailies <- list.files(pattern="*.dly")
count <- 1
  
for (file in dailies) {
    
    #check if Data frame exists
    if(!exists("Data_Raw")) {  #If it doesn't
      Data_Raw <- read_fwf(file, fwf_widths(ColWidths))
    }  else { #If does
      temp_Data <- read_fwf(file, fwf_widths(ColWidths))
      
      Data_Raw <- rbindlist(list(Data_Raw, temp_Data))      
      count <- count + 1
      rm(temp_Data)
      
    } #close if exist
    
  } #close for i loop
  
  
 #Second Transponse the columns into rows
  
  wideToLong <- function(dat, days) {
  # convert id vars to long form, relying on R to recycle the first
  # four to match the length of the fifth (slightly faster than doing
  # this manually)
  out <- data.frame(
    dat[1:4],
    V5=rep(1:31, each=nrow(dat))
  )
  # now combine and fill in the daily values/flags
  for (i in 1:4) {
    cols <- sapply(days, function(x) x[[i]])
    out[[5+i]] <- as.vector(as.matrix(dat[, cols]))
  }
  # add original row id
  out$id <- 1:nrow(dat)
  out
}

DAYS <- lapply(seq(from=5, to=4 + 4*31, by=4), function(i) i:(i+3))

#Apply function to Data_Raw table
Data <- wideToLong(Data_Raw, DAYS)
