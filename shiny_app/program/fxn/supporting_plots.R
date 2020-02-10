## Supporting plots


get_map_chart <- function() {
    leaflet(g_map_data) %>% 
            setView(lng = 112.27070, lat = 30.97564, zoom = 5) %>%
            addTiles() %>%
            addCircles(lng = ~Lon, 
                       lat = ~Lat, 
                       weight = 1, 
                       radius = ~((sqrt(Confirmed) + 25) * 1000), 
                       popup = paste0(ifelse(is.na(g_map_data$Province), paste0("<b>", g_map_data$Country, "</b>"), paste0("<b>", g_map_data$Province, "</b>:", g_map_data$Country)), "<br>",
                                      "Confirmed: <font color='orange'>", g_map_data$Confirmed, "</font><br>", 
                                      "Deaths:    <font color='red'>", g_map_data$Death,        "</font><br>",
                                      "Recovered: <font color='green'>", g_map_data$Recovered,  "</font><br>"),
                       color = "#FF0000")
}

get_line_chart <- function(data) {
    canvasXpress(
            data              = data,
            graphOrientation  = "vertical",
            graphType         = "Line",
            lineType          = "spline",
            smpLabelRotate    = 45,
            smpTitle          = NULL,
            smpTitleFontStyle = "italic",
            colors            = g_colors,
            xAxis2Show        = FALSE,
            title             = "2019-nCoV over time",
            legendPosition    = "bottom",
            legendColumns     = 3,
            smpLabelScaleFontFactor = 0.3)
}