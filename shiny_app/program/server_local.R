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

autoInvalidate <- reactiveTimer(g_refresh_period)
 
get_table_data <- reactive({
    g_map_data %>% select(1, 2, 5, 6, 7) %>% arrange(desc(Confirmed))
})

# ----------------------------------------
# --          SHINY SERVER CODE         --
# ----------------------------------------

observe({
    countries <- g_map_data %>% 
        arrange(-Confirmed) %>% 
        mutate(Country = ifelse(Country == "Others", glue("{Country} ({Province})"), Country)) %>%
        pull(Country) %>% unique()
    updateSelectizeInput(session, "countrySel",
                         choices = countries,
                         selected = character(0),
                         options  = list(placeholder = "Type/Click then Select"))
})

observeEvent( autoInvalidate(), {
    autoInvalidate()
    loginfo("restarting app")
    session$reload()
}, ignoreInit = T)

# -- Setup Download Modules with Functions we want called
callModule(downloadableTable, "coronaDT",  ss_userAction.Log,
           "exampletable",
           list(csv = get_table_data, tsv = get_table_data),
           get_table_data,
           rownames = FALSE)


output$map <- renderLeaflet({
    get_map_chart()
})

output$chart_all_cases <- renderCanvasXpress({
    data  <- g_line_data
    title <- "Total Cases"
    country <- NULL
    if (!is.null(input$countrySel) && input$countrySel != "") {
        country <- trimws(gsub("\\(.*", "", input$countrySel))
        data <- filter_summarize_line_data(g_all_line_data, country)
        title <- glue("Total Cases - {ifelse(startsWith(input$countrySel, 'Others'), input$countrySel, country)}")
    }
    get_line_chart(data, title)
})

output$chart_new_cases <- renderCanvasXpress({
    data  <- g_line_data
    title <- "New Cases per day"
    country <- NULL
    if (!is.null(input$countrySel) && input$countrySel != "") {
        country <- trimws(gsub("\\(.*", "", input$countrySel))
        data <- filter_summarize_line_data(g_all_line_data, country)
        title <- glue("New Cases per day - {ifelse(startsWith(input$countrySel, 'Others'), input$countrySel, country)}")
    }
    new_data <- data %>% 
        t() %>% as.data.frame() %>%
        tibble::rownames_to_column("date") %>%
        mutate(Confirmed = Confirmed - lag(Confirmed)) %>% 
        mutate(Death = Death - lag(Death)) %>% 
        mutate(Recovered = Recovered - lag(Recovered)) %>% 
        tibble::column_to_rownames("date") %>%
        t() %>% as.data.frame()
    get_line_chart(new_data, title, show_decoration = is.null(country))
})

output$total_stats <- renderUI({
    get_stats_block(g_map_data)
})

output$about_text <- renderUI({
    tags$div(style="text-align:center;",
             "This app visualizes the spread of the Coronavirus 2019 using ",
             tags$a(href='https://github.com/CSSEGISandData/COVID-19', "data"),
             "from John Hopkins University. This dashboard is automatically updated twice a day.",
             tags$p(), tags$a(href='https://github.com/ginberg/coronavirus', "Code on github"))
})

output$last_update <- renderUI({
    dates  <- strptime(colnames(g_line_data), format = "%Y-%m-%d")
    dates  <- rev(dates[order(dates)])
    latest <- dates[!is.na(dates)][1]
    tags$div(style="text-align:center",
             tags$div(tags$h4("Last update:"), tags$h4(format(latest, "%b %d %Y"))))
})

output$country_stats <- renderUI({
    data <- g_map_data
    if (!is.null(input$countrySel) && input$countrySel != "") {
        country <- trimws(gsub("\\(.*", "", input$countrySel))
        data <- g_map_data %>% filter(Country == country)
    }
    get_stats_block(data)
})
    