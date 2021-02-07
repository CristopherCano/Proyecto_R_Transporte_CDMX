
# Exploración de datos - Análisis de Distancias, Tiempos de espera en el trafico y Velocidad

En este análisis se buscaron las relaciones entre las diferentes variables (como la distancias promedio de los viajes y el tipo de transporte) 
y la cantidad de viajes hechos y la velocidad promedio alcanzada en cada viaje.

### Hipotesis nula
Se piensa que los conductores de Uber deberia de pasar menos tiempo detenidos en el trafico , debido a que para despazarse usan aplicaciones con Waze, 
las cuales les ayudan a encontrar la ruta mas optima y en la que encontrarian menos trafico.

### Hipotesis alternativa
Ambos tipos de transporte;Taxis y Ubers tienen un tiempo similar detenidos en el tráfico, pues aun con la ayuda de aplicaciones para trafico como Waze, 
no siempore es posible evadir los congestionamientos en la y quedar detenido en el tráfico.

Para medir el el tiempo que el vehiculo paso detenido en el trafico se usa la columna "wait_sec", esta indica el tiempo que el transporte estuvo completamente detenido durante el trayecto.

### Librerías utilizadas
library(dplyr)
library(ggplot2)
library(DescTools)
library(ggthemes);
library(lubridate);
library(tidyr);
library(DT);
library(scales);
```
### Preparación de los datos
```R
#leer los datos
data <- read.csv("cdmx_rutas_municipios.csv")
#Filtrar datos necesarios
datosF<-select(datos, Transporte,trip_duration,trip_duration_hrs,dist_meters,dist_km,wait_sec,wait_min )

datosF<-mutate(datosF, VelodidadMts = round(dist_meters/trip_duration, 2)) # Velocidad en mts/s
datosF<-mutate(datosF, VelodidadHrs = round(dist_km/trip_duration_hrs, 2)) # Velocidad en km/h

datosF <- rename(datosF, Vel_mts_seg = VelodidadMts, Vel_km_hr = VelodidadHrs);

datosF<-filter(datosF, Vel_km_hr <= 200); # Seleccionamos velocidades posibles
datosF<-filter(datosF, dist_meters >= 500) # Seleccionamos distancias reales

dim(datosF);

write.csv(datosF,"cdmx_rutas_municipiosVel.csv", row.names = FALSE);
```
En el código anterior se leyeron los datos se filtraron unicamente las columas que eran necesarias para nuestro analisis, y se calcularon las columnas de velocidad "Vel_km_hr" y "VelodidadMts". También se hizo una limpieza superfical de los datos eliminando velocidades imposibles de conseguir, y distancias que pudieron haberse capturado por error, como cuando una persona cancela su viaje a medio camino.
Además se guardo la lista de datos ya filtrada, para su posterior análisis.

### Análisis Exploratorio

##### Analizamos los diferentes tipos de transporte de los que disponemos

Conocemos cuales son los valores maximos y minimos con los que estaremos trabajando, asi como los diferentes tipos de transporte de los que disponemos
```R
head(datosF); 
max(datosF$Vel_km_hr); min(datosF$trip_duration);

sort(datosF$trip_duration, decreasing = FALSE);
sort(datosF$dist_meters, decreasing = FALSE);

tiposT<- unique(datosF$Transporte);
tiposT # 3 tipos de taxi VS 4 tipos de Uber
#Taxi de Sitio" "Taxi Libre"    "UberX"         "Radio Taxi"    "UberBlack"     "UberXL"        "UberSUV"
```

Una vez identificados los datos, creamos otro dataframe donde  agrupamos los datos en dos grupos (Taxis y Uber) para hacer las comparaciones entre ellos, y graficarlos.
```R
#Crear una copia para manipular
datosF2<-datosF

#Agrupar los datos en dos grupos
datosF2[datosF2=="UberX"]<-"Uber";
datosF2[datosF2=="UberBlack"]<-"Uber";
datosF2[datosF2=="UberXL"]<-"Uber";
datosF2[datosF2=="UberSUV"]<-"Uber";

datosF2[datosF2=="Radio Taxi"]<-"Taxi";
datosF2[datosF2=="Taxi Libre"]<-"Taxi";
datosF2[datosF2=="Taxi de Sitio"]<-"Taxi";
```

Así como tambien, creamos otros dos dataframes, con los datos ya divididos, para analizar su comportamiento de manera independiente.

```R
#Agrupamos juntos todos los tipos de Uber
target <- c("UberX","UberBlack","UberXL","Ube rSUV")
datosUber <- filter(datosF,Transporte %in% target)
datosUber;
dim(datosUber);

