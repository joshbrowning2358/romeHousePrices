library(shiny)
library(data.table)
library(ggplot2)
library(ggmap)
library(romeHousePrices)

assignDirectory()

# Use this to initizialize parameters for testing
# input = list(minObs = 10)
# getData = function(){
#     load(paste0(dir, "/Data/", mioFile))
#     mioData = copy(finalData)
#     mioData[prezzo < 20, prezzo := prezzo * 1000]
#     mioData
# }

shinyServer(function(input, output, session) {

    ########################## DATA GENERATION ##########################    
    dataFiles = list.files(savingDir)
    mioFiles = dataFiles[grepl("^detail_Mio.*.RData", dataFiles)]
    mioDates = as.POSIXct(gsub("[^0-9]", "", mioFiles), format = "%Y%m%d%H%M%S")
    mioFile = mioFiles[mioDates == max(mioDates)]
    imbFiles = dataFiles[grepl("detail_Imb.*.RData", dataFiles)]
    imbDates = as.POSIXct(gsub("[^0-9]", "", imbFiles), format = "%Y%m%d%H%M%S")
    imbFile = imbFiles[imbDates == max(imbDates)]
    getData = reactive({
        load(paste0(savingDir, mioFile))
        mioData = copy(d)
        mioData = mioData[prezzo >= input$price[1] &
                          prezzo <= input$price[2], ]
        if(length(input$CAPfilter) >= 1){
            mioData = mioData[CAP %in% input$CAPfilter, ]
        }
        mioData
    })
    getTSData = reactive({
        newDir = paste0(savingDir, "/historical/data_by_cap/scraped_data/")
    })

    ########################## PLOT OUTPUTS ##########################
    
    myTheme = theme(
        axis.text.x = element_text(angle = 90)
    )
    
    output$zonaPlot = renderPlot({
        mioData = getData()[, zonaConta := .N, by = zona]
        ggplot(mioData[zonaConta > input$minObs, ],
               aes(x = zona, y = prezzo)) +
            geom_boxplot() + 
            myTheme
    })
    
    output$quartierePlot = renderPlot({
        mioData = getData()[, quartiereConta := .N, by = quartiere]
        ggplot(mioData[quartiereConta > input$minObs, ],
               aes(x = quartiere, y = prezzo)) +
            geom_boxplot() +
            myTheme
    })
    
    output$mapPlot = renderPlot({
        p = get_map(location=c(12.5, 41.91), zoom=12)
        p = ggmap(p)
        p + geom_point(data = getData(), aes(x = longitude, y = latitude,
                                           color = prezzo))
    })
    
    output$superficiePlot = renderPlot({
        mioData = getData()
        mioData[, superficieLevel := round(superficie/25)*25]
        p = ggplot(mioData, aes(x = prezzo, fill = as.factor(superficieLevel))) +
            myTheme
        if(input$fillBox){
            p = p + geom_bar(position = "fill")
        } else {
            p = p + geom_bar()
        }
        p
    })
    
    ########################## TABLE OUTPUTS ##########################
        
    ########################## DYNAMIC MENUS ##########################

})