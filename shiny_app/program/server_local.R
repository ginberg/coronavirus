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

get_data <- reactive({
    g_map_data %>% select(1, 2, 5, 6, 7) %>% arrange(desc(Confirmed))
})

# ----------------------------------------
# --          SHINY SERVER CODE         --
# ----------------------------------------

observe({
    updateSelectizeInput(session, "countrySel",
                         choices = unique(g_map_data$Country))
})

# -- Setup Download Modules with Functions we want called
callModule(downloadableTable, "coronaDT",  ss_userAction.Log,
           "exampletable",
           list(csv = get_data, tsv = get_data),
           get_data,
           rownames = FALSE)


output$map <- renderLeaflet({
    leaflet(g_map_data) %>% 
        setView(lng = 112.27070, lat = 30.97564, zoom = 5) %>%
        addTiles() %>%
        addCircles(lng = ~Lon, lat = ~Lat, weight = 1, radius = ~((sqrt(Confirmed) + 25) * 1000), popup = ~Province, color = "#FF0000")
})

output$chart <- renderCanvasXpress({
    get_line_chart(g_line_data)
})

output$total_stats <- renderUI({
    get_stats_block(g_map_data)
})

output$last_update <- renderUI({
    tags$div(style="text-align:center",
             tags$div(tags$h4("Last update:"), tags$h4(format(Sys.time(), "%b %d %Y %H:%M"))))
})

output$country_stats <- renderUI({
    country <- input$countrySel
    data <- g_map_data %>% filter(Country == country)
    get_stats_block(data)
})
    