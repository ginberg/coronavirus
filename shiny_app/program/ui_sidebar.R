# ----------------------------------------
# --       PROGRAM ui_sidebar.R         --
# ----------------------------------------
# USE: Create UI elements for the
#      application sidebar (left side on
#      the desktop; contains options) and
#      ATTACH them to the UI by calling
#      add_ui_sidebar_basic() or
#      add_ui_sidebar_advanced()
#
# NOTEs:
#   - All variables/functions here are
#     not available to the UI or Server
#     scopes - this is isolated
# ----------------------------------------

# -- IMPORTS --



# ----------------------------------------
# --     SIDEBAR ELEMENT CREATION       --
# ----------------------------------------

# -- Create Basic Elements
totals_text <- div(style = "padding-top: 5px;", uiOutput("total_stats"))

last_update_text <- div(style = "padding-top: 90%;", uiOutput("last_update"))

# -- Register Basic Elements in the ORDER SHOWN in the UI
add_ui_sidebar_basic(list(totals_text, last_update_text), append = FALSE, tabname = "Totals")


# -- Create Advanced Elements
country_select <- selectizeInput("countrySel",
                                 label    = ui_tooltip('countryTooltip', "Country", "Select a country"),
                                 choices  = NULL,
                                 multiple = FALSE,
                                 width    = "100%")

country_text <- div(style = "padding-top: 5px;",
                    uiOutput("country_stats"))


# -- Register Advanced Elements in the ORDER SHOWN in the UI
add_ui_sidebar_advanced(list(country_select, country_text), append = FALSE, tabname = "Per Country")
