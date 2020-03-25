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
    g_map_data %>% select(1, 2, 5, 6) %>% arrange(desc(Confirmed))
})

type_data <- reactive({
    data      <- g_line_data
    case_type <- input$caseType
    if (!is.null(case_type) && case_type != "" && case_type %in% g_tabs) { 
        max_countries    <- input$maxCountries
        data <- get_type_data(g_all_line_data, case_type, max_countries)
    }
    data
})

recent_type_data <- reactive({
    data      <- g_line_data
    case_type <- input$caseType
    if (!is.null(case_type) && case_type != "" && case_type %in% g_tabs) { 
        max_countries    <- input$maxCountries
        max_history_days <- input$maxHistory
        data <- get_type_data(g_all_line_data, case_type, max_countries, max_history_days)
    }
    data
})

# -- Setup Download Modules with Functions we want called
callModule(downloadableTable, "coronaDT",  ss_userAction.Log,
           "exampletable",
           list(csv = get_table_data, tsv = get_table_data),
           get_table_data,
           rownames = FALSE)

# ----------------------------------------
# --          SHINY SERVER CODE         --
# ----------------------------------------


output$map <- renderLeaflet({
    get_map_chart()
})

output$dutchMap <- renderLeaflet({
    get_dutch_map_chart()
})

output$chart_all_cases <- renderCanvasXpress({
    data  <- g_line_data
    title <- "Total Cases"
    country <- NULL
    adjust_scale <- TRUE
    if (!is.null(input$countrySel) && input$countrySel != "" && input$countrySel != g_all_option) {
        country <- trimws(gsub("\\(.*", "", input$countrySel))
        data <- get_country_data(g_all_line_data, country)
        title <- glue("Total Cases - {ifelse(startsWith(input$countrySel, 'Others'), input$countrySel, country)}")
        if (country != g_mainland_china) {
            adjust_scale <- FALSE
        }
    }
    get_line_chart(data, title, show_decoration = FALSE, adjust_scale = adjust_scale, log_scale = input$log_scale)
})

output$chart_new_cases <- renderCanvasXpress({
    data  <- g_line_data
    title <- "New Cases per day"
    country <- NULL
    show_decoration <- TRUE
    adjust_scale    <- TRUE
    if (!is.null(input$countrySel) && input$countrySel != "" && input$countrySel != g_all_option) {
        country <- trimws(gsub("\\(.*", "", input$countrySel))
        data <- get_country_data(g_all_line_data, country)
        title <- glue("New Cases per day - {ifelse(startsWith(input$countrySel, 'Others'), input$countrySel, country)}")
        if (country != g_mainland_china) {
            show_decoration <- FALSE
            adjust_scale    <- FALSE
        }
    }
    new_data <- data %>% 
        t() %>% as.data.frame() %>%
        tibble::rownames_to_column("date") %>%
        mutate(Confirmed = Confirmed - lag(Confirmed)) %>% 
        mutate(Death = Death - lag(Death)) %>% 
        tibble::column_to_rownames("date") %>%
        t() %>% as.data.frame()
    get_line_chart(new_data, title, show_decoration = show_decoration, adjust_scale = adjust_scale, log_scale = input$log_scale)
})

output$chart_country_compare <- renderCanvasXpress({
    result <- NULL
    data  <- recent_type_data()
    if (!is.null(data)) { 
        title    <- glue("Daily {input$caseType} Cases")
        subtitle <- glue("Last {input$maxHistory} days")
        result <- get_country_comparison_chart(data, title, subtitle, adjust_scale = FALSE, log_scale = input$log_scale)
    }
    result
})

output$chart_country_rel <- renderCanvasXpress({
    result <- NULL
    data  <- type_data()
    if (!is.null(data)) {
        data <- data %>% 
            rownames_to_column("country") %>%
            mutate(total = rowSums(.[-1])) %>% arrange(desc(total)) %>% 
            select(c(1, ncol(.))) %>% 
            set_colnames(c("country", "cases")) %>%
            left_join(g_country_pop) %>%
            mutate(cases_per_million = cases / population) %>%
            select(-c(population, cases)) %>% 
            arrange(desc(cases_per_million)) %>%
            column_to_rownames("country") %>% t()
        title    <- glue("Total {input$caseType} Cases")
        subtitle <- glue("Per million inhabitants")
        result <- get_country_comparison_bar_chart(data, input$caseType, title, subtitle)
    }
    result
})

output$dutch_all_cases <- renderCanvasXpress({
    title <- "Total Cases Netherlands"
    data <- get_country_data(g_all_line_data, "Netherlands")
    data <- data[, colSums(data) > 0]
    get_line_chart(data, title, show_decoration = FALSE, log_scale = input$log_scale)
})

output$total_stats <- renderUI({
    get_stats_block(g_map_data)
})

output$about_text <- renderUI({
    tags$div(style="text-align:center;",
             "This dashboard visualizes the spread of the Coronavirus 2019 using ",
             "Data retrieved from",
             tags$a(href='https://github.com/CSSEGISandData/COVID-19', "John Hopkins University"),
             "and", 
             tags$a(href='https://www.rivm.nl/coronavirus-kaart-van-nederland', "RIVM."),
             "The dashboard is automatically updated twice a day.",
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
    if (!is.null(input$countrySel) && input$countrySel != "" && input$countrySel != g_all_option) {
        country <- trimws(gsub("\\(.*", "", input$countrySel))
        data <- g_map_data %>% filter(Country == country)
    }
    get_stats_block(data)
})

observe({
    countries <- g_map_data %>% 
        arrange(-Confirmed) %>% 
        mutate(Country = ifelse(Country == "Others", glue("{Country} ({Province})"), Country)) %>%
        pull(Country) %>% unique()
    updateSelectizeInput(session, "countrySel",
                         choices = c(g_all_option, countries),
                         selected = character(0),
                         options  = list(placeholder = "Type/Click then Select"))
})

observeEvent( autoInvalidate(), {
    autoInvalidate()
    loginfo("restarting app")
    session$reload()
}, ignoreInit = T)

observeEvent(input$countrySel, {
    country <-  trimws(gsub("\\(.*", "", input$countrySel))
    
    if (!is.null(country) && country != "" && country != g_all_option) {
        map_center <- g_map_data %>% 
            filter(Country == country) %>% 
            slice(1:1) %>% 
            select(Lat, Lon)
        leafletProxy("map") %>%
          setView(lng = map_center$Lon, lat = map_center$Lat, zoom = 4.5)
    }
})
    