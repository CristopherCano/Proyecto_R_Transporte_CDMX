# Limpieza de datos

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

```R
ggplot(rutas.df, aes(x = dist_km)) + geom_histogram(bins = 30)
```
![2 his](https://user-images.githubusercontent.com/71915068/107176047-f404db00-6993-11eb-8676-ba9cdc25ef16.png)


```R
ggplot(rutas.df, aes(x = dist_km)) + geom_boxplot()
```
![2 box](https://user-images.githubusercontent.com/71915068/107176046-f36c4480-6993-11eb-8e9b-f845d1196cab.png)
```R
ggplot(rutas.df, aes(x = wait_min)) + geom_histogram(bins = 30)
```
![3 box](https://user-images.githubusercontent.com/71915068/107176048-f404db00-6993-11eb-8072-459fa8c43bfa.png)
```R
ggplot(rutas.df, aes(x = wait_min)) + geom_boxplot()
```

![3 hist](https://user-images.githubusercontent.com/71915068/107176049-f49d7180-6993-11eb-84b2-47b6ed9dfbeb.png)
```R
clean_time <- del.outlayers.trip_duration(rutas.df$trip_duration_hrs, rutas.df,trip_duration_hrs)
```
![3 hist](https://user-images.githubusercontent.com/71915068/107176049-f49d7180-6993-11eb-84b2-47b6ed9dfbeb.png)

#clean_dist<-del.outlayers.dist_meters(clean_time$dist_km, clean_time, dist_km)

clean_waitsec <- del.outlayers.wait_sec(clean_time$wait_min, clean_time, wait_min)
```

```R
dim(clean_waitsec);

#Visualizamos el timepo, la distancia y tiempo de espera
ggplot(clean_waitsec, aes(x = trip_duration)) + geom_histogram(bins = 30)
ggplot(clean_waitsec, aes(x = trip_duration)) + geom_boxplot()

ggplot(clean_waitsec, aes(x = dist_meters)) + geom_histogram(bins = 30)
ggplot(clean_waitsec, aes(x = dist_meters)) + geom_boxplot()

ggplot(clean_waitsec, aes(x = wait_min)) + geom_histogram(bins = 30)
ggplot(clean_waitsec, aes(x = wait_min)) + geom_boxplot()

```
Segunda Limpieza

```R
clean_time_2 <- del.outlayers.trip_duration(clean_waitsec$trip_duration_hrs, clean_waitsec,trip_duration_hrs)
clean_dist_2 <- del.outlayers.dist_meters(clean_time_2$dist_km, clean_time_2, dist_km)
clean_waitsec_2 <- del.outlayers.wait_sec(clean_dist_2$wait_min, clean_dist_2, wait_min)


ggplot(clean_waitsec_2, aes(x = trip_duration_hrs)) + geom_histogram(bins = 30)
ggplot(clean_waitsec_2, aes(x = trip_duration_hrs)) + geom_boxplot()

ggplot(clean_waitsec_2, aes(x = dist_km)) + geom_histogram(bins = 30)
ggplot(clean_waitsec_2, aes(x = dist_km)) + geom_boxplot()

ggplot(clean_waitsec_2, aes(x = trip_duration)) + geom_histogram(bins = 30)
ggplot(clean_waitsec_2, aes(x = trip_duration)) + geom_boxplot()

```
Tercer limpieza
```R
clean_time_3 <- del.outlayers.trip_duration(clean_waitsec_2$trip_duration_hrs, clean_waitsec,trip_duration_hrs)
clean_dist_3 <- del.outlayers.dist_meters(clean_time_3$dist_km, clean_time_3, dist_km)
clean_waitsec_3 <- del.outlayers.wait_sec(clean_dist_3$wait_min, clean_dist_3, wait_min)
dim(clean_waitsec_3)

ggplot(clean_waitsec_3, aes(x = trip_duration_hrs)) + geom_histogram(bins = 30)
ggplot(clean_waitsec_3, aes(x = trip_duration_hrs)) + geom_boxplot()

ggplot(clean_waitsec_3, aes(x = dist_km)) + geom_histogram(bins = 30)
ggplot(clean_waitsec_3, aes(x = dist_km)) + geom_boxplot()

ggplot(clean_waitsec_3, aes(x = trip_duration)) + geom_histogram(bins = 30)
ggplot(clean_waitsec_3, aes(x = trip_duration)) + geom_boxplot()
```

Cuarta limpieza
```R
clean_dist_4 <- del.outlayers.dist_meters(clean_waitsec_3$dist_km, clean_waitsec_3, dist_km)
dim(clean_dist_4)

ggplot(clean_dist_4, aes(x = trip_duration_hrs)) + geom_histogram(bins = 30)
ggplot(clean_dist_4, aes(x = trip_duration_hrs)) + geom_boxplot()

ggplot(clean_dist_4, aes(x = dist_km)) + geom_histogram(bins = 30)
ggplot(clean_dist_4, aes(x = dist_km)) + geom_boxplot()

ggplot(clean_dist_4, aes(x = trip_duration)) + geom_histogram(bins = 30)
ggplot(clean_dist_4, aes(x = trip_duration)) + geom_boxplot()
```
Quinta limpieza
```R
clean_time_5 <- del.outlayers.trip_duration(clean_dist_4$trip_duration_hrs, clean_dist_4,trip_duration_hrs)
clean_waitsec_5 <- del.outlayers.wait_sec(clean_time_5$wait_min, clean_time_5, wait_min)
dim(clean_waitsec_3)

ggplot(clean_waitsec_5, aes(x = trip_duration_hrs)) + geom_histogram(bins = 30)
ggplot(clean_waitsec_5, aes(x = trip_duration_hrs)) + geom_boxplot()

ggplot(clean_waitsec_5, aes(x = dist_km)) + geom_histogram(bins = 30)
ggplot(clean_waitsec_5, aes(x = dist_km)) + geom_boxplot()

ggplot(clean_waitsec_5, aes(x = trip_duration)) + geom_histogram(bins = 30)
ggplot(clean_waitsec_5, aes(x = trip_duration)) + geom_boxplot()
```
Limpieza Final
```R
clean_time_6 <- del.outlayers.trip_duration(clean_waitsec_5$trip_duration_hrs, clean_waitsec_5,trip_duration_hrs)
dim(clean_waitsec_3)

```R
ggplot(clean_time_6, aes(x = trip_duration_hrs)) + geom_histogram(bins = 30)
```
![4 box](https://user-images.githubusercontent.com/71915068/107176050-f49d7180-6993-11eb-800a-1dcf5403b010.png)
```R
ggplot(clean_time_6, aes(x = trip_duration_hrs)) + geom_boxplot()
```
![4 hist](https://user-images.githubusercontent.com/71915068/107176053-f5360800-6993-11eb-9845-a1237c28bb43.png)
```R
ggplot(clean_time_6, aes(x = dist_km)) + geom_histogram(bins = 30)
```
![5 box](https://user-images.githubusercontent.com/71915068/107176054-f5360800-6993-11eb-83e0-3fd19163e106.png)
```R
ggplot(clean_time_6, aes(x = dist_km)) + geom_boxplot()
```
![5 hist](https://user-images.githubusercontent.com/71915068/107176055-f5ce9e80-6993-11eb-822a-aec0160f0af2.png)
```R
ggplot(clean_time_6, aes(x = trip_duration)) + geom_histogram(bins = 30)
```
![6  hist](https://user-images.githubusercontent.com/71915068/107176058-f6673500-6993-11eb-8946-dc9b92ed6a78.png)

```R
ggplot(clean_time_6, aes(x = trip_duration)) + geom_boxplot()
```
![6  box](https://user-images.githubusercontent.com/71915068/107176057-f5ce9e80-6993-11eb-817c-70cead3a2654.png)
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
