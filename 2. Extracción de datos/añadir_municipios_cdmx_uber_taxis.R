library(geonames)
library(ggplot2)
library(dplyr)


cdmx.rutas <- read.csv("CDMX_Rutas.csv")

head(cdmx.rutas); tail(cdmx.rutas); summary(cdmx.rutas); dim(cdmx.rutas);


ggplot(cdmx.rutas, aes(x = trip_duration/60)) + geom_histogram(bins = 30, fill = "#ff325b") 
ggplot(cdmx.rutas, aes(x = dist_km)) + geom_histogram(bins = 30)

ggplot(cdmx.rutas, aes(x = trip_duration_hrs)) + geom_boxplot()
ggplot(cdmx.rutas, aes(x = dist_km)) + geom_boxplot()

origen <- cdmx.rutas[,c("pickup_longitude","pickup_latitude")]
destino <- cdmx.rutas[,c("dropoff_longitude","dropoff_latitude")]

###Pruebas multiple geocoding
#options(geonamesUsername="diegoar")
#options(geonamesUsername="cristophercano")
#options(geonamesUsername="crisarvizu")
#options(geonamesUsername="dgil")
options(geonamesUsername="alanvillasana")
#options(geonamesUsername="pepetellez")
# Initialize the data frame
#####==========ORIGEN=============####

1:500
501:1000
1001:1500
1501:2000
2001:2500
2501:3000
3001:3500
3501:4000
4001:4500
4501:5000
5001:5500
5501:6000
6001:6500
6501:7000
7001:7500
7501:8000
8001:8500
8501:8625


idx <- 3887

origen.sample <-origen[idx,]

head(origen.sample); tail(origen.sample); dim(origen.sample); 

iter = 0 # Loop para obtener el nombre de los municipios de origen 
for(i in idx){
  iter = iter + 1
  result <- GNfindNearbyPostalCodes(lat = origen.sample[iter,2], lng=origen.sample[iter,1],radius = "10", maxRows = "1", style = "MEDIUM")$adminName2
  cdmx.rutas$municipios_origen[i] <- result
}

write.csv(cdmx.rutas,"cdmx_rutas_municipios.csv")


#####============DESTINO=============######

idx <- 8502:8625

destino.sample <-destino[idx,]

# Loop para obtener el nombre de los municipios de destino 
iter = 0
for(i in idx){
  iter = iter + 1
  result <- GNfindNearbyPostalCodes(lat = destino.sample[iter,2], lng=destino.sample[iter,1],radius = "10", maxRows = "1", style = "MEDIUM")$adminName2
  cdmx.rutas$municipios_destino[i] <- result
}
print(i)



# Write a CSV file containing origAddress to the working directory

check1<-GNfindNearby(lat = 19.46011816213774, lng=-99.08603668212892)
check2<-GNfindNearbyPlaceName(lat = 19.46011816213774, lng=-99.08603668212892,radius = "10", maxRows = "2", style = "MEDIUM")
check3<-GNfindNearbyPostalCodes(lat = 19.46011816213774, lng=-99.08603668212892,radius = "10", maxRows = "2", style = "MEDIUM")
check4<-GNfindNearbyPostalCodes(lat = 19.43454, lng=-99.15186,radius = "10", maxRows = "2", style = "MEDIUM")
check5<-GNfindNearbyPostalCodes(lat = 19.43266, lng=-99.15497,radius = "10", maxRows = "2", style = "MEDIUM")
(check6<-GNfindNearbyPostalCodes(lat = 19.38224, lng=-99.20050,radius = "10", maxRows = "1", style = "MEDIUM"))


##visualization 

library(leaflet)

# create awesome icons
my_icons <- awesomeIcons(icon = data_all$icon,
                         markerColor = data_all$color,
                         library = "glyphicon")


m <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addMarkers(lng=origen[1:100,1], lat=origen[1:100,2],
             icon = list(iconUrl = 'https://icons.iconarchive.com/icons/artua/star-wars/256/Master-Joda-icon.png',
               iconSize = c(75, 75)))
             
m

base_de_datos <- st_read("http://rir.geoint.mx/RIR/archivos/101_coloniasCDMX.geojson")

m <- leaflet(mapaFactor, options = leafletOptions(zoomControl = FALSE, minZoom = 10)) %>%
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
              fillColor = "#FFFFE0" ) %>%
  addPolygons(data = mapa_cdmx, 
              color = "#444444",
              weight = 4, 
              opacity = 1,
              fill = F) %>% 
  addPolygons(data = mapa_municipios, 
              color = "#444444",
              weight = 2, 
              opacity = 1,
              fill = F) %>% 
  addCircleMarkers(lng=origen[1:5000,1], lat=origen[1:5000,2], radius = 1, opacity = 0.05) %>%
  addCircleMarkers(lng=destino[1:5000,1], lat=destino[1:5000,2], radius = 1, color = "#ff325b", opacity = 0.05) 

m

#addProviderTiles("Stamen.Watercolor")
#addProviderTiles(providers$Esri.WorldImagery)
#addProviderTiles(providers$OpenTopoMap)
#addProviderTiles(providers$OpenStreetMap)
#addProviderTiles("CartoDB.Positron")
#addProviderTiles("Esri.WorldTerrain")

###Agrupando

library("maps")
library("ggplot2")

ggplot(cdmx.rutas, aes(x=pickup_longitude[1:100,1], y=pickup_latitude[1:100,2])) +
  geom_point(size=1, color = "blue") +
  scale_x_continuous(limits=c( -99.507504, -98.722426)) +
  scale_y_continuous(limits=c(18.980224, 19.60)) +
  theme_map()