#Agrupamos juntos todos los tipos de Uber
target <- c("Taxi de Sitio","Taxi Libre","Radio Taxi")
datosTaxi <- filter(datosF,Transporte %in% target)
datosTaxi;
dim(datosTaxi);
```

Una vez organizados los datos, empezamos a analizar cada una de las caracteristicas que nos interesa conocer, Tiempo que pasan en promedio en el trafico (wait_seconds) en general
```R
#TIEMPOS DE ESPERA EN EL TRAFICO
summary(datosF2$wait_sec);
#Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#0.0    84.0   190.0   354.8   397.0  8662.0 

IQR(datosF2$wait_sec); #313
84.0 - (1.5 *IQR(datosF2$wait_sec));  # -385.5
397.0 + (1.5 *IQR(datosF2$wait_sec)); # 866.5

datosFWait<-filter(datosF2, wait_sec <= 866.5) # Quitamos los outlayers

datosFWait %>%
  ggplot() + 
  aes(wait_sec) +
  geom_histogram(binwidth = 200, col="black", fill = "blue") + 
  ggtitle("PROMEDIO DE LOS TIEMPOS DE ESPERA GENERAL") +
  ylab("Frecuencia") +
  xlab("Tiempo del viaje en que estuvo completamente detenido (segundos)") + 
  theme_light();
dev.off();
```
Resultado

![PCTABLA](https://github.com/DavidGilP/Proyecto_R_Transporte_CDMX/blob/main/4.%20Exploraci%C3%B3n%20de%20datos/Velocidad-Distancia-Tiempo%20Detenido/Graficos/PromTiemposEsperaViajes_General1.png)


Observamos como los tiempos que esta completamente detenido el auto estan sesgados a  la izquierda.
Ahora graficamos esta comparacion entre ellos.

```R
#wait_sec
grupoTaxiUberWS <- datosF2 %>%
  group_by(Transporte,wait_sec ) %>%
  dplyr::summarize(Total = n());

 #wait_sec
ggplot(grupoTaxiUberWS, aes(wait_sec, Total, fill = Transporte)) + 
  geom_bar( stat = "identity") +
  ggtitle("Viajes por tiempo detenido y por Tipo Transporte") +
  scale_y_continuous(labels = comma) +
    xlim(0,866.5); #866.5 = 1.5*IR   
```

Resultado

![PCTABLA](https://github.com/DavidGilP/Proyecto_R_Transporte_CDMX/blob/main/4.%20Exploraci%C3%B3n%20de%20datos/Velocidad-Distancia-Tiempo%20Detenido/Graficos/TiempoDetenido_PorViajesGeneral1.png)

Observamos que aunque de manera similar, la frecuencia de ambos grupos estan sesgados a la izquiera,  los datos de Uber, estan menos desplazamos a lo largo de gráfica.
Igualmente, esta interpretacion la veremos con datos analizando la distribucion de los datos, en los dos grupos previamente creados.

```R
################### TAXI ###################
summary(datosTaxi$wait_sec);
#Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#0.0    84.0   190.0   350.6   397.0  8662.0 

IQR(datosTaxi$wait_sec); #313
84.0 - (1.5 *IQR(datosTaxi$wait_sec));  # -385.5
397.0 + (1.5 *IQR(datosTaxi$wait_sec)); # 866.5

################### UBER ###################
summary(datosUber$wait_sec);
#Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#0.0    64.0   162.0   572.5   359.0  7498.0

IQR(datosUber$wait_sec); #295
64.0 - (1.5 *IQR(datosUber$wait_sec));  # -378.5
359.0 + (1.5 *IQR(datosUber$wait_sec)); # 801.5
```

Procedemos a hacer la comparacion, ahora elimando los outlayers de los datos
```R
datosTaxiF<-filter(datosTaxi, wait_sec <= 866.5) #
datosUberF<-filter(datosUber, wait_sec <= 801.5) # 

################### TAXI ###################
summary(datosTaxiF$wait_sec);
#Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#0.0    78.0   169.0   229.1   324.0   866.0 
################### UBER ###################
summary(datosUberF$wait_sec);
#Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#0.00   52.75  114.50  172.19  254.25  745.00 
```
#### Conclusion
Por lo cual, aceptamos la hipotesis nula, la cual confirma nuestra suposicion de que en general, los conductores de Uber pasan menos tiempo en el trafico.
