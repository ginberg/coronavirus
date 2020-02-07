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
library(dplyr)
library(leaflet)
library(canvasXpress)
library(glue)
library(renv)
library(plyr)

# -- Setup your Application --
set_app_parameters(title = "2019-nCoV Global Cases",
                   loglevel = "DEBUG",
                   showlog = FALSE,
                   app_version = "1.0.0")
# -- PROGRAM --
