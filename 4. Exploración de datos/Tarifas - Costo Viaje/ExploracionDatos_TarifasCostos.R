#Librerías
library(chron)
library(lubridate)
library(dplyr)
library(ggplot2)
library(tidyverse)

#Carga de datos
data <- read.csv("cdmx_transporte_clean3.csv")
tarifas <- read.csv("tarifas.csv")

#Unir fecha y hora
t.pickup <- paste(data$pickup_date, data$pickup_time)
t.dropoff <- paste(data$dropoff_date, data$dropoff_time)

#cambiar formato
t.pickup <- as.POSIXct(t.pickup, format = "%d/%m/%Y %H:%M:%S")
t.dropoff <- as.POSIXct(t.dropoff, format = "%d/%m/%Y %H:%M:%S")

#Descomponer fecha
pickup.time <- format(as.POSIXct(t.pickup, format = "%m/%d/%Y %H:%M:%S"), format="%H:%M:%S")
pickup.hora <- factor(hour(hms(pickup.time)))
pickup.dia <- factor(day(t.pickup))
pickup.mesletra <- factor(month(t.pickup, label = TRUE))
pickup.mesnumero <- factor(month(t.pickup))
pickup.anio <- factor(year(t.pickup))
pickup.diaSemana <- factor(wday(t.pickup, label = TRUE))
mes_anio <- as.Date(paste("1", pickup.mesnumero, pickup.anio, sep="-"), format = "%d-%m-%Y")

#Crear DF e incluir fecha descompuesta
viajesCostos <- data.frame(data[,1:3], pickup.diaSemana, pickup.dia, pickup.mesletra, pickup.mesnumero, mes_anio, pickup.anio, pickup.time, pickup.hora, data[,8:16])

#Juntar DF de viajes y las tarifas de los transportes
viajesCostos <- merge(viajesCostos, unique(tarifas), by="Transporte")

#Convertir a num para poder realizar operaciones
viajesCostos$wait_sec <- as.numeric(viajesCostos$wait_sec)
viajesCostos$dist_meters <- as.numeric(viajesCostos$dist_meters)
viajesCostos$trip_duration <- as.numeric(viajesCostos$trip_duration)

#Formulazo para calculo costo de viaje tomando en cuenta tarifas, tiempo y distancia
viajesCostos <- viajesCostos %>% mutate(costoViaje = case_when( 
  Transporte %in% "Radio Taxi" | Transporte %in% "Taxi Libre" | Transporte %in% "Taxi de Sitio"
  ~ viajesCostos$banderazo + ((viajesCostos$dist_meters/250)*viajesCostos$tarifa_dist) + ((viajesCostos$wait_sec/45)*viajesCostos$tarifa_tiempo),
  Transporte %in% "UberX" | Transporte %in% "UberXL" | Transporte %in% "UberBlack" | Transporte %in% "UberSUV"
  ~ viajesCostos$banderazo + ((viajesCostos$dist_meters/1000)*viajesCostos$tarifa_dist) + (viajesCostos$wait_sec/60*viajesCostos$tarifa_tiempo),
  TRUE ~ 22))

#Duplicar columna y sustituir las tarifas menores a tarifa mínima
viajesCostos$costoViaje2 <- viajesCostos$costoViaje

viajesCostos <- viajesCostos %>% mutate(costoViaje2 = case_when( 
  costoViaje < tarifa_min ~ tarifa_min ,
  TRUE ~ as.numeric(as.character(costoViaje2))))


viajesCostos <- viajesCostos %>% mutate(costoKM = case_when( 
  dist_km < 1 ~ costoViaje ,
  TRUE ~ costoViaje/dist_km))

viajesCostos <- viajesCostos %>% mutate(costoKM2 = case_when( 
  dist_km < 1 ~ costoViaje2 ,
  TRUE ~ costoViaje2/dist_km))


#Se consideraba eliminar los outliers pero al ser una variable dependiente, 
#esos valores sí deben seer tomados en cuenta.

