# ----------------------------------------
# --      PROGRAM server_global.R       --
# ----------------------------------------
# USE: Server-specific variables and
#      functions for the main reactive
#      shiny server functionality.  All
#      code in this file will be put into
#      the framework outside the call to
#      shinyServer(function(input, output, session)
#      in server.R
#
# NOTEs:
#   - All variables/functions here are
#     SERVER scoped and are available
#     across all user sessions, but not to
#     the UI.
#
#   - For user session-scoped items
#     put var/fxns in server_local.R
#
# FRAMEWORK VARIABLES
#     none
# ----------------------------------------

# -- IMPORTS --
library(googlesheets4)
library(dplyr)
library(leaflet)

summary_sheet <- "https://docs.google.com/spreadsheets/d/1wQVypefm946ch4XDp37uZ-wartW4V7ILdg-qYiDXUHM/htmlview?usp=sharing&sle=true"
cases_sheet   <- "https://docs.google.com/spreadsheets/d/1UF2pSkFTURko2OvfHWWlFpDFAr1UxCBA4JLwlSP6KFo/htmlview?usp=sharing&sle=true#"

# -- VARIABLES --

get_filtered_data <- function(tab_name) {
    data <- suppressMessages(googlesheets4::sheets_read(cases_sheet, sheet = tab_name)) %>% 
        select(c(1,2,4,5, tail(names(.), 1)))
    colnames(data) <- c("Province", "Country", "Lat", "Lon", tab_name)
    data
}

#all_cases       <- googlesheets4::sheets_read(summary_sheet)
# confirmed_cases <- get_filtered_data("Confirmed")
# recovered_cases <- get_filtered_data("Recovered")
# death_cases     <- get_filtered_data("Death")
# 
# data <- confirmed_cases %>%
#     left_join(recovered_cases) %>%
#     left_join(death_cases)

data <- readRDS("program/data/data.rds")

# -- FUNCTIONS --


