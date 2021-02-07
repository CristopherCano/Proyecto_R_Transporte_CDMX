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

Codigo para extrae los municipios 

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



### Conclusión
