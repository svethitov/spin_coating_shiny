
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)
source("helpers.R")


shinyServer(function(input, output) {
  
  loadData <- reactive({
    input$btnReload
    output$txtLastReload <- renderText({
      paste("Last Reload was on ",
            Sys.time(), " Server Time")
    })
    fullData()
  })
  
  makeFit <- reactive({
    fitting(data = loadData())
  })
  
  targets <- reactive({
    targets <- unique(loadData()$target)
    return(targets[targets != -1])
  })
  
  substrates <- reactive({
    subs <- levels(loadData()$substrate)
    return(c("All", subs))
  })
  
  # renders the options for target height
  output$target = renderUI({
    selectInput('hTarget', 'Target Height', targets())
  })
  
  # renders the options for the substrate
  output$substrate = renderUI({
    selectInput('substrate', 'Substrate used', substrates())
  })
  
  # Generate a summary of the fit
  output$summary <- renderTable({
    my_table <- as.data.frame(round(summary(makeFit())$coef,digits = 3))
    return(my_table)
  })
  
  output$txtNeededSpeed <- renderText({
    speed <- (makeFit()$m$getPars()[1] * (as.numeric(input$selConc)^makeFit()$m$getPars()[2]) / (as.numeric(input$sldHeight) * (as.numeric(input$selTime)^makeFit()$m$getPars()[4]) ) )^(1/makeFit()$m$getPars()[3])
    paste("The speed you will need is ", round(speed, digits = 0), "rpm")
  })
  
  output$txtResults <- renderText({
    x <- subsetData(hTarget = input$hTarget, 
                    tSubstrate = input$substrate, 
                    data = loadData())
    paste("Mean: ", round(mean(x$thickness),digits = 2), "nm", 
          "+/-", round(sd(x$thickness),digits = 2), "nm", 
          "(", round((sd(x$thickness)/mean(x$thickness))*100,digits = 2), " %)",
          " from ", length(x$thickness), " samples")
  })
  
  output$histogram <- renderPlot({
    x <- subsetData(hTarget = input$hTarget, 
                    tSubstrate = input$substrate, 
                    data = loadData())
    gg <- ggplot(x, aes(x=thickness)) + 
      geom_histogram(binwidth=1, colour=I("blue"), 
                     aes(y=..density.., fill=..count..)) + 
      scale_fill_gradient("Count", low="lightblue", high="darkblue") + 
      stat_function(fun=dnorm, color="red", args=list(mean=mean(x$thickness), 
                                                      sd=sd(x$thickness)))
    gg
  })
})
