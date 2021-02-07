# Reverse Geocoding

### Descripción
```Reverse Geocoding``` es el proceso de encontrar una dirección, una calle, u alguna infromación a partir del par longitud/latitud. Esta tarea se puede llevar a cabo mediante
el uso de la libreria GeoNames la cual ofrece un aplio rango de herramientas para esta tarea por ejemo:

- ```Find nearby postal codes```: Busca codigos postales y nombres de lugares para el par longitud/latitud dentro del radio determinado

### Objetivo
Localizar los municipios de **origen** y **destino** a partir del par **lat/lng** de la base de datos de viajes por Taxi y Uber dentro de la CDMX

### Codigo

Cargamos las librerias ```geonames``` y ```ggplot2```. Cargamos la base de datos y realizamos una inspección
```R
### Geonames es una libreria de libre acceso y requiere crear un cuenta
library(geonames)
library(ggplot2)
library(dplyr)

### Cargamos la base de datos
cdmx.rutas <- read.csv("cdmx_transporte_raw.csv")

### Vemos la información de la base de datos
head(cdmx.rutas); tail(cdmx.rutas); summary(cdmx.rutas); dim(cdmx.rutas);
```
Seleccionamos los orgines y destino

```Origen```

```R
### Origen
origen <- cdmx.rutas[,c("pickup_longitude","pickup_latitude")]
head(origen)
```
![1  origen lat lng](https://user-images.githubusercontent.com/71915068/107132865-947dd100-68a8-11eb-867c-d0396c8cdd26.PNG)

```Destino```

```R
### Destino
destino <- cdmx.rutas[,c("dropoff_longitude","dropoff_latitude")]
head(destino)
```
![2  destino lat lng](https://user-images.githubusercontent.com/71915068/107133059-3356fd00-68aa-11eb-89f1-247d16a1b0c4.PNG)


Codigo para extrae los municipios  de ```origen```

```R
### Mediante GNfindNearbyPostalCodes realizamos una prueba para obter el municipio
### Para utilizar geonames creamos una cuenta previamente
options(geonamesUsername="cristophercano")

### Municipio de origen
(mun.origen.1<-GNfindNearbyPostalCodes(lat = origen[1,2], lng=origen[1,1],radius = "10", maxRows = "1", style = "MEDIUM"))
```
![3  mun destino lat lng](https://user-images.githubusercontent.com/71915068/107133144-c42dd880-68aa-11eb-833a-61f63a72e0a4.PNG)

```R
### Almacenamos solo el nombre del municipio de origen
(nombre.mun.o <- mun.origen.1$adminName2)

##La variable que nos devuelve es adminName2
(paste("municipio de origen: ",nombre.mun.o))

```
![4 nom mun destino lat lng](https://user-images.githubusercontent.com/71915068/107133190-3a323f80-68ab-11eb-858e-b072889a456b.PNG)


Codigo para extrae los municipios  de ```destino```
```R
### Municipio de destino
(mun.destino.1<-GNfindNearbyPostalCodes(lat = destino[1,2], lng=destino[1,1], radius = "10", maxRows = "1", style = "MEDIUM"))
```

![5  nom mun destino lat lng](https://user-images.githubusercontent.com/71915068/107133206-5d5cef00-68ab-11eb-9b61-8f9beae7b97a.PNG)

```R
### Almacenamos solo el nombre del municipio de origen
(nombre.mun.d <- mun.destino.1$adminName2)

##La variable que nos devuelve es adminName2
(paste("municipio de destino: ",nombre.mun.d))
```
![6  nom mun destino lat lng](https://user-images.githubusercontent.com/71915068/107133224-7fef0800-68ab-11eb-9943-cbaa13f6b2f0.PNG)


### Podemos corrovorar esta información trazando la ruta en un mapa mediante leaflet y osrmRoute

```R
library(leaflet)
library(osrm)
library(sf)


a <- c(origen[1,1],origen[1,2])
b <- c(destino[1,1],destino[1,2])

r<-osrmRoute(src = a,
             dst = b,
             returnclass = "sf", overview = "full",
             osrm.profile = "car")
r

plot(st_geometry(r), add = TRUE)

# Mapa de municipios de la CDMX
mapa_municipios <- st_read("https://github.com/JuveCampos/Shapes_Resiliencia_CDMX_CIDE/raw/master/Zona%20Metropolitana/EdosZM.geojson", quiet = T) %>% 
  filter(CVE_ENT == "09")

# Mapa de la entidad de la Ciudad de México
mapa_cdmx <- st_read("https://github.com/JuveCampos/Shapes_Resiliencia_CDMX_CIDE/raw/master/Zona%20Metropolitana/EstadosZMVM.geojson", quiet = T)[3,]


m <- leaflet() %>% 
  addTiles() %>% 
  #addProviderTiles("CartoDB.Positron") %>% 
  addPolylines(data=r$geometry, opacity=1, weight = 3) %>%
  addMarkers(lng=destino[1,1], lat=destino[1,2], popup = nombre.mun.d, label = nombre.mun.d) %>%
  addPopups(lng=origen[1,1], lat=origen[1,2], nombre.mun.o,options = popupOptions(closeButton = FALSE)) %>%
  addPopups(lng=destino[1,1], lat=destino[1,2], nombre.mun.d,options = popupOptions(closeButton = FALSE)) %>%
  addMarkers(lng=origen[1,1], lat=origen[1,2], popup = nombre.mun.o, label = nombre.mun.o) %>%
  addPolygons(data = mapa_municipios, 
              color = "#444444",
              weight = 2, 
              opacity = 0.4,
              fill = F,
              label = ~as.character(NOM_MUN)) %>%
  addPolygons(data = mapa_cdmx, 
              color = "#444444",
              weight = 4, 
              opacity = 1,
              fill = F
  )

m

```
![8  MAPA](https://user-images.githubusercontent.com/71915068/107133435-ad3cb580-68ad-11eb-91f3-19759088b6b1.PNG)

### Loop para obtener más municipios por consulta

```R
### El condigo siguiente nos ayudo a realizar la tarea anterior pero aplicandolo a los más de 16,000 datos


# Initialize the data frame
#####==========ORIGEN=============####

# Se dividieron los datos ya que existe un limite de creditos disponibles por hora
1:500
501:1000
1001:1500
...
8501:8625


# Ejemplo 
idx <- 1:20

# Asiganmos un rago para encontrar los municipios
origen.sample <-origen[idx,]

# Nos aseguramos que sean los datos que queremos
head(origen.sample); tail(origen.sample); dim(origen.sample); 


iter = 0 # Loop para obtener el nombre de los municipios de origen 
for(i in idx){
  iter = iter + 1
  result <- GNfindNearbyPostalCodes(lat = origen.sample[iter,2], lng=origen.sample[iter,1],radius = "10", maxRows = "1", style = "MEDIUM")$adminName2
  cdmx.rutas$municipios_origen[i] <- result
}

#print(i) 

# Resultado final de los municipios de origen encontrados
head(cdmx.rutas$municipios_origen[idx])

#####============DESTINO=============######


# El procedimiento es el mismo que el anterior

idx <- 1:20

destino.sample <-destino[idx,]

# Loop para obtener el nombre de los municipios de destino 
iter = 0
for(i in idx){
  iter = iter + 1
  result <- GNfindNearbyPostalCodes(lat = destino.sample[iter,2], lng=destino.sample[iter,1],radius = "10", maxRows = "1", style = "MEDIUM")$adminName2
  cdmx.rutas$municipios_destino[i] <- result
}
print(i)


# Resultado final de los municipios destino encontrados
head(cdmx.rutas$municipios_destino[idx])

# Guardamos los resultados 
write.csv(cdmx.rutas,"cdmx_rutas_municipios_save.csv")
```

### Conclusión
