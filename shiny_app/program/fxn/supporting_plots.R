## Supporting plots

bg_color   <- "#222d32"
font_color <- "#fff"
    
get_map_chart <- function() {
    popup_content <- paste(sep = "<br/>",
                           "The virus likely started from",
                           "a <b><a target = '_blank' href='https://www.businessinsider.nl/wuhan-coronavirus-chinese-wet-market-photos-2020-1?international=true&r=US Center'>Seafood market</a></b> in Wuhan.")
    #china: lng = 112.27070, lat = 30.97564
    #italy: lon = 12.0000  , lat = 43.00000
    leaflet(g_map_data) %>% 
            setView(lng = 112.27070, lat = 30.97564, zoom = 4.5) %>%
            addProviderTiles('Esri.WorldImagery') %>%
            addProviderTiles("CartoDB.PositronOnlyLabels") %>%
            addCircles(lng = ~Lon,
                       lat = ~Lat,
                       weight = 1,
                       radius = ~((sqrt(Confirmed) + 25) * 500),
                       popup = paste0(ifelse(is.na(g_map_data$Province) | g_map_data$Province == "", paste0("<b>", g_map_data$Country, "</b>"), paste0("<b>", g_map_data$Province, "</b>:", g_map_data$Country)), "<br>",
                                      "Confirmed: <font color='orange'>", g_map_data$Confirmed, "</font><br>",
                                      "Deaths:    <font color='red'>", g_map_data$Death,        "</font><br>"),
                       color = "#FF0000",
                       fillOpacity = 1) %>%
            addPopups(112.27070, 30.97564, popup_content, options = popupOptions(closeButton = FALSE))
}

get_dutch_map_chart <- function() {
    leaflet(g_dutch_map_data) %>% 
            setView(lng = 5.304373, lat = 51.90596, zoom = 7.5) %>%
            addProviderTiles('Esri.WorldImagery') %>%
            addProviderTiles("CartoDB.PositronOnlyLabels") %>%
            addCircles(lng = ~lon,
                       lat = ~lat,
                       weight = 1,
                       radius = ~((sqrt(Aantal) + 1) * 200),
                       popup = paste0("<b>", g_dutch_map_data$Gemeente, "</b><br>", "Aantal: <font color='red'>", g_dutch_map_data$Aantal, "</font>"),
                       color = "#FF0000",
                       fillOpacity = 1)
}

get_line_chart <- function(data, title, show_decoration = FALSE, adjust_scale = FALSE, log_scale = FALSE) {
    plot_decorations <- NULL
    x_axis_transform <- FALSE
    x_axis_title     <- "Count"
    if (log_scale) {
        x_axis_transform <- "log10"
        x_axis_title     <- "log10(Count)"
    } else {
        if (show_decoration) {
            plot_decorations <- list(marker = list(list(sample = list("2020-02-13"), 
                                                        text = "The spike observed on Feb. 12\n is the result of a change in\n diagnosis classification for which 13,332\n clinically (rather than laboratory) confirmed\n cases were all reported as new cases", variable = "Confirmed", 
                                                        x = 0.17, 
                                                        y = 0.06)))
        }
        if (adjust_scale) {
            x_axis_title <- "Count (x1000)"
            data <- data / 1000    
        }
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
            background        = bg_color,
            axisTitleColor    = font_color,
            axisTickColor     = font_color,
            titleColor        = font_color,
            legendColor       = font_color,
            decorationsColor  = font_color,
            smpLabelFontColor = font_color,
            xAxisTicks        = 10,
            xAxisTitle        = x_axis_title,
            xAxisTransform    = x_axis_transform,
            decorationScaleFontFactor = 0.6,
            smpLabelScaleFontFactor   = 0.3)
}

get_country_comparison_chart <- function(data, title, subtitle, adjust_scale = FALSE, log_scale = FALSE) {
    x_axis_title     <- "Count"
    x_axis_transform <- FALSE
    if (log_scale) {
        x_axis_transform <- "log10"
        x_axis_title     <- "log10(Count)"
    } else {
        if (adjust_scale) {
            x_axis_title <- "Count (x1000)"
            data <- data / 1000    
        }
    }
    canvasXpress(
            data              = data,
            graphOrientation  = "vertical",
            graphType         = "Line",
            lineType          = "spline",
            smpLabelRotate    = 45,
            smpTitle          = NULL,
            smpTitleFontStyle = "italic",
            xAxis2Show        = FALSE,
            title             = title,
            subtitle          = subtitle,
            legendPosition    = "right",
            background        = bg_color,
            axisTitleColor    = font_color,
            axisTickColor     = font_color,
            titleColor        = font_color,
            subtitleColor     = font_color,
            legendColor       = font_color,
            decorationsColor  = font_color,
            smpLabelFontColor = font_color,
            xAxisTicks        = 10,
            xAxisTitle        = x_axis_title,
            xAxisTransform    = x_axis_transform,
            decorationScaleFontFactor = 0.6,
            smpLabelScaleFontFactor   = 0.3,
            titleScaleFontFactor      = 0.6,
            subtitleScaleFontFactor   = 0.4)
}

get_country_comparison_bar_chart <- function(data, type, title, subtitle) {
    colors <- NULL
    if (type == g_confirmed) {
        colors <- g_colors[1]
    } else if (type == g_death) {
        colors <- g_colors[2]
    }
    canvasXpress(
        data              = data,
        graphOrientation  = "horizontal",
        graphType         = "Bar",
        colors            = colors,
        showLegend        = FALSE,
        xAxis2Show        = FALSE,
        background        = bg_color,
        axisTitleColor    = font_color,
        axisTickColor     = font_color,
        titleColor        = font_color,
        subtitleColor     = font_color,
        legendColor       = font_color,
        decorationsColor  = font_color,
        smpLabelFontColor = font_color,
        title             = title,
        subtitle          = subtitle,
        titleScaleFontFactor    = 0.6,
        subtitleScaleFontFactor = 0.4)
}
