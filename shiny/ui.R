library(shiny)
library(shinydashboard)

ui <- dashboardPage(
    
    dashboardHeader(title = "CAP Summaries"),
    
    dashboardSidebar(disable = TRUE),
    
    dashboardBody(
        tabBox(
            title = "Inputs",
            # The id lets us use input$tabset1 on the server to find the current tab
            id = "General",
            tabPanel(title = "General",
                     numericInput(inputId = "minObs",
                                  label = "Minimum Listings", value = 10)
#                      numericInput(inputId = "maxTestDays",
#                                   label = "Maximum number of days to run test for",
#                                   value = 30, min = 1, max = 365*30),
#                      numericInput(inputId = "conversionRateA",
#                                   label = "Conversion rate for group A",
#                                   value = .01, min = 0, max = .5),
#                      sliderInput(inputId = "lift",
#                                  label = "Percentage lift of B over A",
#                                  value = 0, min = -30, max = 30, step = 1),
#                      numericInput(inputId = "trafficA",
#                                   label = "Daily Traffic for A group",
#                                   value = 1000, min = 10, max = 1000000),
#                      numericInput(inputId = "trafficB",
#                                   label = "Daily Traffic for B group",
#                                   value = 1000, min = 10, max = 1000000),
#                      numericInput(inputId = "yScale",
#                                   label = "Scale for y-axis",
#                                   value = .05, min = 0, max = 10)
            ),
            tabPanel(title = "Traditional",
                     sliderInput(inputId = "alphaTrad",
                                 label = "alpha (confidence level)",
                                 value = .05, min = 0.01, max = .2, step = .01)
            )
        ),
        tabBox(title = "Plots",
            tabPanel(title = "Zona",
                     plotOutput("zonaPlot", height = 600)
            ),
            tabPanel(title = "Quartiere",
                     plotOutput("quartierePlot", height = 600)
            ),
            tabPanel(title = "Mappa",
                     plotOutput("mapPlot", height = 600)
            ),
            tabPanel(title = "Superficie",
                     plotOutput("superficiePlot", height = 600)
            )
#         box(title = "Summary Statistics",
#             tableOutput("summaryTable")
#         )
        )
    )
)
