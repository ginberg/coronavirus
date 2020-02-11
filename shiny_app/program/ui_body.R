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

timePanel    <- tabPanel("Evolution in Time",
                         canvasXpressOutput("chart", height = "670px"))

mapPanel     <- tabPanel("World Map",
                         leafletOutput("map", height = "700px"))

body2 <- tabBox(id       = "outputTab",
                title    = NULL,
                width    = 12,
                selected = "Evolution in Time",
                timePanel,
                mapPanel)

# -- Register Elements in the ORDER SHOWN in the UI

add_ui_body(list(body1, body2), append = FALSE)
