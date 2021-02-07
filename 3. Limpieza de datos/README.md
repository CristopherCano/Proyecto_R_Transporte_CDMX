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

Primer limpieza
```R
#Visualizamos el timepo, la distancia y tiempo de espera
ggplot(rutas.df, aes(x = trip_duration_hrs)) + geom_histogram(bins = 30)
ggplot(rutas.df, aes(x = trip_duration_hrs)) + geom_boxplot()

ggplot(rutas.df, aes(x = dist_km)) + geom_histogram(bins = 30)
ggplot(rutas.df, aes(x = dist_km)) + geom_boxplot()

ggplot(rutas.df, aes(x = wait_min)) + geom_histogram(bins = 30)
ggplot(rutas.df, aes(x = wait_min)) + geom_boxplot()

clean_time <- del.outlayers.trip_duration(rutas.df$trip_duration_hrs, rutas.df,trip_duration_hrs)

#clean_dist<-del.outlayers.dist_meters(clean_time$dist_km, clean_time, dist_km)

clean_waitsec <- del.outlayers.wait_sec(clean_time$wait_min, clean_time, wait_min)


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

ggplot(clean_time_6, aes(x = trip_duration_hrs)) + geom_histogram(bins = 30)
ggplot(clean_time_6, aes(x = trip_duration_hrs)) + geom_boxplot()

ggplot(clean_time_6, aes(x = dist_km)) + geom_histogram(bins = 30)
ggplot(clean_time_6, aes(x = dist_km)) + geom_boxplot()

ggplot(clean_time_6, aes(x = trip_duration)) + geom_histogram(bins = 30)
ggplot(clean_time_6, aes(x = trip_duration)) + geom_boxplot()
```
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
