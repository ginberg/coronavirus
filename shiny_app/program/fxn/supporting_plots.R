## Supporting plots

get_map_chart <- function() {
    leaflet(g_map_data) %>% 
            setView(lng = 112.27070, lat = 30.97564, zoom = 4.5) %>%
            addProviderTiles(providers$OpenStreetMap) %>%
            addCircles(lng = ~Lon, 
                       lat = ~Lat, 
                       weight = 1, 
                       radius = ~((sqrt(Confirmed) + 25) * 1000), 
                       popup = paste0(ifelse(is.na(g_map_data$Province) | g_map_data$Province == "", paste0("<b>", g_map_data$Country, "</b>"), paste0("<b>", g_map_data$Province, "</b>:", g_map_data$Country)), "<br>",
                                      "Confirmed: <font color='orange'>", g_map_data$Confirmed, "</font><br>", 
                                      "Deaths:    <font color='red'>", g_map_data$Death,        "</font><br>",
                                      "Recovered: <font color='green'>", g_map_data$Recovered,  "</font><br>"),
                       color = "#FF0000")
}

get_line_chart <- function(data, title, show_decoration = FALSE) {
    plot_decorations <- NULL
    if (show_decoration) {
        plot_decorations <- list(marker = list(list(sample = list("2020-02-13"), 
                                                    text = "The spike observed on Feb. 12 is the result\n of a change in diagnosis classification for which\n 13,332 clinically (rather than laboratory) confirmed cases\n were all reported as new cases", variable = "Confirmed", 
                                                    x = 0.3, 
                                                    y = 0.05)))
    }
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
            title             = title,
            legendPosition    = "bottom",
            legendColumns     = 3,
            decorations       = plot_decorations,
            background        = "#333",
            axisTickColor     = "#fff",
            titleColor        = "#fff",
            legendColor       = "#fff",
            decorationsColor  = "#fff",
            smpLabelFontColor = "#fff",
            decorationScaleFontFactor = 0.6,
            smpLabelScaleFontFactor   = 0.3)
}
