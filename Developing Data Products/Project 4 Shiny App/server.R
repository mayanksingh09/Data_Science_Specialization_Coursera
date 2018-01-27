library(shiny)

shinyServer(function(input, output){
    
    model1 <- lm(hp ~ mpg, data = mtcars)
    model2 <- lm(hp ~ poly(mpg, 3), data = mtcars)
    
    model1pred <- reactive({
        mpgInput <- input$sliderMPG #taking the value from the slider object
        predict(model1, newdata = data.frame(mpg = mpgInput))
    })
    
    model2pred <- reactive({
        mpgInput <- input$sliderMPG
        predict(model2, newdata = data.frame(mpg = mpgInput,
                                             mpgsp = mpgInput))
    })
    
    output$plot1 <- renderPlot({
        mpgInput <- input$sliderMPG
        
        plot(mtcars$mpg, mtcars$hp, xlab = "Miles Per Gallon",
             ylab = "Horsepower", bty = "n", pch = 16,
             xlim = c(10, 35), ylim = c(50, 350))
        # show fit(line) for whichever model is applicable
        if(input$showModel1){
            abline(model1, col = "red", lwd = 2)
        }
        if(input$showModel2){
            model2lines <- predict(model2, newdata = data.frame(mpg = 10:35, mpgsp = ifelse(10:35 - 20 > 0, 10:35 - 20, 0)
            ))
            predicted.intervals <- predict(model2, mtcars)
            lines(mtcars$mpg, predicted.intervals, col='green',lwd=2)
        }
        
        legend(25, 250, c("Model 1 Prection", "Model 2 Prection"), pch = 16, 
               col = c("red", "green"), bty = "n", cex = 1.2)
        
        # add points that we input and also the result of the prediction (as model1pred is a fn, put the brackets to get the point)
        points(mpgInput, model1pred(), col = "red", pch = 16, cex = 2)
        points(mpgInput, model2pred(), col = "green", pch = 16, cex = 2)
    })
    
    output$pred1 <- renderText({
        model1pred()
    })
    
    output$pred2 <- renderText({
        model2pred()
    })
})