#DF de cada categoria
# TaxiLibre <- viajesCostos %>% filter(viajesCostos$Transporte == "Taxi Libre")
# RadioTaxi <- viajesCostos %>% filter(viajesCostos$Transporte == "Radio Taxi")
# TaxideSitio <- viajesCostos %>% filter(viajesCostos$Transporte == "Taxi de Sitio")
# UberX <- viajesCostos %>% filter(viajesCostos$Transporte == "UberX")
# UberXL <- viajesCostos %>% filter(viajesCostos$Transporte == "UberXL")
# UberBlack <- viajesCostos %>% filter(viajesCostos$Transporte == "UberBlack")
# UberSUV <- viajesCostos %>% filter(viajesCostos$Transporte == "UberSUV")

# remove_outliers.costoKM2 <- function(x) {
#   outliers <- boxplot(x$costoKM2, plot=FALSE)$out
#   if(length(outliers) > 0 ){
#     x <- x[-which(x$costoKM2 %in% outliers),]
#   }
#   x
# }
# 
# remove_outliers.costoKM <- function(x) {
#   outliers <- boxplot(x$costoKM, plot=FALSE)$out
#   if(length(outliers) > 0 ){
#     x <- x[-which(x$costoKM %in% outliers),]
#   }
#   x
# }
# 
# remove_outliers.costoViaje <- function(x) {
#   outliers <- boxplot(x$costoViaje, plot=FALSE)$out
#   if(length(outliers) > 0 ){
#     x <- x[-which(x$costoViaje %in% outliers),]
#   }
#   x
# }
# 
# remove_outliers.costoViaje2 <- function(x) {
#   outliers <- boxplot(x$costoViaje2, plot=FALSE)$out
#   if(length(outliers) > 0 ){
#     x <- x[-which(x$costoViaje2 %in% outliers),]
#   }
#   x
# }
# 
# RadioTaxi <- remove_outliers.costoKM2(RadioTaxi)
# TaxideSitio <- remove_outliers.costoKM2(TaxideSitio)
# TaxiLibre <- remove_outliers.costoKM2(TaxiLibre)
# UberX <- remove_outliers.costoKM2(UberX)
# UberXL <- remove_outliers.costoKM2(UberXL)
# UberSUV <- remove_outliers.costoKM2(UberSUV)
# UberBlack <- remove_outliers.costoKM2(UberBlack)
# 
# RadioTaxi <- remove_outliers.costoKM(RadioTaxi)
# TaxideSitio <- remove_outliers.costoKM(TaxideSitio)
# TaxiLibre <- remove_outliers.costoKM(TaxiLibre)
# UberX <- remove_outliers.costoKM(UberX)
# UberXL <- remove_outliers.costoKM(UberXL)
# UberSUV <- remove_outliers.costoKM(UberSUV)
# UberBlack <- remove_outliers.costoKM(UberBlack)
# 
# RadioTaxi <- remove_outliers.costoViaje(RadioTaxi)
# TaxideSitio <- remove_outliers.costoViaje(TaxideSitio)
# TaxiLibre <- remove_outliers.costoViaje(TaxiLibre)
# UberX <- remove_outliers.costoViaje(UberX)
# UberXL <- remove_outliers.costoViaje(UberXL)
# UberSUV <- remove_outliers.costoViaje(UberSUV)
# UberBlack <- remove_outliers.costoViaje2(UberBlack)
# 
# RadioTaxi <- remove_outliers.costoViaje2(RadioTaxi)
# TaxideSitio <- remove_outliers.costoViaje2(TaxideSitio)
# TaxiLibre <- remove_outliers.costoViaje2(TaxiLibre)
# UberX <- remove_outliers.costoViaje2(UberX)
# UberXL <- remove_outliers.costoViaje2(UberXL)
# UberSUV <- remove_outliers.costoViaje2(UberSUV)
# UberBlack <- remove_outliers.costoViaje2(UberBlack)
# 
# xyz <- rbind(RadioTaxi, TaxideSitio, TaxiLibre, UberBlack, UberSUV, UberX, UberXL)

#Gráfica por categoria: tarifas banderazo, costoDistancia, costoTiempo
viajesCostos %>%
  group_by(Transporte) %>%
  summarize(banderazo=mean(banderazo), mean(tarifa_dist), mean(tarifa_tiempo)) %>%
  gather(key, value, -Transporte) %>% 
  ggplot(aes(x=Transporte, y=value, fill=key)) +
  geom_bar(stat="identity", position=position_dodge()) +
  geom_text(aes(label=sprintf("%0.2f", round(value, digits = 2))), position=position_dodge(width=0.9), vjust=-0.25) +
  labs(title="Tarifas por Tipo de Transporte", subtitle = "CDMX (2016-2017)", y = "Costo ($)", color = "Tarifa", size=15) +
  scale_fill_discrete(name = "Tarifas", labels = c("Tarifa base", "Tarifa por Distancia", "Tarifa por Tiempo"))

