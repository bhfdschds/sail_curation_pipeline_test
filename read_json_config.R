library(jsonlite)
library(DBI)
library(dbplyr)
library(odbc)

# Load configuration from a JSON file
config <- fromJSON("config.json")

# Extract database info
db_cfg <- config$database

# Connect to the database using dbplyr
con <- dbConnect(
  drv = odbc::odbc(),
  Driver = db_cfg$connection$driver,
  Hostname = db_cfg$host,
  Port = db_cfg$port,
  Database = db_cfg$database_name,
  UID = Sys.getenv(substr(db_cfg$connection$uid, 3, nchar(db_cfg$connection$uid) - 1)),
  PWD = Sys.getenv(substr(db_cfg$connection$pwd, 3, nchar(db_cfg$connection$pwd) - 1)),
  Schema = db_cfg$schema
)

# Helper to get a tbl for an asset
get_asset_tbl <- function(asset_name) {
  asset <- config$assets[[asset_name]]
  src_name <- asset$default_source
  source_info <- asset$sources[[src_name]]
  tbl(con, source_info$table_name)
}

# Example usage:
# dob_tbl <- get_asset_tbl("date_of_birth")
# sex_tbl <- get_asset_tbl("sex")
