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
library(googlesheets4)
library(plyr)
library(dplyr)
library(leaflet)
library(canvasXpress)
library(glue)
library(renv)

g_live_data <- TRUE
options(gargle_oauth_email = "g.inberg@gmail.com")
g_refresh_period <- 6*60*60*1000

source(paste("program", "fxn", "supporting_data.R", sep = .Platform$file.sep))
source(paste("program", "fxn", "supporting_plots.R", sep = .Platform$file.sep))
source(paste("program", "fxn", "supporting_misc.R", sep = .Platform$file.sep))

# -- Setup your Application --
set_app_parameters(title = "2019-nCoV Global Cases",
                   loglevel = "DEBUG",
                   showlog = FALSE,
                   app_version = "1.0.0")
# -- PROGRAM --

g_map_data  <- get_map_data()
g_line_data <- get_line_data()

g_colors    <- c("orange", "red", "green")
shinyOptions(plot.autocolors = TRUE)

