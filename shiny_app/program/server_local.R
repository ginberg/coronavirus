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
    map_data %>% select(1, 2, 5, 6, 7) %>% arrange(desc(Confirmed))
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
    leaflet(map_data) %>% 
        setView(lng = 112.27070, lat = 30.97564, zoom = 5) %>%
        addTiles() %>%
        addCircles(lng = ~Lon, lat = ~Lat, weight = 1, radius = ~((sqrt(Confirmed) + 25) * 1000), popup = ~Province, color = "#FF0000")
})

output$chart <- renderCanvasXpress({
    canvasXpress(
        data              = line_data,
        graphOrientation  = "vertical",
        graphType         = "Line",
        lineType          = "spline",
        smpLabelRotate    = 45,
        smpTitle          = "Date",
        smpTitleFontStyle = "italic",
        colors            = colors,
        xAxis2Show        = FALSE,
        title             = "2019-nCoV over time",
        smpLabelScaleFontFactor = 0.3)
})

output$total_stats <- renderUI({
    tags$div(style="text-align:center",
             tags$div(tags$h3("Confirmed:"), tags$h2(style=glue("color:{colors[1]}"), sum(map_data$Confirmed, na.rm = T))),
             tags$div(tags$h3("Deaths:"), tags$h2(style=glue("color:{colors[2]}"), sum(map_data$Death, na.rm = T))),
             tags$div(tags$h3("Recovered:"), tags$h2(style=glue("color:{colors[3]}"), sum(map_data$Recovered, na.rm = T))))
})

output$last_update <- renderUI({
    tags$div(style="text-align:center",
             tags$div(tags$h4("Last update:"), tags$h4(format(Sys.time(), "%b %d %Y %H:%M"))))
})    
    