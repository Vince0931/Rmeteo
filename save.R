#contourr<-rasterToContour(r)

# 45.821551 5.649719
# 45.409556 6.124448

#ext <- extent(5.649719, 6.124448, 45.409556, 45.821551)
#r <- crop(r, ext)	

#r <- aggregate(r, fact =20) # degrade la qualite
#r <- disaggregate(r,  fact =1) # ameliore la qualite


# Declare an explicit environment to hold the variable
e1 <- new.env()

# Sets the value of the variable
setR <- function(value) {
  assign("r", value, env=e1)
}

# Gets the value of the variable
getR <- function() {
  return(get("r", e1))
}


setR(4)
getR()

# requete téléchargement 

http://dcpc-nwp.meteo.fr/services/PS_GetCache_DCPCPreviNum?token=
  __5yLVTdr-sGeHoPitnFc7TZ6MhBcJxuSsoZp6y0leVHU__
&model=AROME
&grid=0.025
&package=SP1
&time=00H06H
&referencetime=2016-03-29T12:00:00Z




selectInput("select", label = h3("Selecteur de layer"), 
            choices = list("Température à 2m" = 'TMP_2maboveground', 
                           "Humidité à 2m" = 'RH_2maboveground',
                           "Neige" = 'SNOM_surface',
                           "Vend à 10m" = 'WIND_10maboveground',
                           "Pression" = 'PRES_meansealevel'
            ), selected = 'TMP_2maboveground')
)

