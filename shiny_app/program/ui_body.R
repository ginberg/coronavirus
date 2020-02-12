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
                             downloadableTableUI("coronaDT",
                                                  list("csv", "tsv"),
                                                  "Download table data"))

timePanel    <- tabPanel("Cases in Time",
                         fluidRow(column(width = 6, canvasXpressOutput("chart_new_cases", height = "670px")),
                                  column(width = 6, canvasXpressOutput("chart_all_cases", height = "670px"))))

mapPanel     <- tabPanel("Cases per Region",
                         leafletOutput("map", height = "700px"))

body2 <- shinydashboard::tabBox(id       = "outputTab",
                title    = NULL,
                width    = 12,
                selected = "Cases in Time",
                timePanel,
                mapPanel)

# -- Register Elements in the ORDER SHOWN in the UI

add_ui_body(list(body1, body2), append = FALSE)
