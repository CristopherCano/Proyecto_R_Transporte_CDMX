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


```R



```

```R



```

```R



```

```R



```

```R



```

```R



```


![image](https://user-images.githubusercontent.com/72113099/107172668-8ce32880-698b-11eb-8ab5-fbe29dca3f25.png)
