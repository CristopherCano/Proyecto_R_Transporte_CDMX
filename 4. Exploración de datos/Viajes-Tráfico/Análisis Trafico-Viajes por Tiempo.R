# Proyecto de R BEDU --- Equipo 12
# Parte del análisis de trafico, viajes por tiempo

# Librerías utilizadas
library(dplyr)
library(xts)
library(ggplot2)
library(lubridate)

# Espacio de trabajo
setwd("../../1. Bases de datos")

# Preparación de los datos
data <- read.csv("cdmx_transporte_clean.csv")
data <- mutate(data, pickup_date = as.Date(pickup_date, "%d/%m/%Y"))
data <- filter(data, wait_sec <= 3600)
n <- as.integer(count(data))
unos <- rep(1,n)
data <- select(data,Transporte,pickup_date,pickup_time,wait_sec,municipios_origen,municipios_destino,dist_meters,trip_duration)
data <- cbind(data,unos)
names(data)
uNames = c("UberX","UberBlack","UberXL","UberSUV")
tNames = c("Taxi de Sitio","Taxi Libre","Radio Taxi")

# Serie de tiempo de viajes por mes hechos por transportes Uber
# Es mensual ya que solo se tienen pocos datos de ellos, pero se espera
# ver una tendencia alcista debido a la creciente popularidad de esta aplicación

ubers <- data[which(data$Transporte %in% uNames),]
ubers <- mutate(ubers, pickup_date = format(pickup_date, "%Y-%m"))

tsUber <- ubers %>% group_by(pickup_date) %>% summarise(cuenta = sum(unos))
tsUber <- mutate(tsUber, date = as.Date(paste(pickup_date,"-1",sep=""),"%Y-%m-%d"))
#tsUber <- ts(tsUber$cuenta, st = c(2016,8), end = c(2017,7),fr=12)
ggplot(tsUber, aes(date,cuenta))+
  geom_line()+
  theme_minimal()+
  labs(title = "Viajes Por Mes - Uber",
        subtitle = "Junio 2016 - Julio 2017",
        x="Fecha",
        y="Viajes")
  

tsUber <- ts(tsUber$cuenta, st = c(2016,8), end = c(2017,7),fr=12)
ts.decomposed <- decompose(tsUber)
plot (ts.decomposed)

# Serie del tiempo de viajes diarios por todos los transportes
# Se espera ver una tendencia a la alsa.
taxis <- data[which(data$Transporte %in% tNames),]
tsData <- mutate(taxis, pickup_date = format(pickup_date, "%Y-%m-%d"))

tsData <- tsData %>% group_by(pickup_date) %>% summarise(cuenta = sum(unos))
tsData <- mutate(tsData, date = as.Date(pickup_date,"%Y-%m-%d"))
#tsData <- ts(tsData$cuenta, st = c(2016,250), fr = 365)
ggplot(tsData,aes(date,cuenta))+
  geom_line()+
  theme_minimal()+
  labs(title = "Viajes Por Día - Taxis",
       subtitle = "Junio 2016 - Julio 2017",
       x="Fecha",
       y="Viajes")



# Dado que los datos recopilados son del 24 de junio del 2016 al 20 de julio del 2017
# y el los periodos necesarios para descomponer una serie de tiempo son dos (dos años)
# no se púdo descomponer ninguna de las series de tiempo

# Ahora se elaborarán dos series de tiempo, pero graficando el promedio de la columna
# wait_sec. Esta variable mide el tiempo que estuvo el transporte parado en el viaje,
# por eso se toma como una medida del tráfico

tsUber <- ubers %>% group_by(pickup_date) %>% summarise(wait_sec = mean(wait_sec))
tsUber <- mutate(tsUber, date = as.Date(paste(pickup_date,"-1",sep=""),"%Y-%m-%d"))
#tsUber <- ts(tsUber$wait_sec, st = c(2016,8), end = c(2017,7),fr=12)
ggplot(tsUber, aes(date,wait_sec))+
  geom_line()+
  theme_minimal()+
  labs(title = "Tiempo de Espera - Uber",
       subtitle = "Junio 2016 - Julio 2017",
       x="Fecha",
       y="Segundos por Día")

