################################################################################
################################################################################
#R_Import

require(readr)
require(data.table)

setwd("~/Documents/RDirectories/Temperature_Data/Data/Test_ghcnd_all/100")

#ExecTime
TimeStart <- Sys.time()

#Prepare data
ColWidths <- c(11,4,2,4,rep(c(5,1,1,1),31))
DAYS <- lapply(seq(from=5, to=4 + 4*31, by=4), function(i) i:(i+3))

#Import .dly to DataFrame
if (exists("Data_Raw") && is.data.frame(get("Data_Raw"))==TRUE)  {remove(Data_Raw)}

dailies <- list.files(pattern="*.dly")
count <- 1
system.time(
  
  for (file in dailies) {
    
    #check if Data frame exists
    if(!exists("Data_Raw")) {  #If it doesn't
      Data_Raw <- read_fwf(file, fwf_widths(ColWidths))
    }  else { #If does
      temp_Data <- read_fwf(file, fwf_widths(ColWidths))
      
      Data_Raw <- rbind(Data_Raw, temp_Data)
      
      count <- count + 1
      rm(temp_Data)
      
    } #close if exist
    
  } #close for i loop
  
) # close after system time

TimeEnd <- Sys.time()

Method2_TimeExec <- TimeEnd - TimeStart
rm("TimeStart","TimeEnd")
#Method2_TimeExec

