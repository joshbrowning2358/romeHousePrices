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
                     sliderInput(inputId = "superficie",
                                 label = "Superficie",
                                 value = c(0, 500), min = 0, max = 3000, step = 10),
                     sliderInput(inputId = "bagni",
                                 label = "Bagni",
                                 value = c(0, 3), min = 0, max = 10, step = 1),
                     sliderInput(inputId = "locali",
                                 label = "Locali",
                                 value = c(0, 3), min = 0, max = 20, step = 1),
                     sliderInput(inputId = "prezzo",
                                 label = "Prezzo",
                                 value = c(0, 2000), min = 0, max = 10000, step = 50),
                     selectInput(inputId = "capFilter",
                                 label = "CAP",
                                 choices = fread(paste0(savingDir, "allCaps.csv"))$x,
                                 multiple = TRUE)
            ),
            tabPanel(title = "Plot Variables",
                     selectInput(inputId = "xVar",
                                 label = "Horizontal Variable",
                                 choices = c("superficie", "prezzo",
                                             "locali", "bagni")),
                     selectInput(inputId = "yVar",
                                 label = "Vertical Variable",
                                 choices = c("prezzo", "superficie",
                                             "locali", "bagni"))
            )
        ),
        tabBox(title = "Summaries",
            tabPanel(title = "Table",
                     tableOutput("tabSummary")
            ),
            tabPanel(title = "Horizontal Summary",
                     plotOutput("horizontalPlot")
            ),
            tabPanel(title = "Vertical Summary",
                     plotOutput("verticalPlot")
            ),
            tabPanel(title = "Scatterplot",
                     plotOutput("scatterPlot")
            ),
            tabPanel(title = "Map",
                     plotOutput("mapPlot")
            )
        )
    )
)
