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


### Conclusión
