# Exploración de datos - Análisis de Viajes y Tráfoc

En este análisis se buscaron las relaciones entre las diferentes variables (como el tiempo y el tipo de transporte) y la cantidad de viajes hechos o el tráfico que se encontró en cada viaje.
Para medir el tráfico se usa la columna "wait_sec", esta indica el tiempo que el transporte estuvo completamente detenido durante el trayecto.

### Librerías utilizadas
```R
library(dplyr)
library(xts)
library(lubridate)
library(ggplot2)
```
La librería ´dplyr´ fue utilizada para la manipulación de los dataframes. Las librerías `xts`y `lubridate` se usaron para el manejo de fechas y horas. Con la librería `ggplot2` se graficaron los resultados de los análisis hechos en el archivo.

### Preparación de los datos
```R
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
```
En el código anterior se leyeron los datos y se convirtió la columna `pickup_date` de `String` a `Date`, se filtraron algunos outliers y se añadió la columna `unos` que servirá para contabilizar los viajes algunas secciónes proximas. También se guardaron en dos listas los nombres de los tipos de transporte correspondientes a Taxis y Ubers.
### Análisis Exploratorio

#### Serie de tiempo de viajes de uber mensuales
Se piensa que los viajes de transportes Uber se incrementa con el tiempo debido a que su popularidad ha aumentado, sin embargo, no fue posible hacer una serie de tiempo con datos diarios por los pocos viajes de Uber registrados en la base de datos utilizada.
```R
tsUber <- ubers %>% group_by(pickup_date) %>% summarise(cuenta = sum(unos))
tsUber <- mutate(tsUber, date = as.Date(paste(pickup_date,"-1",sep=""),"%Y-%m-%d"))
ggplot(tsUber, aes(date,cuenta))+
  geom_line()+
  theme_minimal()+
  labs(title = "Viajes Por Mes - Uber",
        subtitle = "Junio 2016 - Julio 2017",
        x="Fecha",
        y="Viajes")
```
Resultado


![PCTABLA](https://github.com/CristopherCano/Proyecto_R_Transporte_CDMX/blob/main/4.%20Exploraci%C3%B3n%20de%20datos/Viajes-Tr%C3%A1fico/Gr%C3%A1ficos/Viajes%20Por%20Mes%20-%20Uber.png)

A pesar de los pocos datos, se puede apreciar que en la segunda mitad del 2016 hubo un incremento en los viajes de Uber. Se requieren más datos si se desea investigar la autenticidad de este incremento.
Se intentó pasar los datos obtenidos a un objeto de clase `ts` y descomponer la serie de tiempo pero ya que el periodo de tiempo eso solo de junio del 2016 a julio de 2017 no cumple los periodos de tiempo mínimos para poder ser descompuesta.
```R
tsUber <- ts(tsUber$cuenta, st = c(2016,8), end = c(2017,7),fr=12)
ts.decomposed <- decompose(tsUber)
plot (ts.decomposed)
```
Error arrojado:

`Error in decompose(tsUber) : time series has no or less than 2 periods`

#### Serie de tiempo de los viajes diarios de los trnasportes Taxi.
Se hará una serie de tiempo con los viajes diarios realizados por los transportes Taxi, esto con la finalidad de observar su comportamiento desde junio del 2016 a julio de 2017.
```R
taxis <- data[which(data$Transporte %in% tNames),]
tsData <- mutate(taxis, pickup_date = format(pickup_date, "%Y-%m-%d"))

tsData <- tsData %>% group_by(pickup_date) %>% summarise(cuenta = sum(unos))
tsData <- mutate(tsData, date = as.Date(pickup_date,"%Y-%m-%d"))
ggplot(tsData,aes(date,cuenta))+
  geom_line()+
  theme_minimal()+
  labs(title = "Viajes Por Día - Taxis",
       subtitle = "Junio 2016 - Julio 2017",
       x="Fecha",
       y="Viajes")
```

Resultado

![PCTABLA](https://github.com/CristopherCano/Proyecto_R_Transporte_CDMX/blob/main/4.%20Exploraci%C3%B3n%20de%20datos/Viajes-Tr%C3%A1fico/Gr%C3%A1ficos/Viajes%20Por%20D%C3%ADa%20-%20Taxis.png)

Se puede observar un incremento conforme pasa el tiempo y parece ser que hay un ciclo de picos y bajos, sin embargo, asi como en la serie de tiempo anterior, el corto periodo de tiempo de los datos no nos permite hacer una descomposición de la serie de tiempo para observar ciclos estacionales y analizarlos. Se pienza que habría ciclos estacionales semanales, mensuales y anuales, ya que se puede observar más actividad automovilística en la ciudad de lunes a viernes, los días que coinciden con el día de pago quincenal y en algunos meses donde hay festividades, como en diciembre. Más adelante se buscará mas evidencia de esta hipótesis, sin embargo, dada la limitada cantidad de datos que se disponen, no se podrán comprobar formalmente.

#### Serie de tiempo de tiempo de espera promedio - Uber
Se realizó una serie de tiempo con los promedios de tiempos de espera en segundos por viaje de cada mes.
```R
tsUber <- ubers %>% group_by(pickup_date) %>% summarise(wait_sec = mean(wait_sec))
tsUber <- mutate(tsUber, date = as.Date(paste(pickup_date,"-1",sep=""),"%Y-%m-%d"))
ggplot(tsUber, aes(date,wait_sec))+
  geom_line()+
  theme_minimal()+
  labs(title = "Tiempo de Espera - Uber",
       subtitle = "Junio 2016 - Julio 2017",
       x="Fecha",
       y="Segundos por Mes")
```
Resultado.

![PCTABLA](https://github.com/CristopherCano/Proyecto_R_Transporte_CDMX/blob/main/4.%20Exploraci%C3%B3n%20de%20datos/Viajes-Tr%C3%A1fico/Gr%C3%A1ficos/Tiempo%20de%20Espera%20-Uber.png)


Por las razones expuestas anteriormente no se pudo hacer una descomposición de la serie de tiempo.

#### Serie de tiempo de tiempo de espera promedio - Taxis
Se realizó una serie de tiempo con los promedios de tiempos de espera en segundos diarios.

```R
tsData <- mutate(taxis, pickup_date = format(pickup_date, "%Y-%m-%d"))

tsData <- tsData %>% group_by(pickup_date) %>% summarise(wait_sec = mean(wait_sec))
tsData <- mutate(tsData, date = as.Date(pickup_date,"%Y-%m-%d"))
ggplot(tsData,aes(date,wait_sec))+
  geom_line()+
  theme_minimal()+
  labs(title = "Tiempo de Espera - Taxis",
       subtitle = "Junio 2016 - Julio 2017",
       x="Segundos por Día",
       y="Viajes")
```

Resultado

![PCTABLA](https://github.com/CristopherCano/Proyecto_R_Transporte_CDMX/blob/main/4.%20Exploraci%C3%B3n%20de%20datos/Viajes-Tr%C3%A1fico/Gr%C3%A1ficos/Tiempo%20de%20Espera%20-%20Taxis.png)

Parece que el rango de segundos con el automovil totalmente inmovil es mayor en los Taxis que en los Uber, esto se comprobará formalmente en otra sección.




