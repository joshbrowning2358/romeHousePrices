library(shiny)
library(data.table)
library(ggplot2)
library(ggmap)
library(romeHousePrices)
library(ggvis)

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
        mioData = mioData[superficie <= input$superficie[2] &
                    superficie >= input$superficie[1], ]
        mioData = mioData[bagni <= input$bagni[2] &
                    bagni >= input$bagni[1], ]
        mioData = mioData[locali <= input$locali[2] &
                    locali >= input$locali[1], ]
        mioData = mioData[prezzo <= input$prezzo[2] &
                          prezzo >= input$prezzo[1], ]
        mioData = mioData[CAP %in% input$capFilter, ]
        mioData
    })

    ########################## PLOT OUTPUTS ##########################
    
    myTheme = theme(
        axis.text.x = element_text(angle = 90)
    )
    
#     output$historyTS = renderPlot({
#         tsData = getTSData()
#         tsSumm = tsData[, list(price = mean(price)), by = c("cap", "date")]
#         tsSumm %>% ggvis(~date, ~price) %>%
#             group_by(cap) %>%
#             layer_lines()
#         ggplot(tsSumm, aes(x = date, y = price)) +
#             geom_line(aes(group = cap), alpha = .2) +
#             scale_y_log10()
#     })
    
    ########################## TABLE OUTPUTS ##########################
    output$tabSummary = renderTable({
        data = getData()
        out = data[, list(
            prezzo     = mean(prezzo, na.rm = TRUE),
            superficie = mean(superficie, na.rm = TRUE),
            locali     = mean(locali, na.rm = TRUE),
            bagni      = mean(bagni, na.rm = TRUE)
        ), by = CAP]
        out
    })
        
    ########################## DYNAMIC MENUS ##########################

})