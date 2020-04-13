## Other supporting functions

get_stats_block <- function(data) {
    tags$div(style="text-align:center",
                 tags$div(tags$h3("Confirmed:"), tags$h2(style=glue("color:{g_colors[1]}"), formatC(sum(data$Confirmed, na.rm = T), format="f", big.mark = ".", decimal.mark = ",", digits = 0))),
                 tags$div(tags$h3("Deaths:"), tags$h2(style=glue("color:{g_colors[2]}"),    formatC(sum(data$Death, na.rm = T), format="f", big.mark = ".", decimal.mark = ",", digits = 0))))
}