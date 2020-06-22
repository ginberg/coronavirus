# ----------------------------------------
# --          PROGRAM ui_body.R         --
# ----------------------------------------
# USE: Create UI elements for the
#      application body (right side on the
#      desktop; contains output) and
#      ATTACH them to the UI by calling
#      add_ui_body()
#
# NOTEs:
#   - All variables/functions here are
#     not available to the UI or Server
#     scopes - this is isolated
# ----------------------------------------

# -- IMPORTS --


# ----------------------------------------
# --      BODY ELEMENT CREATION         --
# ----------------------------------------

# -- Create Elements

body1 <- shinydashboard::box(id     = "bodyElement1",
                             title  = "Data per region",
                             width  = 12,
                             status = "primary",
                             collapsible = TRUE,
                             collapsed   = TRUE,
                             tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "css/custom.css")),
                             downloadableTableUI("coronaDT",
                                                  list("csv", "tsv"),
                                                  "Download table data"))

timePanel    <- tabPanel("Cases over Time",
                         fluidRow(column(width = 6, canvasXpressOutput("chart_new_cases", height = "670px")),
                                  column(width = 6, canvasXpressOutput("chart_all_cases", height = "670px"))))

mapPanel     <- tabPanel("World Map",
                         leafletOutput("map", height = "700px"))

ccPanel      <- tabPanel("Country comparison",
                         fluidRow(column(width = 2, 
                                         selectizeInput("caseType",
                                                        label    = ui_tooltip('caseTypeTooltip', "Case Type", "Select a type"),
                                                        choices  = g_tabs,
                                                        multiple = FALSE,
                                                        width    = "100%")),
                                  column(width = 2, sliderInput("maxHistory",   "History (days)", value = 10, min = 1, max = 45)),
                                  column(width = 3, sliderInput("maxCountries", "Top Countries", value = 15, min = 1, max = 20))),
                         fluidRow(column(width = 8, canvasXpressOutput("chart_country_compare", height = "670px")),
                                  column(width = 4, canvasXpressOutput("chart_country_rel", height = "670px"))))

dutchMapPanel     <- tabPanel("Netherlands",
                              fluidRow(column(width = 6, leafletOutput("dutchMap", height = "700px")),
                                       column(width = 6, canvasXpressOutput("dutch_all_cases", height = "700px"))))

body2 <- shinydashboard::tabBox(id       = "outputTab",
                                title    = NULL,
                                width    = 12,
                                selected = "Cases over Time",
                                timePanel,
                                ccPanel,
                                mapPanel,
                                dutchMapPanel)

# -- Register Elements in the ORDER SHOWN in the UI

add_ui_body(list(body1, body2), append = FALSE)
