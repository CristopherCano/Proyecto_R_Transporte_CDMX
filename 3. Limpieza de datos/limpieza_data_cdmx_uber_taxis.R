library(ggplot2)
library(dplyr)


#Cargamos la base de datos de viajes en la CDMX mediante taxis o UBER
rutas.df <- read.csv("mex_clean.csv")
head(rutas.df); tail(rutas.df); summary(rutas.df); dim(rutas.df)

#Visualizamos el timepo, la distancia y tiempo de espera
ggplot(rutas.df, aes(x = trip_duration_hrs)) + geom_histogram(bins = 30)
ggplot(rutas.df, aes(x = dist_km)) + geom_histogram(bins = 30)

ggplot(rutas.df, aes(x = trip_duration_hrs)) + geom_boxplot()
ggplot(rutas.df, aes(x = dist_km)) + geom_boxplot()



rutas.df.clean_timehrs <- delete.outlayers(rutas.df$trip_duration_hrs, rutas.df,trip_duration_hrs)

rutas.clean_distkm <- delete.outlayers(rutas.df.clean_timehrs$dist_km, rutas.df.clean_timehrs, dist_km)

rutas.clean_wait_time <- delete.outlayers(rutas.clean_distkm$wait_min, rutas.df.clean_timehrs, wait_min)

summary(rutas.clean_wait_time)

ggplot(rutas.clean_wait_time, aes(x = trip_duration_hrs*60)) + geom_histogram(bins = 30)
ggplot(rutas.clean_wait_time, aes(x = dist_km)) + geom_histogram(bins = 30)

ggplot(rutas.clean_wait_time, aes(x = trip_duration_hrs)) + geom_boxplot()
ggplot(rutas.clean_wait_time, aes(x = dist_km)) + geom_boxplot()


write.csv(rutas.clean_wait_time, "CDMX_Rutas.csv")


var <-(dist_km)

filter(rutas.df, var < out_cns_list[i-1])
