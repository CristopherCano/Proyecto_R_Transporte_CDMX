# Proyecto de R BEDU --- Equipo 12
# Parte del análisis de trafico, viajes por tiempo

# Librerías utilizadas
library(dplyr)
library(xts)
library(ggplot2)

# Espacio de trabajo
setwd("Bases de datos")

# Preparación de los datos
data <- read.csv("cdmx_transporte_clean.csv")
data <- mutate(data, pickup_date = as.Date(pickup_date, "%d/%m/%Y"))
data <- filter(data, wait_sec <= 3600)
n <- as.integer(count(data))
unos <- rep(1,n)
data <- select(data,Transporte,pickup_date,pickup_time,wait_sec,municipios_origen,municipios_destino)
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
tsUber <- ts(tsUber$cuenta, st = c(2016,8), end = c(2017,7),fr=12)
plot(tsUber, ylab = "Viajes", xlab = "Tiempo")


# Serie del tiempo de viajes diarios por todos los transportes
# Se espera ver una tendencia a la alsa.
taxis <- data[which(data$Transporte %in% tNames),]
tsData <- mutate(taxis, pickup_date = format(pickup_date, "%Y-%m-%d"))

tsData <- tsData %>% group_by(pickup_date) %>% summarise(cuenta = sum(unos))
tsData <- ts(tsData$cuenta, st = c(2016,250), fr = 365)
plot(tsData, ylab = "Viajes", xlab = "Tiempo")



# Dado que los datos recopilados son del 24 de junio del 2016 al 20 de julio del 2017
# y el los periodos necesarios para descomponer una serie de tiempo son dos (dos años)
# no se púdo descomponer ninguna de las series de tiempo

# Ahora se elaborarán dos series de tiempo, pero graficando el promedio de la columna
# wait_sec. Esta variable mide el tiempo que estuvo el transporte parado en el viaje,
# por eso se toma como una medida del tráfico

tsUber <- ubers %>% group_by(pickup_date) %>% summarise(wait_sec = mean(wait_sec))
tsUber <- ts(tsUber$wait_sec, st = c(2016,8), end = c(2017,7),fr=12)
plot(tsUber, ylab = "Promedio de segundos parado", xlab = "Tiempo")

# En la gráfica se ve una grán disminución del tiempo de espera durante el viaje,
# Especulamos que esto se deba a un cambio en el sistema que calcula la mejor ruta
# que usan los choferes de uber. Sin embargo, para investigar más esto se necesitan
# más datos de viajes de Uber en ese periodo

# Serie de tiempo del promedio del tiempo de espera de todos los transportes

tsData <- mutate(taxis, pickup_date = format(pickup_date, "%Y-%m-%d"))

tsData <- tsData %>% group_by(pickup_date) %>% summarise(wait_sec = mean(wait_sec))
tsData <- ts(tsData$wait_sec, st = c(2016,175), fr = 365)
plot(tsData, ylab = "Promedio de segundos parado", xlab = "Tiempo")

# Se generará una tabla con los dias de la semana para si estos afectan en el 
# número de viajes realizados por dia

week <- mutate(data, day = format(pickup_date, "%a"), date = format(pickup_date, "%Y-%m-%d"))
week <- week %>% group_by(date,day) %>% summarise(cuenta = sum(unos))
week <- week %>% group_by(day) %>% summarise (viajes = mean(cuenta))
week <- week[c(1, 3, 4, 5, 2, 7, 6),]
barplot(week$viajes,names.arg = week$day)

# Se generará una tabla con los días de la semana y el promedio de segundos de espera
# para observar si el tráfico disminuye dependiendo del día
week <- mutate(data, day = format(pickup_date, "%a"), date = format(pickup_date, "%Y-%m-%d"))
week <- week %>% group_by(date,day) %>% summarise(wait_sec = sum(wait_sec))
week <- week %>% group_by(day) %>% summarise (wait_sec = mean(wait_sec))
week <- week[c(1, 3, 4, 5, 2, 7, 6),]
barplot(week$wait_sec,names.arg = week$day)

# *************************************************************************************
# En esta sección se hará una regresión lineal multivariable para predecir el 
# tiempo de espera, se especula que las variables municipio_origen, municipio_destino
# dia_semana(se agregará) mes(se agregará), y la hora(1-12)

# Todas las variables que se asumen que son significativas son categóricas, por lo tanto se 
# tiene que hacer un tratamiento de datos previo a la realización de la regresión

tmp <- c(1,1,1,1,2,2,2,2,3,3,3,3)
# Como son muy pocas las entradas con trasnporte de Uber, esta función resume todas las
# categorias de Ubers en una
fun <- function(x)
{
  if (x %in% uNames)
  {
    y <- "Uber"
  }
  else
  {
    y <- x
  }
  y
}

lmData <- mutate(data, dia_semana = format(pickup_date, "%a"), mes = format(pickup_date,"%b"), hora = as.integer(hour(hms(as.character(factor(pickup_time))))) )
lmData <- mutate(lmData, rango_tiempo = as.character(tmp[hora]))

lmData <- select(lmData,Transporte,municipios_origen,municipios_destino,dia_semana,mes,rango_tiempo)
lmData <- mutate(lmData, Transporte = fun(Transporte))

lmData <- fastDummies::dummy_cols(lmData)


fun <- function(x)
{
  if (x %in% uNames)
  {
    y <- "Uber"
  }
  else
  {
    y <- x
  }
  y
}












