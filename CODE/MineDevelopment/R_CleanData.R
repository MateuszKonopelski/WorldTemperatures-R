################################################################################
################################################################################

#R_CleanData

#setwd("~/Documents/PROJECTS/Temperature_Data/Data/Test_ghcnd_all/100")

# function to convert the wide-form (days across columns) GHCN data into
# long form (unique row for each day*element); note that all indexing
# here is hard-coded to work for the *.dly files, and simply assumes
# that they are all consistent
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

#Apply function to Data data frame
Data <- wideToLong(Data_Raw, DAYS)

#Clean Data Types and names
#transform(Data, V5 = as.integer(V5)) #Transfrom V5 to integer 
Data["V5"] <- lapply(Data["V5"], as.integer)
Data[c("V6","V7","V8","V9")] <-lapply(Data[c("V6","V7","V8","V9")], as.factor) #Transorm other to factor

#Change the order of columns
Data <- Data[c(10,1,2,3,5,4,7,8,9,6)]

#Set the names of the columns
colnames(Data) <- c("ID","STATION", "Year", "Month", "Day","Observation"
                    ,"Measurement_Flag","Quality_Flag","Source_Flag","Value")



#Clean Memory
for (variable in c("col_to_factor", "ColNames", file, "dailies", "DAYS", "temp_Data")) {
  if (exists(variable)== TRUE) {rm(variable)}
}


source("~/Documents/PROJECTS/Temperature_Data/Code/R_Export_toSQL.R")
