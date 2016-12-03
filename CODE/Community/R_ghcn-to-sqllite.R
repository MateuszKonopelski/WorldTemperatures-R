#code found on: 
#It generates error on: loadAsCSV function in column definition



# R script for batch parsing and loading GHCN daily station files
# (*.dly) into a SQLite database. Script will process all such files in
# the current working directory.
#
# As written, the script is intended to create and populate the database
# from scratch, reporting an error if it already exists. In principle
# though, the code that processes and loads a given *.dly file could be
# run on its own to load additional data into an already existing
# database file.
#
# At the moment, only TMIN and TMAX are loaded, but that can easily be
# changed.
#
# Jim Regetz
# NCEAS
# Created on 09-May-2012

setwd("~/Documents/RDirectories/Temperature_Data/Data/Test_ghcnd_all")

require(RSQLite)

#-------------#
# "constants" #
#-------------#

# name of target db
db.path <- "ghcn_all.db"

# variables to keep
VARS <- c("TMIN", "TMAX")

# column characteristics of the *.dly data files
DLY.COLS <- c("character", "integer", "integer", "character",
    rep(c("numeric", "character", "character", "character"), times=31))
NUM.WIDE.COLS <- 4 + 4*31
DAYS <- lapply(seq(from=5, to=NUM.WIDE.COLS, by=4), function(i) i:(i+3))


#------------------#
# helper functions #
#------------------#

# bulk insert helper function (adapted from RSQLite documentation)
ghcn_bulk_insert <- function(db, sql, dat) {
    dbBeginTransaction(db)
    dbGetPreparedQuery(db, sql, bind.data = dat)
    dbCommit(db)
}

# shell out to OS to leverage grep/awk/tr for faster initial parsing and
# filtering of data into a temp file; if filtering yields no data
# records, this function returns NULL
loadAsCSV <- function(dly, patt=NULL) {
    tmpfile <- tempfile()
    awk <- paste(
        "awk -v FIELDWIDTHS='",
        paste(c(11, 4, 2, 4, rep(c(5,1,1,1), times=31)), collapse=" "),
        "' -v OFS=',' '{ $1=$1 \"\"; print }'", sep="")
    tr <- "tr -d ' '"
    if (is.null(patt)) {
        cmd <- paste(awk, dly, "|", tr)
    } else {
        patt <- shQuote(paste(patt, collapse="\\|"))
        cmd <- paste("grep -e", patt, dly, "|", awk, "|", tr)
    }
    cmd <- paste(cmd, tmpfile, sep=" > ")
    # execute command and read from tmpfile if successful
    if (system(cmd)==0 & 0<file.info(tmpfile)$size) {
        out <- read.csv(tmpfile, header=FALSE, colClasses=DLY.COLS)
        file.remove(tmpfile)
    } else {
        out <- NULL
    }
    return(out)
}

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


#-----------------#
# procedural code #
#-----------------#

# establish database connection
con <- dbDriver("SQLite")
if (file.exists(db.path)) {
    stop("database already exists at ", db.path)
}
db <- dbConnect(con, dbname=db.path)

# create main ghcn table
sql <- "
    CREATE TABLE ghcn (
        id text,
        year int,
        month int,
        element text,
        day int,
        value int,
        mflag text,
        qflag text,
        sflag text,
        srcrowid int)
"
dbGetQuery(db, sql)

# prepare sql insert statement
params.clist <- paste(rep("?", length(dbListFields(db, "ghcn"))),
    collapse=", ")
sql <- paste("insert into ghcn values (", params.clist, ")", sep="")

# process and insert daily data
dailies <- list.files(pattern="*.dly")
for (file in dailies) {
    dly <- loadAsCSV(file, VARS)
    if (!is.null(dly)) {
        long <- wideToLong(dly, DAYS)
        ghcn_bulk_insert(db, sql, long)
    } else {
        message("no rows imported for ", file)
    }
}
