library(shiny)


shinyUI(fluidPage(
    #displays prediction for Horsepower
    titlePanel("Predict Horsepower from MPG"),
    sidebarLayout(
        sidebarPanel(
            sliderInput("sliderMPG", "MPG of the car?", 10, 35, value = 20), #slider object
            checkboxInput("showModel1", "Show/Hide Model 1", value = TRUE), #show/hide model values
            checkboxInput("showModel2", "Show/Hide Model 2", value = TRUE),
            submitButton("Submit") # add to manually update the values after clicking on submit button
        ),
            
        mainPanel(
            plotOutput("plot1"),
            h3("Predicted Horsepower from Model 1:"),
            textOutput("pred1"),
            h3("Predicted Horsepower from Model 2:"),
            textOutput("pred2")
            
        )
    )    
))