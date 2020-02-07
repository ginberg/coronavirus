## Other supporting functions

get_stats_block <- function(data) {
    tags$div(style="text-align:center",
                 tags$div(tags$h3("Confirmed:"), tags$h2(style=glue("color:{g_colors[1]}"), sum(data$Confirmed, na.rm = T))),
                 tags$div(tags$h3("Deaths:"), tags$h2(style=glue("color:{g_colors[2]}"), sum(data$Death, na.rm = T))),
                 tags$div(tags$h3("Recovered:"), tags$h2(style=glue("color:{g_colors[3]}"), sum(data$Recovered, na.rm = T))))
}