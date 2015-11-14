library(shiny)
library(data.table)
library(ggplot2)
library(ggmap)
library(romeHousePrices)
library(ggvis)

assignDirectory()

# Use this to initizialize parameters for testing
# input = list(minObs = 10, superficie = c(0, 500), bagni = c(0, 5),
#              locali = c(0, 10), prezzo = c(0, 2000),
#              capFilter = c("00145", "00186"), xVar = "superficie",
#              yVar = "prezzo")

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
    
    output$horizontalPlot = renderPlot({
        data = getData()
        out = ggplot(data, aes_string(x = "CAP", y = input$xVar)) +
            geom_boxplot()
        print(out)
    })
    
    output$verticalPlot = renderPlot({
        data = getData()
        out = ggplot(data, aes_string(x = "CAP", y = input$yVar)) +
            geom_boxplot()
        print(out)
    })
    
    output$scatterPlot = renderPlot({
        data = getData()
        makeEllipse = function(data, x, y){
            coords = try(car::dataEllipse(x = data[[x]], y = data[[y]]))
            if(is(coords, "try-error")){
                out = data.frame(x = 1, y = 1)
                out = out[-1, ]
                return(out)
            }
            data.frame(coords[[2]])
        }
        capData = split(data, data$CAP)
        ellipse = lapply(capData, makeEllipse, x = input$xVar, y = input$yVar)
        ellipse = lapply(1:length(ellipse), function(i){
            out = ellipse[[i]]
            out$CAP = names(ellipse)[i]
            out
        })
        ellipse = do.call("rbind", ellipse)
        out = ggplot(data, aes_string(x = input$xVar, y = input$yVar)) +
            geom_point(aes(color = CAP)) +
            geom_polygon(data = ellipse, aes(x = x, y = y, fill = CAP),
                         alpha = 0.1)
        print(out)
    })
    
    output$mapPlot = renderPlot({
        ## This would be cool as a shaded region, but we'll need the shape files
        ## for the CAPs first...  Also, we should allow the user to determine 
        ## which variable to plot (price, superficie, ...).  It'd be really cool
        ## to make it interactive as well: hover and it tells you
        ## max/min/average/median...
        data = getData()
        out = ggplot(data, aes(x = longitude, y = latitude, color = prezzo)) +
            geom_point()
    })
    
    ########################## TABLE OUTPUTS ##########################
    output$tabSummary = renderTable({
        data = getData()
        out = data[, list(
            prezzo     = mean(prezzo, na.rm = TRUE),
            superficie = mean(superficie, na.rm = TRUE),
            locali     = mean(locali, na.rm = TRUE),
            bagni      = mean(bagni, na.rm = TRUE),
            count      = .N
        ), by = CAP]
        out
    })
        
    ########################## DYNAMIC MENUS ##########################

})