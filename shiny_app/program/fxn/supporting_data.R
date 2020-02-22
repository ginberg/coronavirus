## supporting data functions

get_all_data <- function(tab_name) {
    result <- NULL
    base_URL <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/"
    if (tab_name == g_confirmed) {
        result <- read.csv(glue("{base_URL}time_series_19-covid-Confirmed.csv"))
    } else if (tab_name == g_recovered) {
        result <- read.csv(glue("{base_URL}time_series_19-covid-Recovered.csv"))
    } else if (tab_name == g_death) {
        result <- read.csv(glue("{base_URL}time_series_19-covid-Deaths.csv"))
    }
    colnames(result) <- gsub("X", "0", colnames(result))
    result
}

get_map_data <- function(data, tab_name) {
    data <- data %>% 
        select(c(1,2,3,4, tail(names(.), 1))) %>%
        mutate_if(is.factor, as.character) 
    colnames(data) <- c("Province", "Country", "Lat", "Lon", tab_name)
    data
}

get_line_data <- function(data, tab_name) {
    data %>% 
        select(-c(3,4)) %>% 
        summarise_if(is.numeric, sum, na.rm = TRUE) %>%
        t() %>% as.data.frame() %>%
        tibble::rownames_to_column("date") %>% 
        mutate(date = as.Date(date, "%m.%d.%y")) %>%
        mutate(value = as.numeric(as.character(V1))) %>%
        select(-V1) %>%
        dplyr::group_by(date) %>%
        dplyr::summarize(value = round(mean(value))) %>% 
        tibble::column_to_rownames("date") %>% 
        t() %>% as.data.frame() %>%
        mutate(Type = tab_name)
}

if (g_live_data) {
    confirmed_data  <- get_all_data(g_confirmed)
    recovered_data  <- get_all_data(g_recovered)
    death_data      <- get_all_data(g_death)
     
    confirmed_cases <- get_map_data(confirmed_data, g_confirmed)
    recovered_cases <- get_map_data(recovered_data, g_recovered)
    death_cases     <- get_map_data(death_data, g_death)
    
    map_data <- confirmed_cases %>%
        left_join(recovered_cases) %>%
        left_join(death_cases)
    
    line_data <- rbind.fill(get_line_data(confirmed_data, g_confirmed),
                            get_line_data(death_data, g_death),
                            get_line_data(recovered_data, g_recovered)) %>% 
        tibble::column_to_rownames("Type")
    
    saveRDS(map_data,  "program/data/map_data.rds")
    saveRDS(line_data, "program/data/line_data.rds")
}

get_map_data <- function() {
    readRDS("program/data/map_data.rds")
}

get_line_data <- function() {
    readRDS("program/data/line_data.rds")
}