

#mac
#curl "http://127.0.0.1:8000" -o "outfile"

#linux
#wget "http://127.0.0.1:8000" "outfile"


#https://donneespubliques.meteofrance.fr/?fond=donnee_libre&token=
#  __5yLVTdr-sGeHoPitnFc7TZ6MhBcJxuSsoZp6y0leVHU__
#&model=AROME
#&grid=0.025
#&package=SP1
#&time=00H06H
#&referencetime=2016-03-31
#T03%3A00%3A00Z


#urlMeteo <- "https://donneespubliques.meteofrance.fr/?fond=donnee_libre&token="

#date <- "2016-04-13" 


importGrib <- function(date){
  
  t <- Sys.time()
  
  #URLproj <- "/opt/shiny-server/samples/sample-apps/rmeteo/"
  
  URLproj <- "" # <--- debug
  
  
  urlMeteo <- "http://dcpc-nwp.meteo.fr/services/PS_GetCache_DCPCPreviNum?token="
  token <-  "__5yLVTdr-sGeHoPitnFc7TZ6MhBcJxuSsoZp6y0leVHU__"
  modelRef <- "&model="
  model <- "AROME"
  griddef <- "&grid=0.025"
  pack <- "&package="
  # p <- "SP2"
  timeScale <- "&time="
  #time <- "00H06H"
  refTime <- "&referencetime="
  d <-  date
  Heure <- "T03%3A00%3A00Z"
  
  cmd <- ""
  
  pOption <- c("SP1", 
               "SP2", 
               "SP3")#,
               #"IP1",
               #"IP2",
               #"IP3")
  
  pEcheances <- c("00H06H",
                  "07H12H",
                  "13H18H",
                  "19H24H")
                  
                  #"25H30H",
                  #"31H36H",
                  #"37H42H")
  
  dCible <- paste0(URLproj, "grib/", d)
  
  dirs <- list.dirs(dCible, recursive = TRUE)
  
  if(length(dirs)==0){
    
    #create dir grib and netcdf
    
    #print("create dir grib and netcdf")
    cmd <- paste0("mkdir ", URLproj, "grib/", d)
    #print(cmd)
    r <-system(cmd, wait=TRUE)
    cmd <- paste0("mkdir ", URLproj, "netcdf/", d)
    r <-system(cmd, wait=TRUE)

    #import all grib
    
    for (j in 1:length(pOption)){
      p <- pOption[j]
      #p <- pOption[1]
      
      for (i in 1:length(pEcheances)){
        
        time<-pEcheances[i]
        #time<-pEcheances[1]
        
        URL <- paste0(urlMeteo, token, modelRef, model, griddef, pack, p, timeScale, time, refTime, d, Heure)

        name <- paste0(model, "_", p, "_", d, "_", time)
        
        #print("download grib2")
        cmd <- paste0("curl '",  URL, "' -o ", URLproj, "grib/", d, "/", name, ".grib2")
        r <- system(cmd, wait=TRUE)
        #print(cmd)
        
        #print("convert grib2 to netcdf")
        cmd <-paste0("export PATH=$PATH:/usr/local/lib/wgrib2 && wgrib2 ", URLproj, "grib/", d, "/", name, ".grib2", " -netcdf ", URLproj, "netcdf/", d, "/", name, ".nc")
        r <- system(cmd, wait=TRUE)
        #print(cmd)
      }
      
    }
    
    t <-  Sys.time() - t
    
    info <- paste("Finish Load & convert RUN : ", d, " - ", round(t) , " s")
    
  }else{
    info <- "file already exist"
  }
  
  return(info)
}

