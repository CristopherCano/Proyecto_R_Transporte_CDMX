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

#### Tábla y gráfica de barras de viajes totales por día de la semana
Anteriormente se había planteado la posibilidad de que los viajes hechos por las unidades de transporte variaran según el día de la semana, en esta sección se explora tal posibilidad. Primero se hará una tabla sumando los viajes totales hechos por dia de la semana y posteriormente se hará una gráfica de barras para observar gráficamente los datos obtenidos.

```R
week <- mutate(data, day = format(pickup_date, "%a"), date = format(pickup_date, "%Y-%m-%d"))
week <- week %>% group_by(date,day) %>% summarise(cuenta = sum(unos))
week <- week %>% group_by(day) %>% summarise (viajes = mean(cuenta))
week$day <- factor(week$day,levels=c("dom.","lun.","mar.","mié.","jue.","vie.","sáb."))
view(week)
```
Tabla Resultante

![PCTABLE](https://github.com/CristopherCano/Proyecto_R_Transporte_CDMX/blob/main/4.%20Exploraci%C3%B3n%20de%20datos/Viajes-Tr%C3%A1fico/Gr%C3%A1ficos/Tabla%20Viajes%20totales.png)

Para facilitar la interpretación de los datos de la tabla se realizó una gráfica de barras.
```R
ggplot(data=week, aes(x=day,y=viajes))+
  geom_bar(stat = 'identity', fill = "Steelblue")+
  labs(title = "Viajes totales por Día de la Semana",
       subtitle = "",
       x="Día",
       y="Viejes")+
  theme_minimal()
```
Resultado

![PCTABLE](https://github.com/CristopherCano/Proyecto_R_Transporte_CDMX/blob/main/4.%20Exploraci%C3%B3n%20de%20datos/Viajes-Tr%C3%A1fico/Gr%C3%A1ficos/Viajes%20totales%20por%20D%C3%ADa%20de%20la%20Semana.png)

Como se puede apreciar, hay una reducción de viajes hechos por los transportes los días sábado y domingo, sin embargo, esto puede ser causado por que algunos choferes o taxistas no trabajan estos dos días, si se quisiera saber si en estos días tambien disminuye el trafico vehicular se tendría que usar un parámetro que mida el tráfico, como el tiempo de espera de la columna `wait_sec`, que indica en segundos, el tiempo que el vehiculo estuvo totalmente parado durante el viaje.

#### Tábla y gráfica de tiempo de espera promedio por día de la semana
Como ya se mensionó, la reducción de viajes en los días sábado y domingo puede deberse a la reducción de unidades de transporte activas durante esos días, por eso se revisará el tiempo de espera promedio por día para observar si en esos días el tráfico disminuye.
```R
week <- mutate(data, day = format(pickup_date, "%a"), date = format(pickup_date, "%Y-%m-%d"))
week <- week %>% group_by(date,day) %>% summarise(wait_sec = mean(wait_sec))
week <- week %>% group_by(day) %>% summarise (wait_sec = mean(wait_sec))
week$day <- factor(week$day,levels=c("dom.","lun.","mar.","mié.","jue.","vie.","sáb."))
```
Tabla resultante

![PCTABLA](https://github.com/CristopherCano/Proyecto_R_Transporte_CDMX/blob/main/4.%20Exploraci%C3%B3n%20de%20datos/Viajes-Tr%C3%A1fico/Gr%C3%A1ficos/Tiempo%20de%20espera%20promedio.png)

Se realizó una gráfica de barras.
```R
ggplot(data=week, aes(x=day,y=wait_sec))+
  geom_bar(stat = 'identity', fill = "Steelblue")+
  labs(title = "Tiempo de espera promedio por Día de la Semana",
       subtitle = "",
       x="Día",
       y="Tiempo de Espera")+
  theme_minimal()
```
Resultado

![PCTABLA](https://github.com/CristopherCano/Proyecto_R_Transporte_CDMX/blob/main/4.%20Exploraci%C3%B3n%20de%20datos/Viajes-Tr%C3%A1fico/Gr%C3%A1ficos/Tiempo%20de%20espera%20promedio%20por%20D%C3%ADa%20de%20la%20Semana.png)

Comparando las dos tablas, si se puede notar un decremento en el tiempo de espera promedio en los días sábado y domingo, pero este no es tan grande en comparación con el visto en la gráfica de viajes totales por día de la semana.


#### Modelo para predecir el tiempo de espera
Con los datos obtenidos anteriormente, podemos suponer que el día de la semana y el tipo de transporte afectan al tiempo de espera durante el viaje, estas variables junto con el municipio de origen, distancia al destino, el día de la semana, el mes y la hora són suficientes para predecir el tiempo de espera en un modelo de regresión lineal. Se sabe que esto es poco probable ya que los algoritmos y modelos usados en aplicaciones especializadas para calcular el tráfico son mucho más complejos que un modelo de regresión lineal.

##### Preparación de función auxiliar
Como los datos de viajes hechos por los transportes tipo Uber son muy pocos, se decidió agruparlos todos en un solo tipo de transporte `Uber`. Para hacer eso se programó la siguiente función.
```R
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
```

##### Preparación de datos

Al dataframe que se utilizó se le tuvieron que hacer modificaciones, se extrajo el mes y se agrego en forma de string, lo mismo se hizo con el día de la semana, se agrego una columna de velociadad y se redujo la hora de formato `hh:mm:ss` a solamente la hora.
Otra modificación que se realizó fue el tratamiento de las variables categóricas, como mes, día de la semana, tipo de transporte y municipio de origen, para esto se usó la función fastDummies.
```R
lmData <- mutate(data, dia_semana = format(pickup_date, "%a"), mes = format(pickup_date,"%b"), hora = as.integer(hour(hms(as.character(factor(pickup_time))))) )
lmData <- mutate(lmData, velocidad = dist_meters/trip_duration)

lmData <- select(lmData,Transporte,municipios_origen,dia_semana,mes,hora,wait_sec,dist_meters,velocidad)
lmData <- mutate(lmData, Transporte = fun(Transporte,uNames,"Uber"))

lmData <- fastDummies::dummy_cols(lmData, remove_first_dummy = TRUE)

attach(lmData)
```
Creación del modelo.
```R
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
```
Resultados de el modelo (por la longitud de la tabla de `summary` solo se mostrarán las variables significativas y las puntuaciones del modelo.
```
Residuals:
   Min     1Q Median     3Q    Max 
-778.7 -173.1  -81.5   58.8 3296.6 

Coefficients:
                                                  Estimate Std. Error t value Pr(>|t|)    
(Intercept)                                      179.96505  345.58058   0.521 0.602547    
hora                                              -6.17056    1.15569  -5.339 9.57e-08 ***
dist_meters                                        0.04179    0.00162  25.805  < 2e-16 ***
velocidad                                          0.65576    0.11019   5.951 2.77e-09 ***
`Transporte_Taxi de Sitio`                       -83.55093   15.69107  -5.325 1.04e-07 ***
`Transporte_Taxi Libre`                         -108.81500   15.66844  -6.945 4.07e-12 ***
Transporte_Uber                                  -81.29681   27.69437  -2.935 0.003339 ** 
dia_semana_lun.                                   52.01369   15.64810   3.324 0.000891 ***
dia_semana_mar.                                   62.27810   15.36937   4.052 5.12e-05 ***
dia_semana_mié.                                   55.21928   15.24740   3.622 0.000295 ***
dia_semana_jue.                                   70.44571   15.58968   4.519 6.31e-06 ***
dia_semana_vie.                                   73.77837   15.61969   4.723 2.36e-06 ***
dia_semana_sáb.                                   11.30106   16.58463   0.681 0.495626    
mes_ene.                                          -1.20451   20.33097  -0.059 0.952758    
mes_feb.                                          27.30426   23.09742   1.182 0.237186    
mes_mar.                                          54.17458   20.00286   2.708 0.006776 ** 
mes_may.                                           1.75828   20.10668   0.087 0.930318    
mes_jun.                                         -29.58600   18.07054  -1.637 0.101615    
mes_jul.                                         -11.81111   18.87235  -0.626 0.531435    
mes_ago.                                          44.97814   23.77685   1.892 0.058568 .  
mes_sep.                                          41.17791   24.82598   1.659 0.097221 .  
mes_oct.                                          39.44482   21.47949   1.836 0.066334 .  
mes_nov.                                          30.59349   20.58033   1.487 0.137174    
mes_dic.                                          60.72339   20.81202   2.918 0.003535 ** 
.......                                           ........   ........   ..... ........
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 343.2 on 8436 degrees of freedom
Multiple R-squared:  0.1501,	Adjusted R-squared:  0.1436 
F-statistic: 23.28 on 64 and 8436 DF,  p-value: < 2.2e-16
```
Se puede apreciar que la puntuación de R-squared es de tan solo 0.15, esto nos indica que el modelo no es preciso, aun así se realizó otro modelo con las variables mas significativas (con p-value menos a 0.1)

```R
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
```
El resultado de la función `summary`:
```
Residuals:
   Min     1Q Median     3Q    Max 
-921.3 -173.0  -87.1   54.7 3248.7 

Coefficients:
                             Estimate Std. Error t value Pr(>|t|)    
(Intercept)                 3.041e+02  1.664e+01  18.276  < 2e-16 ***
hora                       -6.456e+00  1.155e+00  -5.592 2.31e-08 ***
dist_meters                 4.233e-02  1.616e-03  26.198  < 2e-16 ***
velocidad                   6.444e-01  1.110e-01   5.803 6.73e-09 ***
`Transporte_Taxi de Sitio` -1.517e+02  1.368e+01 -11.089  < 2e-16 ***
`Transporte_Taxi Libre`    -2.088e+02  1.236e+01 -16.894  < 2e-16 ***
Transporte_Uber            -1.671e+02  2.596e+01  -6.438 1.27e-10 ***
dia_semana_lun.             5.131e+01  1.283e+01   4.001 6.37e-05 ***
dia_semana_mar.             5.807e+01  1.247e+01   4.656 3.27e-06 ***
dia_semana_mié.             5.360e+01  1.228e+01   4.365 1.29e-05 ***
dia_semana_jue.             6.394e+01  1.268e+01   5.044 4.66e-07 ***
dia_semana_vie.             6.763e+01  1.273e+01   5.314 1.10e-07 ***
mes_mar.                    6.432e+01  1.487e+01   4.325 1.54e-05 ***
mes_dic.                    5.150e+01  1.397e+01   3.688 0.000228 ***
mes_sep.                    4.711e+01  1.951e+01   2.415 0.015759 *  
mes_oct.                    4.337e+01  1.521e+01   2.851 0.004364 ** 
mes_ago.                    5.041e+01  1.795e+01   2.809 0.004982 ** 
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 346.5 on 8484 degrees of freedom
Multiple R-squared:  0.1286,	Adjusted R-squared:  0.127 
F-statistic: 78.28 on 16 and 8484 DF,  p-value: < 2.2e-16
```
Los dos modelos no presentaron una presición suficientes como para considerarlos confiables, esto era de esperarse puesto que los modelos que se usan en la industria para predecir el tráfico son mucho mas complejos que una regresión lineal.
Cabe destacar que entre las variables significativas para el modelo se encuentran el tipo de transporte, los días de la semana que, como se habia visto gráficamente, disminuye el tiempo de espera en sábado y domingo. Tambien aparecen los meses de diciembre, marzo, agosto, septiembre y octubre, que coinciden con festividades o periodos vacacionales.


#### Conclusiones
Se observó gráficamente que el promedio de tiempo de espera parece ser menor en los Uber que en los Taxis, en otras secciónes se comprobará esto de manera formal usando un contraste de hipótesis. Otra cosa que se observo es que tanto el tiempo de espera promedio como los viajes de transporte privado disminuyen en los días sábado y domíngo.












