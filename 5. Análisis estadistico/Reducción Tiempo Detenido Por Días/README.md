# Prueba de Hipítesis
#### Se realizará una prueba de hipótesis para comprobar formalmente el planteamiento hecho en el análisis exploratorio de los datos de que durante los días sábado y domingo el tráfico vehicular, medido con el tiempo en que el transporte estuvo totalmente detenido durante el trayecto, es menor en promedio por viaje que entre semana.

### Código en R

Librerías utilizasas y preparación de los datos
```R
# Librerías utilizadas
library(dplyr)
library(xts)
library(ggplot2)

# Preparación de los datos.
data <- read.csv("../../1. Bases de datos/cdmx_transporte_clean3.csv")
data <- mutate(data, date = as.Date(pickup_date, "%d/%m/%Y"))
data <- filter(data, wait_sec <= 3600)
data <- select(data,date,wait_sec)
names(data)

# Se agrega una columna especificando que día es
data <- mutate(data, day = format(date,"%A"))
unique(data$day)

```
Se agrega una función para agrupar los dias de din de semana (FS) y entre semana (ES).
```R
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
```

Obtención de datos, estadísiticos y contraste de hipótesis.
```R
(nFS <- length(fsData))
(nES <- length(esData))

(mFS <- mean(fsData))
(mES <- mean(esData))

(vFS <- var(fsData))
(vES <- var(esData))

# H_0: mES-mFS = 0
# H_1: mES-mFS > 0 (El promedio en ES es mayor que en FS)


(Z = (mES-mFS)/sqrt((vES/nES)+(vFS/nFS)))
(Z.05 = qnorm(p=0.05, lower.tail = FALSE))
(Z>=Z.05)
# Se rechaza H_0
```
Se obtiene el porcentaje de reducción.
```R
# Se obtendrá el porcentaje de reducción
dif = mES-mFS
por <- dif/mES
por
# La refucción fue de un 8%
```
### Contraste de Hipótesis de manera gráfica.

![PCTABLA](https://github.com/CristopherCano/Proyecto_R_Transporte_CDMX/blob/main/5.%20An%C3%A1lisis%20estadistico/Reducci%C3%B3n%20Tiempo%20Detenido%20Por%20D%C3%ADas/Datos.png)

![PCTABLA](https://github.com/CristopherCano/Proyecto_R_Transporte_CDMX/blob/main/5.%20An%C3%A1lisis%20estadistico/Reducci%C3%B3n%20Tiempo%20Detenido%20Por%20D%C3%ADas/Contraste.png)

Después de esta prueba de hipótesis se puede afirmar que hay una reducción del 8% del tiempo en el tráfico promedio en la Ciudad de México.























