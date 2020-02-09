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
    get_map_chart()
})

output$chart <- renderCanvasXpress({
    get_line_chart(g_line_data)
})

output$total_stats <- renderUI({
    get_stats_block(g_map_data)
})

output$last_update <- renderUI({
    dates  <- strptime(colnames(g_line_data), format = "%m/%d/%Y %I:%M %p")
    dates  <- rev(dates[order(dates)])
    latest <- dates[!is.na(dates)][1]
    tags$div(style="text-align:center",
             tags$div(tags$h4("Last update:"), tags$h4(format(latest, "%b %d %Y %H:%M"))))
})

output$country_stats <- renderUI({
    country <- input$countrySel
    data <- g_map_data %>% filter(Country == country)
    get_stats_block(data)
})
    