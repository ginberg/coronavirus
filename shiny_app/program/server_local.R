# ----------------------------------------
# --       PROGRAM server_local.R       --
# ----------------------------------------
# USE: Session-specific variables and
#      functions for the main reactive
#      shiny server functionality.  All
#      code in this file will be put into
#      the framework inside the call to
#      shinyServer(function(input, output, session)
#      in server.R
#
# NOTEs:
#   - All variables/functions here are
#     SESSION scoped and are ONLY
#     available to a single session and
#     not to the UI
#
#   - For globally scoped session items
#     put var/fxns in server_global.R
#
# FRAMEWORK VARIABLES
#     input, output, session - Shiny
#     ss_userAction.Log - Reactive Logger S4 object
# ----------------------------------------

# -- IMPORTS --


# -- VARIABLES --


# -- FUNCTIONS --
source(paste("program", "fxn", "supporting_data.R", sep = .Platform$file.sep))
source(paste("program", "fxn", "supporting_plots.R", sep = .Platform$file.sep))

get_data <- reactive({
    data %>% select(1, 2, 5, 6, 7) %>% arrange(desc(Confirmed))
})

# ----------------------------------------
# --          SHINY SERVER CODE         --
# ----------------------------------------

# -- Setup Download Modules with Functions we want called
callModule(downloadableTable, "coronaDT",  ss_userAction.Log,
           "exampletable",
           list(csv = get_data, tsv = get_data),
           get_data,
           rownames = FALSE)


output$map <- renderLeaflet({
    leaflet(data) %>% 
        setView(lng = 20, lat = 31, zoom = 2.5) %>%
        addTiles() %>%
        addCircles(lng = ~Lon, lat = ~Lat, weight = 1, radius = ~((sqrt(Confirmed) + 25) * 1000), popup = ~Province, color = "red")
})

output$totalStats <- renderUI({
    tags$div(style="text-align:center",
             tags$div(tags$h3("Confirmed:"), tags$h2(sum(data$Confirmed, na.rm = T))),
             tags$div(tags$h3("Deaths:"), tags$h2(sum(data$Death, na.rm = T))),
             tags$div(tags$h3("Recovered:"), tags$h2(sum(data$Recovered, na.rm = T))))
})
    
    