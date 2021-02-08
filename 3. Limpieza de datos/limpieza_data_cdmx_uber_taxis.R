library(ggplot2)
library(dplyr)


#Cargamos la base de datos de viajes en la CDMX mediante taxis o UBER
rutas.df <- read.csv("cdmx_transporte_raw.csv")
head(rutas.df)
summary(rutas.df)
dim(rutas.df)

# Primer limpieza

#Visualizamos el timepo, la distancia y tiempo de espera
ggplot(rutas.df, aes(x = trip_duration_hrs)) + geom_histogram(bins = 30, fill="#ffcc00") +
  theme_light() + xlab("duración del viaje hrs") + ggtitle("Duración del viaje","Antes")
ggplot(rutas.df, aes(x = trip_duration_hrs)) + geom_boxplot() +
  theme_light() + xlab("duración del viaje hrs") + ggtitle("Duración del viaje","Antes")

(summary(rutas.df$trip_duration_hrs))

ggplot(rutas.df, aes(x = dist_km)) + geom_histogram(bins = 30, fill="#ff4d00") +
  theme_light()+ xlab("distancia del viaje km") + ggtitle("Distancia del viaje","Antes")
ggplot(rutas.df, aes(x = dist_km)) + geom_boxplot(color="#ff4d00")+
  theme_light()+ xlab("distancia del viaje km")+ ggtitle("Distancia del viaje","Antes")

(summary(rutas.df$dist_km))

ggplot(rutas.df, aes(x = wait_min)) + geom_histogram(bins = 30, fill = "#4d00ff") +
  theme_light()+ xlab("tiempo de espara minutos") + ggtitle("Wait time del viaje","Antes")
ggplot(rutas.df, aes(x = wait_min)) + geom_boxplot(color = "#4d00ff") +
  theme_light()+ xlab("tiempo de espara minutos") + ggtitle("Wait time del viaje","Antes")

(summary(rutas.df$wait_min))

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


clean_time_2 <- del.outlayers.trip_duration(clean_waitsec$trip_duration_hrs, clean_waitsec,trip_duration_hrs)
clean_dist_2 <- del.outlayers.dist_meters(clean_time_2$dist_km, clean_time_2, dist_km)
clean_waitsec_2 <- del.outlayers.wait_sec(clean_dist_2$wait_min, clean_dist_2, wait_min)


ggplot(clean_waitsec_2, aes(x = trip_duration_hrs)) + geom_histogram(bins = 30)
ggplot(clean_waitsec_2, aes(x = trip_duration_hrs)) + geom_boxplot()

ggplot(clean_waitsec_2, aes(x = dist_km)) + geom_histogram(bins = 30)
ggplot(clean_waitsec_2, aes(x = dist_km)) + geom_boxplot()

ggplot(clean_waitsec_2, aes(x = trip_duration)) + geom_histogram(bins = 30)
ggplot(clean_waitsec_2, aes(x = trip_duration)) + geom_boxplot()


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


clean_dist_4 <- del.outlayers.dist_meters(clean_waitsec_3$dist_km, clean_waitsec_3, dist_km)
dim(clean_dist_4)

ggplot(clean_dist_4, aes(x = trip_duration_hrs)) + geom_histogram(bins = 30)
ggplot(clean_dist_4, aes(x = trip_duration_hrs)) + geom_boxplot()

ggplot(clean_dist_4, aes(x = dist_km)) + geom_histogram(bins = 30)
ggplot(clean_dist_4, aes(x = dist_km)) + geom_boxplot()

ggplot(clean_dist_4, aes(x = trip_duration)) + geom_histogram(bins = 30)
ggplot(clean_dist_4, aes(x = trip_duration)) + geom_boxplot()


clean_time_5 <- del.outlayers.trip_duration(clean_dist_4$trip_duration_hrs, clean_dist_4,trip_duration_hrs)
clean_waitsec_5 <- del.outlayers.wait_sec(clean_time_5$wait_min, clean_time_5, wait_min)
dim(clean_waitsec_3)

