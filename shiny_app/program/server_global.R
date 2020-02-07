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

# -- VARIABLES --

#summary_sheet <- "https://docs.google.com/spreadsheets/d/1wQVypefm946ch4XDp37uZ-wartW4V7ILdg-qYiDXUHM/htmlview?usp=sharing&sle=true"
cases_sheet <- "https://docs.google.com/spreadsheets/d/1UF2pSkFTURko2OvfHWWlFpDFAr1UxCBA4JLwlSP6KFo/htmlview?usp=sharing&sle=true#"
confirmed   <- "Confirmed"
recovered   <- "Recovered"
death       <- "Death"
tabs        <- c(confirmed, recovered, death)

# -- FUNCTIONS --

get_all_data <- function(sheet, tab_name) {
    suppressMessages(googlesheets4::sheets_read(cases_sheet, sheet = tab_name))
}

get_map_data <- function(data, tab_name) {
    data <- data %>% 
        select(c(1,2,4,5, tail(names(.), 1)))
    colnames(data) <- c("Province", "Country", "Lat", "Lon", tab_name)
    data
}

get_line_data <- function(data, tab_name) {
    data %>% select(-c(3,4,5)) %>% summarise_if(is.numeric, sum, na.rm = TRUE) %>%
        mutate(Type = tab_name)
}

# confirmed_data  <- get_all_data(cases_sheet, confirmed)
# recovered_data  <- get_all_data(cases_sheet, recovered)
# death_data      <- get_all_data(cases_sheet, death)
# 
# confirmed_cases <- get_map_data(confirmed_data, confirmed)
# recovered_cases <- get_map_data(recovered_data, recovered)
# death_cases     <- get_map_data(death_data, death)

# map_data <- confirmed_cases %>%
#     left_join(recovered_cases) %>%
#     left_join(death_cases)

# line_data <- rbind.fill(get_line_data(confirmed_data, confirmed),
#                         get_line_data(recovered_data, recovered),
#                         get_line_data(death_data, death)) %>% tibble::column_to_rownames("Type")

map_data  <- readRDS("program/data/map_data.rds")
line_data <- readRDS("program/data/line_data.rds")


