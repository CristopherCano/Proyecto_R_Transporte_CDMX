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
  Transporte == "Radio Taxi" || Transporte == "Taxi Libre" || Transporte == "Taxi de Sitio" 
  ~ viajesCostos$banderazo + ((viajesCostos$dist_meters/250)*viajesCostos$tarifa_dist) + ((viajesCostos$wait_sec/45)*viajesCostos$tarifa_tiempo),
  Transporte == "UberX" || Transporte == "UberXL" || Transporte == "UberBlack" || Transporte == "UberSUV"
  ~ viajesCostos$banderazo + ((viajesCostos$dist_meters/1000)*viajesCostos$tarifa_dist) + (viajesCostos$wait_sec/60*viajesCostos$tarifa_tiempo),
  TRUE ~ 0))
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

Desglose de Tarifas 

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

![image](https://user-images.githubusercontent.com/72113099/107188719-c3ca3600-69ad-11eb-9db6-1feaa6cfeb41.png)

```R



```

```R



```


