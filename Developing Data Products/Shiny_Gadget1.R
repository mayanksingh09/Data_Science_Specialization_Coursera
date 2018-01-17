library(shiny)
library(miniUI)

myFirstGadget <- function() {
    ui <- miniPage(
        gadgetTitleBar("My First Gadget") # simple title bar page
    )
    server <- function(input, output, session) {
        # The Done button closes the app
        observeEvent(input$done, {
            stopApp()
        })
    }
    runGadget(ui, server)
}

myFirstGadget()