ggplot(clean_waitsec_5, aes(x = trip_duration_hrs)) + geom_histogram(bins = 30)
ggplot(clean_waitsec_5, aes(x = trip_duration_hrs)) + geom_boxplot()

ggplot(clean_waitsec_5, aes(x = dist_km)) + geom_histogram(bins = 30)
ggplot(clean_waitsec_5, aes(x = dist_km)) + geom_boxplot()

ggplot(clean_waitsec_5, aes(x = trip_duration)) + geom_histogram(bins = 30)
ggplot(clean_waitsec_5, aes(x = trip_duration)) + geom_boxplot()


clean_time_6 <- del.outlayers.trip_duration(clean_waitsec_5$trip_duration_hrs, clean_waitsec_5,trip_duration_hrs)
dim(clean_waitsec_3)

ggplot(clean_time_6, aes(x = trip_duration_hrs)) + geom_histogram(bins = 30)
ggplot(clean_time_6, aes(x = trip_duration_hrs)) + geom_boxplot()

ggplot(clean_time_6, aes(x = dist_km)) + geom_histogram(bins = 30)
ggplot(clean_time_6, aes(x = dist_km)) + geom_boxplot()

ggplot(clean_time_6, aes(x = trip_duration)) + geom_histogram(bins = 30)
ggplot(clean_time_6, aes(x = trip_duration)) + geom_boxplot()

write.csv(clean_time_6, "cdmx_transporte_clean3.csv")

a<-read.csv("cdmx_transporte_clean3.csv")

#Visualizamos el timepo, la distancia y tiempo de espera
ggplot(a, aes(x = trip_duration_hrs)) + geom_histogram(bins = 30, fill="#ffcc00", color = "white") +
  theme_light() + xlab("duración del viaje hrs")+ ggtitle("Duración del viaje","Después")
ggplot(a, aes(x = trip_duration_hrs)) + geom_boxplot() +
  theme_light() + xlab("duración del viaje hrs") + ggtitle("Duración del viaje","Después")

(summary(a$trip_duration_hrs))

ggplot(a, aes(x = dist_km)) + geom_histogram(bins = 30, fill="#ff4d00", color = "white") +
  theme_light()+ xlab("distancia del viaje km") + ggtitle("Distancia del viaje","Después")
ggplot(a, aes(x = dist_km)) + geom_boxplot()+
  theme_light()+ xlab("distancia del viaje km") + ggtitle("Distancia del viaje","Después")

(summary(a$dist_km))

ggplot(a, aes(x = wait_min)) + geom_histogram(bins = 30, fill = "#4d00ff", color = "white") +
  theme_light()+ xlab("tiempo de espara minutos") + ggtitle("Wait time del viaje","Despué")
ggplot(a, aes(x = wait_min)) + geom_boxplot() +
  theme_light()+ xlab("tiempo de espara minutos") + ggtitle("Wait time del viaje","Después")

(summary(a$wait_min))



t1<-as.array(summary(rutas.df$trip_duration_hrs))
t2<-as.array(summary(rutas.df$dist_km))
t3<-as.array(summary(rutas.df$wait_min))

t4<-as.array(summary(a$trip_duration_hrs))
t5<-as.array(summary(a$dist_km))
t6<-as.array(summary(a$wait_min))

nombres<-names(t1)

c1<-rbind.data.frame(round(t1*60,2),round(t4*60,2))
c2<-rbind.data.frame(round(t2,2),round(t5,2))
c3<-rbind.data.frame(round(t3,2),round(t6,2))

names(c1) <- nombres
names(c2) <- nombres
names(c3) <- nombres

rownames(c1) <- c("Antes", "Despues")
rownames(c2) <- c("Antes", "Despues")
rownames(c3) <- c("Antes", "Despues")
