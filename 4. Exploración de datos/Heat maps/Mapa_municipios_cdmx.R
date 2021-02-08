# Librerias utilizadas
library(sf)                                 # Leer información geográfica
library(leaflet)                            # Hacer mapas interactivos
library(tidyverse)        
library(knitr)

#opts_chunk$set(fig.width=10, fig.height=8)
# Manejo de Bases de Datos
niveles <- function(x) levels(as.factor(x)) # Funcion propia para explorar categorias
source("https://raw.githubusercontent.com/JuveCampos/DataVizRepo/master/R%20-%20leaflet/Mapas_zona_metropolitana/Norte.R")                      # Funcion para incluir rosa de los vientos en los mapas


## Leemos informacion 

# Mapa de indicadores del Atlas de Riesgo de la CDMX
mapa <- st_read("http://atlas.cdmx.gob.mx/datosAbiertos/INDICADORES_AGEB.geojson", quiet = T) %>% 
  st_transform(crs = 4326)

# Mapa de municipios de la CDMX
mapa_municipios <- st_read("https://github.com/JuveCampos/Shapes_Resiliencia_CDMX_CIDE/raw/master/Zona%20Metropolitana/EdosZM.geojson", quiet = T) %>% 
  filter(CVE_ENT == "09")

# Mapa de la entidad de la Ciudad de México
mapa_cdmx <- st_read("https://github.com/JuveCampos/Shapes_Resiliencia_CDMX_CIDE/raw/master/Zona%20Metropolitana/EstadosZMVM.geojson", quiet = T)[3,]




# Modificamos Base
mapa$ENTIDAD <- "Ciudad de México"
mapa$ALCALDIA <- as.factor(mapa$ALCALDIA)
levels(mapa$ALCALDIA)[c(2, 3, 5, 13, 16)] <- c("Benito Juárez", "Coyoacaán", "Cuauhtémoc", "Tláhuac", "Álvaro Obregón")

# Modificamos base, para quedarnos con factores
a <- lapply(mapa, class) %>% unlist()
mapaFactor <- mapa[,a == "factor"]


# Funcion para cambiar varias variables a la vez.
intensidad <- function(a) a <- factor(a, levels = c("Muy Alto","Alto","Medio","Bajo", "Muy Bajo", "N/D"))

label = paste0("<b style = 'color: green;'>AGEB: ", mapaFactor$CVEGEO, "</b>", "<br>",  mapaFactor$ALCALDIA)

paleta <- colorFactor("Blues", mapaFactor$PRECIPITAC, reverse = T)
popup <- paste0(mapaFactor$PRECIPITAC)

#18.980224, -99.507504
#19.563719, -98.722426

library(leaflet.extras)

(map <- leaflet(mapaFactor, options = leafletOptions(zoomControl = T, minZoom = 10)) %>%    #
    addProviderTiles("CartoDB.Positron") %>% 
    setMaxBounds(lng1 = -99.507504, lat1 = 18.980224, lng2 = -98.722426, lat2 = 19.60) %>% 
    addPolygons(highlightOptions = highlightOptions(color = "white"),
                color = "#444444", 
                weight = 0.2, 
                smoothFactor = 0.5, 
                opacity = 1, 
                fillOpacity = 0.8
                ) ) %>%    #
    addPolygons(data = mapa_cdmx, 
                color = "#444444",
                weight = 4, 
                opacity = 1,
                fill = F
    ) %>% 
    addPolygons(data = mapa_municipios, 
                color = "#444444",
                weight = 2, 
                opacity = 1,
                fill = F
    ) %>%  # Add default OpenStreetMap map tiles
  addCircleMarkers(lng=origen[1:5500,1], lat=origen[1:5500,2], radius = .5, opacity = 0.1) %>%
  addCircleMarkers(lng=destino[1:5500,1], lat=destino[1:5500,2], radius = .5, color = "#ff325b", opacity = 0.1) 



(map <- leaflet(mapaFactor, options = leafletOptions(zoomControl = FALSE, minZoom = 10)) %>%    #
    addProviderTiles("CartoDB.Positron") %>% 
    setMaxBounds(lng1 = -99.507504, lat1 = 18.980224, lng2 = -98.722426, lat2 = 19.60) %>% 
    addPolygons(highlightOptions = highlightOptions(color = "white"),
                color = "#444444", 
                weight = 0.2, 
                smoothFactor = 0.5, 
                opacity = 1, 
                popup = popup,
                label = lapply(label, htmltools::HTML), 
                fillOpacity = 0.8, 
                fillColor = ~paleta(mapa$PRECIPITAC) ) %>%    #
    addPolygons(data = mapa_cdmx, 
                color = "#444444",
                weight = 4, 
                opacity = 1,
                fill = F
    ) %>% 
    addPolygons(data = mapa_municipios, 
                color = "#444444",
                weight = 2, 
                opacity = 1,
                fill = F
    ) %>% 
    #addScaleBar(position = "bottomright") %>%   
    addLegend(position = "bottomright", 
              pal = paleta, 
              values = mapa$PRECIPITAC,     #
              title = "<div a style = 'color:red;'>Peligro:</div>Precipitacion", #
              opacity = 1,
              labFormat = labelFormat(suffix = " ")) )   %>%  # Add default OpenStreetMap map tiles
  addCircleMarkers(lng=origen[1:5500,1], lat=origen[1:5500,2], radius = .5, opacity = 0.05) %>%
  addCircleMarkers(lng=destino[1:5500,1], lat=destino[1:5500,2], radius = .5, color = "#ff325b", opacity = 0.05)

