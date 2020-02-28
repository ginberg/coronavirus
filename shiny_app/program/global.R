# ----------------------------------------
# --          PROGRAM global.R          --
# ----------------------------------------
# USE: Global variables and functions
#
# NOTEs:
#   - All variables/functions here are
#     globally scoped and will be available
#     to server, UI and session scopes
# ----------------------------------------

# -- IMPORTS --
library(plyr)
library(dplyr)
library(leaflet)
library(canvasXpress)
library(glue)

g_live_data <- TRUE
g_refresh_period <- 6*60*60*1000
g_all_option <- "All"
g_confirmed  <- "Confirmed"
g_recovered  <- "Recovered"
g_death      <- "Death"
g_tabs       <- c(g_confirmed, g_recovered, g_death)

source(paste("program", "fxn", "supporting_data.R", sep = .Platform$file.sep))
source(paste("program", "fxn", "supporting_plots.R", sep = .Platform$file.sep))
source(paste("program", "fxn", "supporting_misc.R", sep = .Platform$file.sep))

# -- Setup your Application --
set_app_parameters(title = "Covid-19 Global Cases",
                   loglevel = "DEBUG",
                   showlog = FALSE,
                   app_version = "1.0.0")
# -- PROGRAM --

g_map_data      <- get_map_data()
line_data       <- get_line_data()
g_line_data     <- line_data[[1]]
g_all_line_data <- line_data[[2]]
rm(line_data)

g_colors    <- c("orange", "red", "green")
shinyOptions(plot.autocolors = TRUE)

