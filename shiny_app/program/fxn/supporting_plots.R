## Supporting plots

get_map_chart <- function() {
    popup_content <- paste(sep = "<br/>",
                           "The virus likely started from",
                           "a <b><a target = '_blank' href='https://www.businessinsider.nl/wuhan-coronavirus-chinese-wet-market-photos-2020-1?international=true&r=US Center'>Seafood market</a></b> in Wuhan.")
    leaflet(g_map_data) %>% 
            setView(lng = 112.27070, lat = 30.97564, zoom = 4.5) %>%
            addProviderTiles('Esri.WorldImagery') %>%
            addProviderTiles("CartoDB.PositronOnlyLabels") %>%
            addCircles(lng = ~Lon,
                       lat = ~Lat,
                       weight = 1,
                       radius = ~((sqrt(Confirmed) + 25) * 1000),
                       popup = paste0(ifelse(is.na(g_map_data$Province) | g_map_data$Province == "", paste0("<b>", g_map_data$Country, "</b>"), paste0("<b>", g_map_data$Province, "</b>:", g_map_data$Country)), "<br>",
                                      "Confirmed: <font color='orange'>", g_map_data$Confirmed, "</font><br>",
                                      "Deaths:    <font color='red'>", g_map_data$Death,        "</font><br>",
                                      "Recovered: <font color='green'>", g_map_data$Recovered,  "</font><br>"),
                       color = "#FF0000",
                       fillOpacity = 1) %>%
            addPopups(112.27070, 30.97564, popup_content, options = popupOptions(closeButton = FALSE))
}

get_line_chart <- function(data, title, show_decoration = FALSE) {
    plot_decorations <- NULL
    if (show_decoration) {
        plot_decorations <- list(marker = list(list(sample = list("2020-02-13"), 
                                                    text = "The spike observed on Feb. 12 is the result\n of a change in diagnosis classification for which\n 13,332 clinically (rather than laboratory) confirmed cases\n were all reported as new cases", variable = "Confirmed", 
                                                    x = 0.3, 
                                                    y = 0.05)))
    }
    bg_color   <- "#222d32"
    font_color <- "#fff"
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
            background        = bg_color,
            axisTickColor     = font_color,
            titleColor        = font_color,
            legendColor       = font_color,
            decorationsColor  = font_color,
            smpLabelFontColor = font_color,
            setMaxX           = max(data),
            decorationScaleFontFactor = 0.6,
            smpLabelScaleFontFactor   = 0.3)
}
