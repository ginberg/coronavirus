## supporting data functions

get_all_data <- function(sheet, tab_name) {
    suppressMessages(googlesheets4::sheets_read(cases_sheet, sheet = tab_name))
}

get_map_data <- function(data, tab_name) {
    data <- data %>% 
        select(c(1,2,4,5, tail(names(.), 1)))
    colnames(data) <- c("Province", "Country", "Lat", "Lon", tab_name)
    data
}

get_line_data <- function(data, tab_name) {
    data %>% select(-c(3,4,5)) %>% summarise_if(is.numeric, sum, na.rm = TRUE) %>%
        mutate(Type = tab_name)
}

if (g_live_data) {
    confirmed_data  <- get_all_data(cases_sheet, confirmed)
    recovered_data  <- get_all_data(cases_sheet, recovered)
    death_data      <- get_all_data(cases_sheet, death)
     
    confirmed_cases <- get_map_data(confirmed_data, confirmed)
    recovered_cases <- get_map_data(recovered_data, recovered)
    death_cases     <- get_map_data(death_data, death)
    
    map_data <- confirmed_cases %>%
        left_join(recovered_cases) %>%
        left_join(death_cases)
    
    line_data <- rbind.fill(get_line_data(confirmed_data, confirmed),
                            get_line_data(death_data, death),
                            get_line_data(recovered_data, recovered)) %>% tibble::column_to_rownames("Type")
    
    saveRDS(map_data, "program/data/map_data.rds")
    saveRDS(line_data, "program/data/line_data.rds")
}

get_map_data <- function() {
    readRDS("program/data/map_data.rds")
}

get_line_data <- function() {
    readRDS("program/data/line_data.rds")
}