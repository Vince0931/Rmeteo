library(shiny)
library(leaflet)
library(raster)


shinyServer(function(input, output, session) {
  
  # Declare an explicit environment to hold the variable
  e1 <- new.env()
  
  setR <- function(value) {assign("r", value, env=e1)}
  getR <- function() {return(get("r", e1))}
  setR(NULL)
  
  setPal <- function(value) {assign("pal", value, env=e1)}
  getPal <- function() {return(get("pal", e1))}
  setPal(NULL)
  
  setLTitle <- function(value) {assign("ltitle", value, env=e1)}
  getLTitle <- function() {return(get("ltitle", e1))}
  setLTitle("")
  
  setInit <- function(value) {assign("init", value, env=e1)}
  getInit <- function() {return(get("init", e1))}
  setInit(FALSE)
  
  setHour <- function(value) {assign("hour", value, env=e1)}
  getHour <- function() {return(get("hour", e1))}
  setHour(12)
  
  setD <- function(value) {assign("d", value, env=e1)}
  getD <- function() {return(get("d", e1))}
  setD(format.Date(Sys.Date(),"%Y-%m-%d"))
  
  
  # ----------------------------
  # import R files
  # ----------------------------
  source("model.R", local=TRUE)
  source("map.R", local=TRUE)
  source("script/script_import.R", local=TRUE)
  
  
  
  # ----------------------------
  # OUTPUT
  # ----------------------------
  
  output$layer <- renderText({
    loadData()
    return("")
  })
  
  output$infoUser <- renderText({
    loadInfo()
  })

  output$dateInfo <- renderText({
    loadDate()
  })
  
  output$runInfo <- renderText({
    loadRun()
  })
  
  output$clickPlot <- renderPlot({
    loadPlots()
  })
  
  
  observe({
    hour <- getHour()
    
    if(input$backH){
      hour = hour-1
    }
    if(hour < 0){
      hour <- 0
    }
    
    setHour(hour)
    updateSliderInput(session, "hourSelect", value = hour)
  })
  
  observe({
    hour <- getHour()
    
    if(input$nextH){
      hour = hour+1
    }
    if(hour > 23){
      hour <- 23
    }
    
    setHour(hour)
    updateSliderInput(session, "hourSelect", value = hour)
  })
  
})


