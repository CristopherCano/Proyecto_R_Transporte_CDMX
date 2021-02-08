# Tarifas y Costos Finales 

Librerías y BDD necesarias
```R
library(chron)
library(lubridate)
library(dplyr)
library(ggplot2)

#Carga de BDD
data <- read.csv("cdmx_transporte_clean3.csv")
tarifas <- read.csv("tarifas.csv")

```
Descomponer fecha en día, hora, semana, mes, año.
```R
#Unir fecha y hora
t.pickup <- paste(data$pickup_date, data$pickup_time)
t.dropoff <- paste(data$dropoff_date, data$dropoff_time)

#cambiar formato
t.pickup <- as.POSIXct(t.pickup, format = "%d/%m/%Y %H:%M:%S")
t.dropoff <- as.POSIXct(t.dropoff, format = "%d/%m/%Y %H:%M:%S")

#Descomponer fecha en partes.
pickup.time <- format(as.POSIXct(t.pickup, format = "%m/%d/%Y %H:%M:%S"), format="%H:%M:%S")
pickup.hora <- factor(hour(hms(pickup.time)))
pickup.dia <- factor(day(t.pickup))
pickup.mesletra <- factor(month(t.pickup, label = TRUE))
pickup.mesnumero <- factor(month(t.pickup))
pickup.anio <- factor(year(t.pickup))
pickup.diaSemana <- factor(wday(t.pickup, label = TRUE))
mes_anio <- as.Date(paste("1", pickup.mesnumero, pickup.anio, sep="-"), format = "%d-%m-%Y")
```

Crear nuevo data.frame que una data y las variables resultantes de la fecha descompuesta en partes.
```R
#Crear DF e incluir fecha descompuesta
viajesCostos <- data.frame(data[,1:3], pickup.diaSemana, pickup.dia, pickup.mesletra, pickup.mesnumero, mes_anio, pickup.anio, pickup.time, pickup.hora, data[,8:16])
```

Unir a la BDD ```data``` los valores de ```tarifas``` donde los valores de ```Transporte``` sean iguales.
```R
#Juntar DF de viajes y las tarifas de los transportes
viajesCostos <- merge(viajesCostos, unique(tarifas), by="Transporte")
```

Convertir de ```int ``` a ```num``` para poder ralizar operaciones.
```R
#Convertir a num para poder realizar operaciones
viajesCostos$wait_sec <- as.numeric(viajesCostos$wait_sec)
viajesCostos$dist_meters <- as.numeric(viajesCostos$dist_meters)
viajesCostos$trip_duration <- as.numeric(viajesCostos$trip_duration)
```

Formula para calcular el Costo Total del viaje:

```Costo Total = Tarifa Base + (Tarifa Distancia * Distancia recorrida) + (Tarifa Tiempo * Tiempo Espera )```

*Se debe recordar hacer unitarias la distancia recorrida y el tiempo de espera, según sea el caso.*
*Tiempo Espera se entiende como el tiempo en el que el automóvil estuvo detenido, por ejemplo semáforo o tráfico.*

```R
#Formula para el calculo costo de viaje tomando en cuenta tarifas, tiempo y distancia
viajesCostos <- viajesCostos %>% mutate(costoViaje = case_when( 
  Transporte %in% "Radio Taxi" | Transporte %in% "Taxi Libre" | Transporte %in% "Taxi de Sitio"
  ~ viajesCostos$banderazo + ((viajesCostos$dist_meters/250)*viajesCostos$tarifa_dist) + ((viajesCostos$wait_sec/45)*viajesCostos$tarifa_tiempo),
  Transporte %in% "UberX" | Transporte %in% "UberXL" | Transporte %in% "UberBlack" | Transporte %in% "UberSUV"
  ~ viajesCostos$banderazo + ((viajesCostos$dist_meters/1000)*viajesCostos$tarifa_dist) + (viajesCostos$wait_sec/60*viajesCostos$tarifa_tiempo),
  TRUE ~ 22))
```

Se crea una columna extra con los mismos valores de ```Costo Total``` y se sustituyen los que sean menor que la ```Tarifa Mínima``` correspondiente.

```R
#Duplicar la columna  de Costo Total
viajesCostos$costoViaje2 <- viajesCostos$costoViaje

#Sustituir el valor del Costo Total en caso de que sea menor que la Tarifa Mínima
viajesCostos <- viajesCostos %>% mutate(costoViaje2 = case_when( 
  costoViaje < tarifa_min ~ tarifa_min ,
  TRUE ~ as.numeric(as.character(costoViaje2))))
```

