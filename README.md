# WorldTemperatures
Analysis &amp; models on world temperatures data sets

Data Set:
ftp://ftp.ncdc.noaa.gov/pub/data/ghcn/daily/

Data set Summary:

* Around 100k flat files, each from one methological station
* Each file contains different metrics (Temperature max, min, avg, etc) per day 



Process devided into steps (all in /CODE/MineDevelopment/):

1. Import data from all files (ImportData.R)
2. Clean the data (CleanData.R)
3. Analysis


#Development in progress.

Existing challanges:

  1. Speed time of data import and not sufficient memory to import the whole data set into data tables/SQl tables:
      Existing performance: 1,670 files -> 12,6M rows in 1 hour
  2. Build  a live connection to FTP folder that puls only new files
  
