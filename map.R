
# ----------------------------
# Create the map
# ----------------------------

output$map <- renderLeaflet({
  
  # HikeBike.HillShading # 'Tiles &copy; Esri &mdash; Source: Esri', # simple relief map
  # Esri.WorldImagery # sat map
  # CartoDB.Positron
  # CartoDB.PositronNoLabels
  # CartoDB.PositronOnlyLabels
  
  m <- leaflet() %>%
    setView(lng=1.8, lat=47, zoom=6)
  
  m <- addTiles(m, urlTemplate = "http://{s}.tiles.wmflabs.org/hillshading/{z}/{x}/{y}.png",
                attribution = '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> &copy; <a href="http://cartodb.com/attributions">CartoDB</a>',
                options = list(
                  zIndex = 1
                ))
  m <- addTiles(m, urlTemplate = "http://{s}.basemaps.cartocdn.com/light_only_labels/{z}/{x}/{y}.png",
                options = list(
                  zIndex = 10
                ))
})



# ----------------------------
# refresh map
# ----------------------------

refreshMap <- function(){
  
  zoom <- input$map_zoom
  bbox <- input$map_bounds
  
  if (is.null(bbox))
    return()
  
  isolate({
    
    map <- leafletProxy("map")
    map %>% clearPopups()
    map %>% clearImages()
    map %>% clearControls()
  
    #TODO   
    #map %>% removeShape("ct_polyline")
  
    drawRasterImage(bbox, zoom, map)
  })
}

# ----------------------------
# Observe map zoom
# ----------------------------

observe({
  refreshMap()
})

# ----------------------------
# draw image raster
# crop on bbox
# disaggregate / zoom
# ----------------------------

lz <- list( c(0,5),
            c(1,4),
            c(2,3),
            c(3,2),
            c(4,2),
            c(5,1),
            c(6,1),
            c(7,1),
            c(8,2),
            c(9,2),
            c(10,3),
            c(11,4))


drawRasterImage <- function(bbox, zoom, map){
  
  r <- getR()
  
  if (!is.null(r)){
    
    pal <- getPal()
    unite <- getLTitle()
    
    ext <- extent(bbox$west, bbox$east, bbox$south, bbox$north)
    
    if(intersect(ext)){
      r2 <- crop(r, ext)
      
      if (zoom < 11){
        res <- lz[[zoom+1]][2]
        
        if(zoom < 5) {
          r2 <- aggregate(r2,res, method='bilinear')
        }else if(zoom > 5 && zoom < 11 ){
          r2 <- disaggregate(r2,res, method='bilinear')
        }
      }else{
        r2 <- disaggregate(r2,4, method='bilinear')
      }
      
      #TODO 
      #contourr <- rasterToContour(r2)
      
      map %>% 
        addRasterImage(r2, colors = getPal(), opacity = 0.65, project=FALSE) %>%
        #TODO 
        #addPolylines(layerId = "ct_polyline", data=contourr,fillOpacity=5,fillColor = "transparent",opacity=10,weight=1) %>%
        addLegend(pal = pal, values = values(r), title = unite)
      
    }
    
  }
  
}

# ----------------------------
# Utils
# ----------------------------

# rect intersect
intersect <- function(ext){
  r <- getR()
  return (r@extent@xmax >= ext@xmin &&
          r@extent@xmin <= ext@xmax &&
          r@extent@ymax >= ext@ymin &&
          r@extent@ymin <= ext@ymax)   
}  

