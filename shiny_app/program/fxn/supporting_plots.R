## Supporting plots

get_line_chart <- function(data) {
    canvasXpress(
            data              = data,
            graphOrientation  = "vertical",
            graphType         = "Line",
            lineType          = "spline",
            smpLabelRotate    = 45,
            smpTitle          = "Date",
            smpTitleFontStyle = "italic",
            colors            = g_colors,
            xAxis2Show        = FALSE,
            title             = "2019-nCoV over time",
            smpLabelScaleFontFactor = 0.3)
}