#Boxplot con los costos de viaje sin tomar en cuenta Tarifa Mínima
ggplot(data = viajesCostos, aes(x=Transporte, y=costoViaje)) + geom_boxplot() +
  ggtitle("Costo de Viajes sin Tarifa Mínima") + xlab("Transporte") + ylab("Costo Viaje ($)")

#Boxplot con los costos de viaje tomando en cuenta Tarifa Mínima
ggplot(data = viajesCostos, aes(x=Transporte, y=costoViaje2)) + geom_boxplot() +
  ggtitle("Costo de Viajes con Tarifa Mínima ") + xlab("Transporte") + ylab("Costo Viaje ($)")
  

#Graficar por categoría: costos viaje y por km y comparacion con y sin tarifa mínima
viajesCostos %>%
  group_by(Transporte) %>%
  summarize(distancia=mean(dist_km), precio=mean(costoViaje), precioKM=mean(costoKM),
            precio2=mean(costoViaje2), precioKM2=mean(costoKM2)) %>%
    gather(key, value, -Transporte) %>% 
      ggplot(aes(x=Transporte, y=value, fill=key)) +
      geom_bar(stat="identity", position=position_dodge()) +
      geom_text(aes(label=sprintf("%0.1f", round(value, digits = 1))), position=position_dodge(width=0.9), vjust=-0.25) + 
      labs(title="Tarifas por Tipo de Transporte", subtitle = "CDMX (2016-2017)", y = "Costo ($)", color = "Tarifa", size=15) +
      scale_fill_discrete(name = "Costos Total y /KM ", labels = c("Dist prom", "Costo prom sin Tarifa Min", "Costo prom con Tarifa Min",
                                                       "Costo/KM prom sin Tarifa Min", "Costo/KM prom con Tarifa Min"))

#Grafica por dia de semana: costos viaje y por km y comparación con y sin tarifa mínima General
viajesCostos %>%
  group_by(pickup.diaSemana) %>%
  summarize(distancia=mean(dist_meters/1000), precio=mean(costoViaje), precioKM=precio/mean(dist_meters/1000),
            precio2=mean(costoViaje2), precioKM2=precio2/mean(dist_meters/1000)) %>%
  gather(key, value, -pickup.diaSemana) %>% 
  ggplot(aes(x=pickup.diaSemana, y=value, fill=key)) +
  geom_col(position = "dodge") + 
  geom_text(aes(label=sprintf("%0.1f", round(value, digits = 1))), position=position_dodge(width=0.9), vjust=-0.25)+
  labs(title="Tarifas Generales por Día", subtitle = "CDMX (2016-2017)", y = "Costo ($)", color = "Tarifa", size=15) +
  scale_fill_discrete(name = "Costos Total y /KM ", labels = c("Dist prom", "Costo prom sin Tarifa Min", "Costo prom con Tarifa Min",
                                                               "Costo/KM prom sin Tarifa Min", "Costo/KM prom con Tarifa Min"))+
  xlab("Dia de la Semana")


#Grafica por dia de semana: costos viaje y por km y comparación con y sin tarifa mínima por Categoría
viajesCostos %>%
     group_by(pickup.diaSemana, Transporte) %>%
     summarize(distancia=mean(dist_meters/1000), precio=mean(costoViaje), precioKM=precio/mean(dist_meters/1000),
               precio2=mean(costoViaje2), precioKM2=precio2/mean(dist_meters/1000)) %>%
   ggplot(aes(factor(pickup.diaSemana), precio, fill = Transporte)) + 
       geom_bar(stat="identity", position = "dodge") + 
       scale_fill_brewer(palette = "Set1")+
       labs(title="Tarifas Generales por Día", subtitle = "CDMX (2016-2017)", y = "Costo ($)", size=15) +
       xlab("Dia de la Semana")

