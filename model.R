
# ----------------------------
# Declare variables 
# ----------------------------

legend<-c(
  "#930A58",
  "#CA0A2F",
  "#FD111B",
  "#FD3E1D",
  "#FE7422",
  "#FEA829",
  "#FFC62E",
  "#FFE333",
  "#F9FC37",
  "#AAE32E",
  "#5DCB28",
  "#1DB224",
  "#21CB64",
  "#27E6B1",
  "#2DFFFF",
  "#1DACFD",
  "#105CFC",
  "#0B24FC")


legend2<-c(
  "#F4F4F4",
  "#FFC62E",
  "#FE7422",
  "#930A58")

legend3<-c(
  "#F4F4F4",
  "#105CFC")


vars <- list(
  'TMP_2maboveground' = 'SP1', 
  'RH_2maboveground' = 'SP1', 
  'SNOM_surface' = 'SP1', 
  'WIND_10maboveground' = 'SP1', 
  'PRES_meansealevel' = 'SP1',
  'LCDC_surface' = 'SP2',
  'MCDC_surface' = 'SP2',
  'HCDC_surface' = 'SP2'
)

getLegendColor <-function(d){
  return(d > 1000 ? '#800026' :
    d > 500  ? '#BD0026' :
    d > 200  ? '#E31A1C' :
    d > 100  ? '#FC4E2A' :
    d > 50   ? '#FD8D3C' :
    d > 20   ? '#FEB24C' :
    d > 10   ? '#FED976' :
    '#FFEDA0')
}


# ----------------------------
# load user info
# ----------------------------
loadInfo <- reactive({
  
  info <- paste("Météo France Arome", input$dateSelect)
  d <- input$dateSelect
  setD(d)
  return(info)
})



# ----------------------------
# load grib
# ----------------------------


loadDate <- reactive({
  d <- input$dateRun
  setD(d)
  return(format.Date(d,"%Y-%m-%d"))
})

loadRun <- reactive({
 
  info <- ""
  
  if(input$startDL){
    
    print("Load RUN")
    
    d <- getD()
    
    info <- paste("Load RUN : ", d)
    
    info <- loadGrib(d)
    
  }

  return(info)
})

loadGrib <- function(d){
  
  #print("loadGrib")
  return (importGrib(d))
}



# ----------------------------
# load data
# ----------------------------


loadData <- reactive({
  
  print("load data")
  
  d <- getD()

  hour <- input$hourSelect
  #hour <- getHour()
  setHour(hour)
  print(hour)
  
  pEcheances <- c("00H06H",
                  "07H12H",
                  "13H18H",
                  "19H24H",
                  "25H30H",
                  "31H36H",
                  "37H42H")
  
  ec <- 1
  if(hour >= 0 && hour <7){
    ec <- 1
    hour <- hour+1
    print("--1--")
  }else if(hour >= 7 && hour <13){
    ec <- 2
    hour <- hour-6
    print("--2--")
  }else if(hour >= 13 && hour <19){
    ec <- 3
    hour <- hour-12
    print("--3--")
  }else if(hour >= 19 && hour <24){
    ec <- 4
    hour <- hour-18
    print("--4--")
  }
  
  var <- input$varSelect
  pkg <- vars[var]
  
  #patch snow
  if (var == "SNOM_surface"){
    hour <- 1
    ec <- 1
  }
  
  p <- pEcheances[ec]
 
  inputfile <- paste0("netcdf/", d, "/AROME_", pkg, "_", d, "_", p,".nc")  
  
  #inputfile<-"netcdf/2016-04-08/AROME_SP1_2016-04-08_07H12H.nc"
  
  print(inputfile)
  print(paste0("hour :", hour))
  
  r <- raster(inputfile, varname=var, band =hour)
  setR(r)

  unite <- r@data@unit
  
  v <- getR()
  l <- legend
  na_c <- "transparent"
  
  if (var == "TMP_2maboveground"){
    
    # temprature à 2 metres
    
    #conver Kelvin(K) to degres celcus(°C)
    values(v) <- values(v)-273.15
    
    unite <- "°C"
    l <- rev(legend)
    
    dom <- values(v) #c(0,40)
    
    
  }else if (var == "WIND_10maboveground"){
    
    #convert m/s to km/h
    unite <- "km/h"
    values(v) <- values(v)*3.6
    
    l <- rev(legend)
    
    dom <- values(v) 
    
  }else if (var == "PRES_meansealevel"){
    
    #convert m/s to km/h
    unite <- "hPa"
    values(v) <- values(v)/100
    
    dom <- values(v)
  
  }else if (var == "LCDC_surface" ||
            var == "MCDC_surface" ||
            var == "HCDC_surface"){
    
    l <- legend3  
    na_c <- min(legend3)
    unite <- "%"
    dom <- values(v)
    
  }else if (var == "SNOM_surface"){
    
    l <- legend2
    dom <- values(v)
    
  }else{
    
    dom <- values(v)
  }
  
  #set new values
  setR(v)
  
  setLTitle(unite)
  
  pal <- colorNumeric(l, dom, na.color = na_c)
  setPal(pal)
  
  isolate(
    refreshMap()
  )

})



# ----------------------------
# Plots
# ----------------------------

loadPlots <- reactive({
  
  click <- input$map_click
  clat <- click$lat
  clng <- click$lng
  

  print(paste0("click on : ", clat, " - ", clng))
  
  inputfile<-"netcdf/2016-04-18/AROME_IP1_2016-04-08_07H12H.nc"
  var <- ""
  r <- raster(inputfile, varname=var, band =hour)
  
  
  plot(clat, clng)
  
})






