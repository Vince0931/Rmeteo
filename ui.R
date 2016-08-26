library(shiny)
library(leaflet)


# http://shiny.rstudio.com/gallery/superzip-example.html

firstVar <- "TMP_2maboveground"

vars <- list(
  "Température à 2m" = 'TMP_2maboveground', 
  "Humidité à 2m" = 'RH_2maboveground',
  "Neige" = 'SNOM_surface',
  "Vend à 10m" = 'WIND_10maboveground',
  "Pression" = 'PRES_meansealevel',
  "Couverture nuageuse Basse" = "LCDC_surface",
  "Couverture nuageuse Moyenne" = "MCDC_surface",
  "Couverture nuageuse Haute" = "HCDC_surface"

)

shinyUI(navbarPage("R Météo", id="nav",
                   
                   tabPanel("Carte interactive",
                            div(class="outer",
                                
                                tags$head(
                                  # Include custom CSS
                                  includeCSS("styles.css")
                                ),
                                
                                leafletOutput("map", width="100%", height="100%"),
                                
                                absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                              draggable = TRUE, top = 60, left = 50, right = "auto", bottom = "auto",
                                              width = 330, height = "auto",
                                              
                                              h3(textOutput("infoUser")),
                                              selectInput("varSelect", "Selectionner un layer", vars, firstVar),
                                              dateInput("dateSelect", "date"),
                                              sliderInput("hourSelect","heures", min = 0, max = 23, value = 12),
                                            
                                              actionButton("backH", "<"),
                                              actionButton("nextH", ">")#,
                                              
                                              #plotOutput("clickPlot", height = 200)
                                ),
                                
                                #absolutePanel(id = "plots", class = "panel panel-default", fixed = TRUE,
                                #              draggable = TRUE, top = 60, left = "auto", right = 50, bottom = "auto",
                                #              width = 330, height = "auto",
                                #              h3("Altitude / Vents")
                                #),
                                textOutput("layer"),
                                
                                tags$div(id="cite",
                                         'R Météo ', tags$em('Donnée Méteo France modèle Arome'), ' © Vincent Cau 2016.'
                                )
                            )
                   ),
                   tabPanel("Admin",
                            fluidRow(
                              
                              column(3,
                                     dateInput("dateRun", "date"),
                                     actionButton("startDL", "Telechargement")
                              ),
                              column(5,
                                     textOutput("dateInfo"),
                                     textOutput("runInfo")
                              )
                              
                            )
                   )
                   
))