# En la gráfica se ve una grán disminución del tiempo de espera durante el viaje,
# Especulamos que esto se deba a un cambio en el sistema que calcula la mejor ruta
# que usan los choferes de uber. Sin embargo, para investigar más esto se necesitan
# más datos de viajes de Uber en ese periodo

# Serie de tiempo del promedio del tiempo de espera de todos los transportes

tsData <- mutate(taxis, pickup_date = format(pickup_date, "%Y-%m-%d"))

tsData <- tsData %>% group_by(pickup_date) %>% summarise(wait_sec = mean(wait_sec))
tsData <- mutate(tsData, date = as.Date(pickup_date,"%Y-%m-%d"))
#tsData <- ts(tsData$wait_sec, st = c(2016,175), fr = 365)
ggplot(tsData,aes(date,wait_sec))+
  geom_line()+
  theme_minimal()+
  labs(title = "Tiempo de Espera - Taxis",
       subtitle = "Junio 2016 - Julio 2017",
       x="Segundos por Día",
       y="Viajes")

# Se generará una tabla con los dias de la semana para si estos afectan en el 
# número de viajes realizados por dia

week <- mutate(data, day = format(pickup_date, "%a"), date = format(pickup_date, "%Y-%m-%d"))
week <- week %>% group_by(date,day) %>% summarise(cuenta = sum(unos))
week <- week %>% group_by(day) %>% summarise (viajes = sum(cuenta))
week$day <- factor(week$day,levels=c("dom.","lun.","mar.","mié.","jue.","vie.","sáb."))
#barplot(week$viajes,names.arg = week$day)
ggplot(data=week, aes(x=day,y=viajes))+
  geom_bar(stat = 'identity', fill = "Steelblue")+
  labs(title = "Viajes totales por Día de la Semana",
       subtitle = "",
       x="Día",
       y="Viejes")+
  theme_minimal()

# Se generará una tabla con los días de la semana y el promedio de segundos de espera
# para observar si el tráfico disminuye dependiendo del día
week <- mutate(data, day = format(pickup_date, "%a"), date = format(pickup_date, "%Y-%m-%d"))
week <- week %>% group_by(date,day) %>% summarise(wait_sec = mean(wait_sec))
week <- week %>% group_by(day) %>% summarise (wait_sec = mean(wait_sec))
week$day <- factor(week$day,levels=c("dom.","lun.","mar.","mié.","jue.","vie.","sáb."))
ggplot(data=week, aes(x=day,y=wait_sec))+
  geom_bar(stat = 'identity', fill = "Steelblue")+
  labs(title = "Tiempo de espera promedio por Día de la Semana",
       subtitle = "",
       x="Día",
       y="Tiempo de Espera")+
  theme_minimal()

# *************************************************************************************
# En esta sección se hará una regresión lineal multivariable para observar si se puede predecir el 
# tiempo de espera, se especula que las variables municipio_origen, dist_meter (distancia al destino)
# dia_semana(se agregará) mes(se agregará), y la hora(1-12)

# Todas las variables que se asumen que son significativas son categóricas, por lo tanto se 
# tiene que hacer un tratamiento de datos previo a la realización de la regresión

tmp <- c(1,1,1,1,2,2,2,2,3,3,3,3)
# Como son muy pocas las entradas con trasnporte de Uber, esta función resume todas las
# categorias de Ubers en una
fun <- function(x,namestc,name)
{
  y = c()
  for (i in 1:length(x))
  {
    if (x[i] %in% namestc)
    {
      y[i] <- name
    }
    else
    {
      y[i] <- x[i]
    }
  }
  y
}


lmData <- mutate(data, dia_semana = format(pickup_date, "%a"), mes = format(pickup_date,"%b"), hora = as.integer(hour(hms(as.character(factor(pickup_time))))) )
lmData <- mutate(lmData, rango_tiempo = hora, velocidad = dist_meters/trip_duration)

lmData <- select(lmData,Transporte,municipios_origen,dia_semana,mes,hora,wait_sec,dist_meters,velocidad)
lmData <- mutate(lmData, Transporte = fun(Transporte,uNames,"Uber"))

