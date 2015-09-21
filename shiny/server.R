library(shiny)
library(data.table)
library(ggplot2)
library(ggmap)

if(Sys.info()[4] == "joshua-Ubuntu-Linux"){
    dir = "~/Documents/GitHub/romeHousePrices/"
} else {
    dir = "~/GitHub/romeHousePrices/"
}

# Use this to initizialize parameters for testing
# input = list(conversionRateA = 0.01, conversionRateB = 0.01, trafficA = 10000,
#         trafficB = 10000, maxTestDays = 365*2, replications = 100,
#         alphaTrad = .05, alphaSeq = .05, tau = .02)

shinyServer(function(input, output, session) {

    ########################## DATA GENERATION ##########################    
    dataFiles = list.files(paste0(dir, "/Data"))
    mioFiles = dataFiles[grepl("^detailMio.*.RData", dataFiles)]
    mioDates = as.POSIXct(gsub("[^0-9]", "", mioFiles), format = "%Y%m%d%H%M%S")
    mioFile = mioFiles[mioDates == min(mioDates)]
    immobFiles = dataFiles[grepl("^venditaDetail.*.RData", dataFiles)]
    mioDates = as.POSIXct(gsub("[^0-9]", "", mioFiles), format = "%Y%m%d%H%M%S")
    mioFile = mioFiles[mioDates == min(mioDates)]
    getData = reactive({
        load(paste0(dir, "/Data/", mioFile))
        mioData = copy(finalData)
        mioData[prezzio < 20, prezzio := prezzio * 1000]
        mioData
    })

    ########################## PLOT OUTPUTS ##########################
    
    myTheme = theme(
        axis.text.x = element_text(angle = 90)
    )
    
    output$zonaPlot = renderPlot({
        mioData = getData()[, zonaConta := .N, by = zona]
        ggplot(mioData[zonaConta > input$minObs, ],
               aes(x = zona, y = prezzio)) +
            geom_boxplot() + 
            myTheme
    })
    
    output$quartierePlot = renderPlot({
        mioData = getData()[, quartiereConta := .N, by = quartiere]
        ggplot(mioData[quartiereConta > input$minObs, ],
               aes(x = quartiere, y = prezzio)) +
            geom_boxplot() +
            myTheme
    })
    
    output$mapPlot = renderPlot({
        p = get_map(location=c(12.5, 41.91), zoom=12)
        p = ggmap(p)
        p + geom_point(data = getData(), aes(x = longitude, y = latitude,
                                           color = prezzio))
    })
    
    ########################## TABLE OUTPUTS ##########################
        
    ########################## DYNAMIC MENUS ##########################

})