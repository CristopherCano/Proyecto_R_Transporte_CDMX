# Proyecto de R BEDU --- Equipo 12
# Prueba Estadística de la reducción del promedio de tiempo detenido en fin de semana

# Librerías utilizadas
library(dplyr)
library(xts)
library(ggplot2)

# Preparación de los datos
data <- read.csv("../../1. Bases de datos/cdmx_transporte_clean3.csv")
data <- mutate(data, date = as.Date(pickup_date, "%d/%m/%Y"))
data <- filter(data, wait_sec <= 3600)
data <- select(data,date,wait_sec)
names(data)

# Se agrega una columna especificando que día es
data <- mutate(data, day = format(date,"%A"))
unique(data$day)

# función para agrupar "day" en Entre semana (ES) y Fin de semana (FS)
fs <- c("sábado","domingo")
fun <- function(x,namestc,name1,name2)
{
  y = c()
  for (i in 1:length(x))
  {
    if (x[i] %in% namestc)
    {
      y[i] <- name1
    }
    else
    {
      y[i] <- name2
    }
  }
  y
}

data <- mutate(data, day_week = fun(day,fs,"FS","ES"))
fsData <- filter(data, day_week == "FS")$wait_sec
esData <- filter(data, day_week == "ES")$wait_sec

nFS <- length(fsData)
nES <- length(esData)

mFS <- mean(fsData)
mES <- mean(esData)

vFS <- var(fsData)
vES <- var(esData)

# H_0: mES-mFS = 0
# H_1: mES-mFS > 0 (El promedio en ES es mayor que en FS)


Z = (mES-mFS)/sqrt((vES/nES)+(vFS/nFS))
Z.05 = qnorm(p=0.05, lower.tail = FALSE)
(Z>=Z.05)
# Se rechaza H_0
