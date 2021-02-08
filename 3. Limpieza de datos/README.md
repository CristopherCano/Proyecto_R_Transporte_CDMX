# Limpieza de datos

### Antes y despues de la limpieza de datos 

```duración del viaje``` ```distancia del viaje``` ```tiempo de espera```
![Tabla comparación](https://user-images.githubusercontent.com/71915068/107182730-e571f000-69a2-11eb-987d-5e3e1e018045.PNG)


### Obervaciones de los datos

Columnas que tienen valores atípicos: 

- trip_duration,
- dist_meters, 
- wait_sec. 

Sus valores máximos son extremadamente altos, por ejemplo:

- El valor máximo de duración del viaje es ~ 276,182 min, lo que no puede ser cierto para ningún viaje.
- El valor máximo de distancia del viaje es ~ 802.54 km, 
- El timpo máximo de espera del viaje es 73,822,437 min que es imposible para los viajes.

Con la limpieza mediante boxplots que nos ayuda a detectar outlayers, obtuvimos mejores resultados.

- El valor máximo de duración del viaje es ~ 23 min.
- El valor máximo de distancia del viaje es ~ 8.44 km.
- El timpo máximo de espera del viaje es 8.45 min.

Estos valores ya son más utiles para trabajar con ellos.

### Codigo

```R
library(ggplot2)
library(dplyr)

#Cargamos la base de datos de viajes en la CDMX mediante taxis o UBER
rutas.df <- read.csv("cdmx_transporte_clean.csv")
head(rutas.df)
summary(rutas.df)
dim(rutas.df)
```

```Primer limpieza```
```R
#Visualizamos el timepo, la distancia y tiempo de espera
ggplot(rutas.df, aes(x = trip_duration_hrs)) + geom_histogram(bins = 30)
```
![1 hist duracion](https://user-images.githubusercontent.com/71915068/107176044-f2d3ae00-6993-11eb-96e2-955cf1d8ee1c.png)
```R
ggplot(rutas.df, aes(x = trip_duration_hrs)) + geom_boxplot()
```
![1 box](https://user-images.githubusercontent.com/71915068/107176059-f6673500-6993-11eb-932d-47bdc2dd8b84.png)

![1 table](https://user-images.githubusercontent.com/71915068/107180085-9b3a4000-699d-11eb-9254-26a9366cd674.PNG)

```R
ggplot(rutas.df, aes(x = dist_km)) + geom_histogram(bins = 30)
```
![2 his](https://user-images.githubusercontent.com/71915068/107176047-f404db00-6993-11eb-8676-ba9cdc25ef16.png)


```R
ggplot(rutas.df, aes(x = dist_km)) + geom_boxplot()
```
![2 box](https://user-images.githubusercontent.com/71915068/107176046-f36c4480-6993-11eb-8e9b-f845d1196cab.png)

![2 table](https://user-images.githubusercontent.com/71915068/107180087-9bd2d680-699d-11eb-890c-b7721486c040.PNG)
```R
ggplot(rutas.df, aes(x = wait_min)) + geom_histogram(bins = 30)
```
![3 hist](https://user-images.githubusercontent.com/71915068/107176049-f49d7180-6993-11eb-84b2-47b6ed9dfbeb.png)

```R
ggplot(rutas.df, aes(x = wait_min)) + geom_boxplot()
```
![3 box](https://user-images.githubusercontent.com/71915068/107176048-f404db00-6993-11eb-8072-459fa8c43bfa.png)

![3 table](https://user-images.githubusercontent.com/71915068/107180088-9bd2d680-699d-11eb-8cf5-bfd6594e02b8.PNG)

### Limpieza de datos
```R
clean_time <- del.outlayers.trip_duration(rutas.df$trip_duration_hrs, rutas.df,trip_duration_hrs)
#clean_dist<-del.outlayers.dist_meters(clean_time$dist_km, clean_time, dist_km)
clean_waitsec <- del.outlayers.wait_sec(clean_time$wait_min, clean_time, wait_min)
```

### Resultados

```R
ggplot(clean_time_6, aes(x = trip_duration_hrs)) + geom_histogram(bins = 30)
```
![4 hist](https://user-images.githubusercontent.com/71915068/107176053-f5360800-6993-11eb-9845-a1237c28bb43.png)

```R
ggplot(clean_time_6, aes(x = trip_duration_hrs)) + geom_boxplot()
```
![4 box](https://user-images.githubusercontent.com/71915068/107176050-f49d7180-6993-11eb-800a-1dcf5403b010.png)

![4 table](https://user-images.githubusercontent.com/71915068/107180089-9bd2d680-699d-11eb-98af-60bc8b838b83.PNG)

```R
ggplot(clean_time_6, aes(x = dist_km)) + geom_histogram(bins = 30)
```
![5 hist](https://user-images.githubusercontent.com/71915068/107176055-f5ce9e80-6993-11eb-822a-aec0160f0af2.png)
```R
ggplot(clean_time_6, aes(x = dist_km)) + geom_boxplot()

```
![5 box](https://user-images.githubusercontent.com/71915068/107176054-f5360800-6993-11eb-83e0-3fd19163e106.png)

![5 table](https://user-images.githubusercontent.com/71915068/107180091-9bd2d680-699d-11eb-81a7-861fe25e4fbd.PNG)

```R
ggplot(clean_time_6, aes(x = trip_duration)) + geom_histogram(bins = 30)

```
![6  hist](https://user-images.githubusercontent.com/71915068/107176058-f6673500-6993-11eb-8946-dc9b92ed6a78.png)

```R
ggplot(clean_time_6, aes(x = trip_duration)) + geom_boxplot()
```
![6  box](https://user-images.githubusercontent.com/71915068/107176057-f5ce9e80-6993-11eb-817c-70cead3a2654.png)

![6 table](https://user-images.githubusercontent.com/71915068/107180095-9c6b6d00-699d-11eb-87bd-ae5d8811a3e1.PNG)

Guardamos los datos
```R
write.csv(clean_time_6, "cdmx_transporte_clean3.csv")

a<-read.csv("cdmx_transporte_clean3.csv")

#Visualizamos el timepo, la distancia y tiempo de espera
ggplot(a, aes(x = trip_duration_hrs)) + geom_histogram(bins = 30)
ggplot(a, aes(x = trip_duration_hrs)) + geom_boxplot()

ggplot(a, aes(x = dist_meters)) + geom_histogram(bins = 30)
ggplot(a, aes(x = dist_meters)) + geom_boxplot()

ggplot(a, aes(x = trip_duration)) + geom_histogram(bins = 30)
ggplot(a, aes(x = trip_duration)) + geom_boxplot()
```