lmData <- fastDummies::dummy_cols(lmData, remove_first_dummy = TRUE)

attach(lmData)

m1 <- lm(wait_sec ~ hora
         +dist_meters
         +velocidad
         +`Transporte_Taxi de Sitio`
         +`Transporte_Taxi Libre`
         +Transporte_Uber
         +dia_semana_lun.
         +dia_semana_mar.
         +dia_semana_mié.
         +dia_semana_jue.
         +dia_semana_vie.
         +dia_semana_sáb.
         +mes_ene.
         +mes_feb.
         +mes_mar.
         +mes_may.
         +mes_jun.
         +mes_jul.
         +mes_ago.
         +mes_sep.
         +mes_oct.
         +mes_nov.
         +mes_dic.
         +municipios_origen_Ahome
         +`municipios_origen_Álvaro Obregón`
         +`municipios_origen_Atizapán de Zaragoza`
         +municipios_origen_Azcapotzalco
         +`municipios_origen_Benito Juárez`
         +municipios_origen_Chalco
         +municipios_origen_Chimalhuacán
         +`municipios_origen_Coacalco de Berriozábal`
         +municipios_origen_Coyoacán
         +`municipios_origen_Cuajimalpa de Morelos`
         +municipios_origen_Cuauhtémoc
         +municipios_origen_Cuautitlán
         +`municipios_origen_Cuautitlán Izcalli`
         +`municipios_origen_Ecatepec de Morelos`
         +`municipios_origen_Emiliano Zapata`
         +`municipios_origen_Gómez Palacio`
         +`municipios_origen_Gustavo A. Madero`
         +municipios_origen_Huixquilucan
         +municipios_origen_Ixtapaluca
         +municipios_origen_Iztacalco
         +municipios_origen_Iztapalapa
         +municipios_origen_Kanasín
         +`municipios_origen_La Magdalena Contreras`
         +`municipios_origen_La Paz`
         +municipios_origen_Mérida
         +`municipios_origen_Miguel Hidalgo`
         +`municipios_origen_Milpa Alta`
         +`municipios_origen_Naucalpan de Juárez`
         +municipios_origen_Nezahualcóyotl
         +municipios_origen_Querétaro
         +municipios_origen_Tecámac
         +municipios_origen_Tláhuac
         +`municipios_origen_Tlalnepantla de Baz`
         +municipios_origen_Tlalpan
         +`municipios_origen_Tulancingo de Bravo`
         +municipios_origen_Tultepec
         +municipios_origen_Tultitlán
         +`municipios_origen_Valle de Chalco Solidaridad`
         +`municipios_origen_Venustiano Carranza`
         +municipios_origen_Veracruz
         +municipios_origen_Xochimilco)

summary(m1)


m2 <- lm(wait_sec
         ~hora
         +dist_meters
         +velocidad
         +`Transporte_Taxi de Sitio`
         +`Transporte_Taxi Libre`
         +Transporte_Uber
         +dia_semana_lun.
         +dia_semana_mar.
         +dia_semana_mié.
         +dia_semana_jue.
         +dia_semana_vie.
         +mes_mar.
         +mes_dic.
         +mes_sep.
         +mes_oct.
         +mes_ago.)
summary(m2)

# Como era previsto, la regresión lineal hecha no predice con exactitud el tiempo de espera,
# su calificación de R-squared es de tan solo 0.15. Las aplicaciónes que trazan la ruta más
# corta de un lugar a otro y predicen con exactitud la inténsidad del tráfico usan modélos y 
# algoritmos mucho mas complejos que una regresión lineal.

# Sin embargo, de las variables que resultaron significativas para el modelo, están dias de 
# lunes a viernes, que coincide con la gráfica de promedio de segundos parados por día de la semana
# en la que se nota un aumento de tiempo parado en los días de lunes a viernes

# Otra coincidencia es que los meses de marzo, agosto, septiembre y octubre parecen influir
# en el tiempo de espera durante el viaje, estos meses coinciden con periodos vacacionales o 
# dias festivos, para corroborar esta correlación haría falta más datos y un estudio más 
# a fondo


