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
            tabPanel(title = "Filters",
                     numericInput(inputId = "minObs",
                                  label = "Minimum Listings", value = 10),
                     sliderInput(inputId = "price",
                                 label = "Price Range",
                                 value = c(0, 20000), min = 0, max = 20000, step = 100)
            ),
            tabPanel(title = "Plots",
                     checkboxInput(inputId = "fillBox",
                                   label = "Fill Box Plot?",
                                   value = TRUE)
            ),
            tabPanel(title = "Area filter",
                     selectInput(inputId = "CAPfilter",
                                 label = "CAP Filter",
                                 choices = fread(paste0(savingDir, "allCaps.csv"))$x,
                                 multiple = TRUE)
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
