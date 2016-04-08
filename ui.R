
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Spin Coating Data and Prediction"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      conditionalPanel('input.panels === "Fit"',
                       actionButton("btnReload", "Reload Data"),
                       helpText(textOutput("txtLastReload"))),
      conditionalPanel('input.panels === "Speed"',
                       selectInput("selConc", 
                                   label = "Concentration",
                                   choices = list("0.5 %" = 0.5, "1.0 %" = 1, 
                                                  "1.5 %" = 1.5, "2.0 %" = 2),
                                   selected = 2),
                       selectInput("selTime", 
                                   label = "Spinning Time",
                                   choices = list("0.5 min" = 0.5, "1.0 min" = 1,
                                                  "2.0 min" = 2, "4.0 min" = 4),
                                   selected = 1),
                       sliderInput("sldHeight", 
                                   label = "Desired Height:",
                                   min = 10, max = 200, value = 50)),
      conditionalPanel('input.panels === "Histograms"',
                       uiOutput('target'),
                       uiOutput('substrate'))
      
    ),

    # Show a plot of the generated distribution
    mainPanel(
      mainPanel(
        tabsetPanel(
          id = 'panels',
          tabPanel('Fit',
                   h4("Summary of fit"),
                   tableOutput("summary")),
          tabPanel('Speed',
                   h4("RPM Needed for the desired parameters"),
                   textOutput("txtNeededSpeed")),
          tabPanel('Histograms',
                   textOutput("txtResults"),
                   plotOutput("histogram"))
        )
      )
    )
  )
))
