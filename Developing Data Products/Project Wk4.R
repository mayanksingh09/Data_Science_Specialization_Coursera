library(plotly)
library(shiny)

ui <- fluidPage(
    plotlyOutput("plot"),
    checkboxInput("showcyl4", "Show/Hide Cyl 4", value = TRUE), #show/hide cyl values
    checkboxInput("showcyl6", "Show/Hide Cyl 6", value = TRUE),
    checkboxInput("showcyl8", "Show/Hide Cyl 8", value = TRUE),
    verbatimTextOutput("event")
)

server <- function(input, output) {
    
    # renderPlotly() also understands ggplot2 objects!
    output$plot <- renderPlotly({
        plot_ly(mtcars, x = ~mpg, y = ~wt, color = ~as.factor(cyl))
    })
    
    output$event <- renderPrint({
        d <- event_data("plotly_hover")
        if (is.null(d)) "Hover on a point!" else d
    })
}

shinyApp(ui, server)