Se calcula el precio por kilómetro. 
Existen casos en los que la distancia es menor a 1km por lo que se crean discrepancias matemáticas, sin embargo, éstos datos no pueden ser eliminados simplemente por lo que se opta por redondear la distancia a 1km. 

```R
#Si la distancia es menor a 1km, se atribuye directamente costo total/km
viajesCostos <- viajesCostos %>% mutate(costoKM = case_when( 
  dist_km < 1 ~ costoViaje ,
  TRUE ~ costoViaje/dist_km))

#Si la distancia es menor a 1km, se atribuye directamente costo total/km
viajesCostos <- viajesCostos %>% mutate(costoKM2 = case_when( 
  dist_km < 1 ~ costoViaje2 ,
  TRUE ~ costoViaje2/dist_km))

```

* Desglose de Tarifas 

```R
#Graficar por categoría: costos viaje y por km y comparacion con y sin tarifa mínima
viajesCostos %>%
  group_by(Transporte) %>%
  summarize(distancia=mean(dist_km), precio=mean(costoViaje), precioKM=mean(costoKM),
            precio2=mean(costoViaje2), precioKM2=mean(costoKM2)) %>%
    gather(key, value, -Transporte) %>% 
      ggplot(aes(x=Transporte, y=value, fill=key)) +
      geom_col(position = "dodge") + 
      geom_text(aes(label=sprintf("%0.2f", round(value, digits = 2))), position=position_dodge(width=0.9), vjust=-0.25)
```

![image](https://user-images.githubusercontent.com/72113099/107188810-f116e400-69ad-11eb-8283-69b2dd4c9159.png)

Gracias a la gráfica se aprecia fácilmente el incremento gradual en las tarifas conforme se va subiendo en la escala de calidad en el servicio, confort, llegando hasta los niveles de amplios espacios y lujos.

* Rangos de Costos de Viaje por Categoría
```R
#Boxplot con los costos de viaje sin tomar en cuenta Tarifa Mínima
ggplot(data = viajesCostos, aes(x=Transporte, y=costoViaje2)) + geom_boxplot() +
  ggtitle("Costo de Viajes") + xlab("Transporte") + ylab("Costo Viaje ($)")

#Boxplot con los costos de viaje tomando en cuenta Tarifa Mínima
ggplot(data = viajesCostos, aes(x=Transporte, y=costoViaje2)) + geom_boxplot() +
  ggtitle("Costo de Viajes") + xlab("Transporte") + ylab("Costo Viaje ($)")
```

![image](https://user-images.githubusercontent.com/72113099/107249326-e0d82680-69f8-11eb-982a-b41f6aa0c4ed.png)

![image](https://user-images.githubusercontent.com/72113099/107249412-f6e5e700-69f8-11eb-8ab7-fab865ea306f.png)

En la segunda gráfica es donde se sustituyen los valores del Costo de Viaje por los valores de la tarifa mínima en caso de que esta sea menor segun cada tipo de transporte por parte de Uber, ya que por la parte de los Taxis, la tarifa mínima es la misma que la tarifa base.  
Como se puede observar, la mayoría de los costos calculados están por debajo de la tarifa mínima.

* Promedios de Distancia, Costo Total y Costos/Kilómetro por Categoría
```R
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
      scale_fill_discrete(name = "Costos Total y /KM ", labels = c("Dist prom", "Costo prom sin Tarifa Min", "Costo prom con Tarifa Min", "Costo/KM prom sin Tarifa Min", "Costo/KM prom con Tarifa Min"))
```

![image](https://user-images.githubusercontent.com/72113099/107256355-023c1100-69ff-11eb-9b82-9edc0ac06fe0.png)

Las gráficas de Taxis se mantienen igual ya que no hay cambios relacionados con la Tarifa Mínima. Con estas gráficas se confirma quue la distancia no es el único factor a considerar en el Costo del Viaje. La medición del tiempo en el que el coche está totalmente detenido o circula a muy bajas velocidades puede incrementar crucialmente el costo.

* Promedio de Distancia, Costo Total y CostoKM General por Día (General y Cateogría)
```R
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
```

![image](https://user-images.githubusercontent.com/72113099/107261406-e5a2d780-6a04-11eb-886c-4c2409c32a18.png)



![image](https://user-images.githubusercontent.com/72113099/107262798-9b225a80-6a06-11eb-9405-ec4af2f72e18.png)


Para los conductores es útil saber qué día de la semana tiene una mayor posibilidad de tener más ingresos, y qué día es mejor descansar. 
