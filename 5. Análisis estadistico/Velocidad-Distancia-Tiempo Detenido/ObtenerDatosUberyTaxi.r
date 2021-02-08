#Cargar librerias
library(dplyr);
library(ggplot2);
library(DescTools);

#install.packages("ggthemes"); install.packages("lubridate");
#install.packages("tidyr"); install.packages("DT");
#install.packages("scales");
library(ggthemes);
library(lubridate);
library(tidyr);
library(DT);
library(scales);

dev.off()

datos <-  read.csv("cdmx_rutas_municipiosVel.csv", header = T)
datosF<-select(datos, Transporte,trip_duration,trip_duration_hrs,dist_meters,dist_km,wait_sec,wait_min,
               Vel_mts_seg ,Vel_km_hr);

# Analizamos los diferentes tipos de transporte de los que disponemos
tiposT<- unique(datosF$Transporte);
tiposT # 3 tipos de taxi VS 4 tipos de Uber
#Taxi de Sitio" "Taxi Libre"    "UberX"         "Radio Taxi"    "UberBlack"     "UberXL"        "UberSUV"


#Agrupamos juntos todos los tipos de Uber
target <- c("UberX","UberBlack","UberXL","Ube rSUV")
datosUber <- filter(datosF,Transporte %in% target)
datosUber;
dim(datosUber);



# DURACION DEL VIAJE
summary(datosUber$trip_duration);
#Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#40.0   360.5   595.0   757.5  1071.5  2470.0 

IQR(datosF$trip_duration); #716
360.5 - (1.5 *IQR(datosF2$trip_duration));  # -713.5
1071.5 + (1.5 *IQR(datosF2$trip_duration)); # 2145.5

datosUber<- filter(datosUber, trip_duration <= 2145.5);
# Seleccionamos velocidades posibles 2470.0
dim(datosUber)

ggplot(datosUber, aes(x = trip_duration,  fill = Transporte)) + geom_boxplot() +
  ggtitle("Boxplots Duracion de los viajes Uber") +
  xlab("Duracion") +
  ylab("Mediciones");


IQR(datosUber$trip_duration); #796
71 - (1.5 *IQR(datosUber$trip_duration));  # -1123
867 + (1.5 *IQR(datosUber$trip_duration)); # 2061
hist(datosUber$trip_duration)

datosUber %>%
  ggplot() + 
  aes(trip_duration) +
  geom_histogram(binwidth = 300, col="black", fill = "blue") + 
  ggtitle("PROMEDIO DE DURACION DE LOS VIAJES UBER") +
  ylab("Frecuencia") +
  xlab("Mediciones") + 
  theme_light();
dev.off();


grupoUber <- datosUber %>%
  group_by(Transporte,trip_duration ) %>%
  dplyr::summarize(Total = n());

ggplot(grupoUber, aes(trip_duration, Total, fill = Transporte)) + 
  geom_bar( stat = "identity") +
  ggtitle("Viajes por distancia y por Tipo Uber") +
  scale_y_continuous(labels = comma) +
  xlim(300,2145.5);

aes(trip_duration) +
  geom_histogram(binwidth = 200, col="black", fill = "blue") + 
  ggtitle("PROMEDIO DE DURACION DE LOS VIAJES EN GENERAL") +
  
  datosUber$di
############################################################################
#DISTANCIA VIAJE
summary(datosUber$dist_meters);
#Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#515    1222    2522    3256    4273    9061 

IQR(datosUber$dist_meters); #3050.5
1222 - (1.5 *IQR(datosUber$dist_meters));  # -3353.75
4273 + (1.5 *IQR(datosUber$dist_meters)); # 8848.75

datosUberF<- filter(datosUber, dist_meters <= 8848.75);

datosUberF %>%
  ggplot() + 
  aes(dist_meters) +
  geom_histogram(binwidth = 2000, col="black", fill = "blue") +
  ggtitle("PROMEDIO DE DISTANCIA DE LOS VIAJES uber") +
  ylab("Frecuencia") +
  xlab("Distancia de viaje (mts)") +
  theme_light();
dev.off();


ggplot(datosUber, aes(x = dist_meters,  fill = Transporte)) + geom_boxplot() +
  ggtitle("Boxplots Distancias de los viajes Uber") +
  xlab("Distancia (mts)") +
  ylab("Mediciones");


#dist meters
grupoTaxiUberDm <- datosUberF %>%
  group_by(Transporte,dist_meters ) %>%
  dplyr::summarize(Total = n());


#dist meters
ggplot(grupoTaxiUberDm, aes(dist_meters, Total, fill = Transporte)) + 
  geom_bar( stat = "identity") +
  #  geom_bar(stat = "identity", width = 500,colour="black") +
  #  theme_bw() +
  ggtitle("Viajes por distancia Uber") +
   scale_y_continuous(labels = comma) +
#  ylim(0,1)+
  xlim(0,9000);
dev.off();

############################################################################
#TIEMPOS DE ESPERA EN EL TRAFICO
summary(datosUber$wait_sec);
#Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#0.0    64.0   162.0   572.5   359.0  7498.0

#Mode(datosF2$wait_sec);

IQR(datosUber$wait_sec); #295
64.0 - (1.5 *IQR(datosUber$wait_sec));  # -378.5
359.0 + (1.5 *IQR(datosUber$wait_sec)); # 801.5

dim(datosUber);dim(datosUberF);

datosUberF<-filter(datosUber, wait_sec <= 801.5) # 

datosUberF %>%
  ggplot() + 
  aes(wait_sec) +
  geom_histogram(binwidth = 50, col="black", fill = "blue") + 
  ggtitle("PROMEDIO DE LOS TIEMPOS DE ESPERA Uber") +
  ylab("Frecuencia") +
  xlab("Tiempos de espera") + 
  theme_light();
dev.off();


#wait_sec
grupoTaxiUberWS <- datosUberF %>%
  group_by(Transporte,wait_sec ) %>%
  dplyr::summarize(Total = n());


#wait_sec
ggplot(grupoTaxiUberWS, aes(wait_sec, Total, fill = Transporte)) + 
  geom_bar( stat = "identity") +
  ggtitle("Viajes por tiempo detenido Uber") +
 scale_y_continuous(labels = comma) +
#  ylim(0,7)+
  xlim(0,700);


summary(datosUberF$wait_sec);
#Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#0.00   52.75  114.50  172.19  254.25  745.00 

IQR(datosUberF$wait_sec); #295
52.75 - (1.5 *IQR(datosUberF$wait_sec));  # -378.5
359.0 + (1.5 *IQR(datosUberF$wait_sec)); # 801.5

dim(datosUber);dim(datosUberF);

datosUberF<-filter(datosUber, wait_sec <= 801.5) # 



############################################################################
#VELOCIDADES EN EL TRANSPORTE
summary(datosUber$Vel_km_hr);
#Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#   1.80   11.00   17.56   19.68   23.32   85.62

IQR(datosUber$Vel_km_hr); #12.32
11.00 - (1.5 *IQR(datosUber$Vel_km_hr));  # -7.48
23.32 + (1.5 *IQR(datosUber$Vel_km_hr)); # 41.8

datosFV<-filter(datosUber, Vel_km_hr <= 41.8) # Seleccionamos velocidades posibles

datosFV %>%
  ggplot() + 
  aes(Vel_km_hr) +
  geom_histogram(binwidth = 2, col="black", fill = "blue") +
  ggtitle("PROMEDIO DE Velocidad DE LOS VIAJES Uber") +
  ylab("Frecuencia") +
  xlab("Velocidad Promedio en el viaje (km/h)") +
  theme_light();
dev.off();

#dist meters
grupoTaxiUberDm <- datosFV %>%
  group_by(Transporte,Vel_km_hr ) %>%
  dplyr::summarize(Total = n());


#dist meters
ggplot(grupoTaxiUberDm, aes(Vel_km_hr, Total, fill = Transporte)) + 
  geom_bar( stat = "identity") +
  #  geom_bar(stat = "identity", width = 500,colour="black") +
  #  theme_bw() +
  ggtitle("Viajes por distancia Uber") +
  scale_y_continuous(labels = comma) +
  #ylim(0,3)+
  xlim(1,40);
dev.off();


###############################################################################
###############################################################################
################################# TAXIS #####################################
###############################################################################
###############################################################################
  
  
  
datos <-  read.csv("cdmx_rutas_municipiosVel.csv", header = T);
datosF<-select(datos, Transporte,trip_duration,trip_duration_hrs,dist_meters,dist_km,wait_sec,wait_min,
               Vel_mts_seg ,Vel_km_hr);

# Analizamos los diferentes tipos de transporte de los que disponemos
tiposT<- unique(datosF$Transporte);
tiposT # 3 tipos de taxi VS 4 tipos de Uber
#Taxi de Sitio" "Taxi Libre"    "UberX"         "Radio Taxi"    "UberBlack"     "UberXL"        "UberSUV"


#Agrupamos juntos todos los tipos de Uber
target <- c("Taxi de Sitio","Taxi Libre","Radio Taxi")
datosTaxi <- filter(datosF,Transporte %in% target)
datosTaxi;
dim(datosTaxi);#7350



# DURACION DEL VIAJE
summary(datosTaxi$trip_duration);
#Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#22.0   449.0   738.0   863.1  1164.8  2684.0

IQR(datosTaxi$trip_duration); #715.75
449.0 - (1.5 *IQR(datosTaxi$trip_duration));  # -624.62
1164.8 + (1.5 *IQR(datosTaxi$trip_duration)); # 2238.42

datosTaxiF<- filter(datosTaxi, trip_duration <= 2238.42);
# Seleccionamos velocidades posibles 2470.0
dim(datosTaxi)
dim(datosTaxiF)

ggplot(datosTaxiF, aes(x = trip_duration,  fill = Transporte)) + geom_boxplot() +
  ggtitle("Boxplots Duracion de los viajes Taxi") +
  xlab("Duracion") +
  ylab("Mediciones");

datosTaxiF %>%
  ggplot() + 
  aes(trip_duration) +
  geom_histogram(binwidth =200, col="black", fill = "blue") + 
  ggtitle("PROMEDIO DE DURACION DE LOS VIAJES Taxi") +
  ylab("Frecuencia") +
  xlab("Duracion (segundos)") + 
  theme_light();
dev.off();

grupoTaxi <- datosTaxiF %>%
  group_by(Transporte,trip_duration ) %>%
  dplyr::summarize(Total = n());


#dist meters
grupoTaxiUberDm <- datosTaxiF %>%
  group_by(Transporte,trip_duration ) %>%
  dplyr::summarize(Total = n());

ggplot(grupoTaxiUberDm, aes(trip_duration, Total, fill = Transporte)) + 
  geom_bar( stat = "identity") +
  ggtitle("Viajes por duracion Taxi") +
  scale_y_continuous(labels = comma) +
  xlim(20,2240);




  
  
  ############################################################################
#DISTANCIA VIAJE
summary(datosTaxi$dist_meters);
#Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 500    1847    3164    3645    5098    9130

IQR(datosTaxi$dist_meters); #3251
1847 - (1.5 *IQR(datosTaxi$dist_meters));  # -3029.5
5098 + (1.5 *IQR(datosTaxi$dist_meters)); # 9974.5

datosTaxi %>%
  ggplot() + 
  aes(dist_meters) +
  geom_histogram(binwidth = 1500, col="black", fill = "blue") +
  ggtitle("PROMEDIO DE DISTANCIA DE LOS VIAJES Taxi") +
  ylab("Frecuencia") +
  xlab("Distancia de viaje (mts)") +
  theme_light();
dev.off();


ggplot(datosTaxi, aes(x = dist_meters,  fill = Transporte)) + geom_boxplot() +
  ggtitle("Boxplots Distancias de los viajes Taxi") +
  xlab("Distancia (mts)") +
  ylab("Mediciones");


#dist meters
grupoTaxiUberDm <- datosTaxi %>%
  group_by(Transporte,dist_meters ) %>%
  dplyr::summarize(Total = n());


#dist meters
ggplot(grupoTaxiUberDm, aes(dist_meters, Total, fill = Transporte)) + 
  geom_bar( stat = "identity") +
  #  geom_bar(stat = "identity", width = 500,colour="black") +
  #  theme_bw() +
  ggtitle("Viajes por distancia Taxi") +
  scale_y_continuous(labels = comma) +
  #  ylim(0,1)+
  xlim(499,9131);
dev.off();

############################################################################
#TIEMPOS DE ESPERA EN EL TRAFICO
summary(datosTaxi$wait_sec);
#Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#0.0    84.0   190.0   350.6   397.0  8662.0 

IQR(datosTaxi$wait_sec); #313
84.0 - (1.5 *IQR(datosTaxi$wait_sec));  # -385.5
397.0 + (1.5 *IQR(datosTaxi$wait_sec)); # 866.5

datosTaxiF<-filter(datosTaxi, wait_sec <= 866.5) # 
dim(datosTaxi);dim(datosTaxiF);

datosTaxiF %>%
  ggplot() + 
  aes(wait_sec) +
  geom_histogram(binwidth = 50, col="black", fill = "blue") + 
  ggtitle("PROMEDIO DE LOS TIEMPOS DE ESPERA Taxi") +
  ylab("Frecuencia") +
  xlab("Tiempos de espera") + 
  theme_light();
dev.off();


#wait_sec
grupoTaxiUberWS <- datosTaxiF %>%
  group_by(Transporte,wait_sec ) %>%
  dplyr::summarize(Total = n());


#wait_sec
ggplot(grupoTaxiUberWS, aes(wait_sec, Total, fill = Transporte)) + 
  geom_bar( stat = "identity") +
  ggtitle("Viajes por tiempo detenido Taxi") +
  scale_y_continuous(labels = comma) +
  #  ylim(0,7)+
  xlim(0,866.5);





summary(datosTaxiF$wait_sec);
#Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
0.0    78.0   169.0   229.1   324.0   866.0 

IQR(datosTaxi$wait_sec); #313
84.0 - (1.5 *IQR(datosTaxi$wait_sec));  # -385.5
397.0 + (1.5 *IQR(datosTaxi$wait_sec)); # 866.5

############################################################################
#VELOCIDADES EN EL TRANSPORTE
summary(datosTaxi$Vel_km_hr);
#Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#0.74   12.17   16.27   17.44   20.70  193.09 

IQR(datosTaxi$Vel_km_hr); #12.32
12.17 - (1.5 *IQR(datosTaxi$Vel_km_hr)); # -0.62125
20.70 + (1.5 *IQR(datosTaxi$Vel_km_hr)); # 33.49125

datosTaxiF<-filter(datosTaxi, Vel_km_hr <= 33.5) # Seleccionamos velocidades posibles

datosTaxiF<-filter(datosTaxi, wait_sec <= 866.5) # 
dim(datosTaxi);dim(datosTaxiF);

datosTaxiF %>%
  ggplot() + 
  aes(Vel_km_hr) +
  geom_histogram(binwidth = 3, col="black", fill = "blue") +
  ggtitle("PROMEDIO DE Velocidad DE LOS VIAJES Taxi") +
  ylab("Frecuencia") +
  xlab("Velocidad Promedio en el viaje (km/h)") +
  theme_light();
dev.off();

#velocidad
grupoTaxiUberDm <- datosTaxiF %>%
  group_by(Transporte,Vel_km_hr ) %>%
  dplyr::summarize(Total = n());


#velocidad
ggplot(grupoTaxiUberDm, aes(Vel_km_hr, Total, fill = Transporte)) + 
  geom_bar( stat = "identity") +
  #  geom_bar(stat = "identity", width = 500,colour="black") +
  #  theme_bw() +
  ggtitle("Velocidad promedio Taxi") +
  scale_y_continuous(labels = comma) +
  #ylim(0,3)+
  xlim(0,34);
dev.off();
  
  

datosTaxiF<-filter(datosTaxi, Vel_km_hr <= 34) #
datosUberF<-filter(datosUber, wait_sec <= 42) # 


summary(datosTaxiF$Vel_km_hr);
summary(datosUberF$Vel_km_hr);

###############################################################################
###############################################################################
########################### PRUEBAS DE HIPÓTESIS ##############################
###############################################################################
###############################################################################

# 1.- Se desea probar que el promedio de tiempo detenido en el viaje es menor en 
#     viajes con Ubers que con Taxis

# Taxis : 1 ----- Ubers : 2
# Obtención de los datos

(n1 <- length(datosTaxiF$wait_sec))
(x1 <- mean(datosTaxiF$wait_sec))
(var1 <- var(datosTaxiF$wait_sec))

(n2 <- length(datosUberF$wait_sec))
(x2 <- mean(datosUberF$wait_sec))
(var2 <- var(datosUberF$wait_sec))

# Cálculo de los estadísticos
# H_0: mu1-mu2 = 0 | H_1: mu1-mu2 > 0
delta = 0
(Z = (x1-x2-delta)/sqrt((var1/n1)+(var2/n2)))
(Z.05 = qnorm(p=0.05, lower.tail = FALSE))
(Z>=Z.05)
# Z >= Z.05: TRUE
# Se rechaza H_0
# Como se había planteado, los uber pasan menos tiempo detenidos durante el trayecto

######################################################################################

# 2.- Se desea probar que el promedio de distancias recorridad por taxis es mayor
#     al de los uber

# Taxis : 1 ----- Ubers : 2
# Obtención de los datos

(n1 <- length(datosTaxiF$dist_meters))
(x1 <- mean(datosTaxiF$dist_meters))
(var1 <- var(datosTaxiF$dist_meters))

(n2 <- length(datosUberF$dist_meters))
(x2 <- mean(datosUberF$dist_meters))
(var2 <- var(datosUberF$dist_meters))

# Cálculo de los estadísticos
# H_0: mu1-mu2 = 0 | H_1: mu1-mu2 < 0
delta = 0
(Z = (x1-x2-delta)/sqrt((var1/n1)+(var2/n2)))
(Z.05 = -qnorm(p=0.05, lower.tail = FALSE))
(Z>=Z.05)
# Z >= Z.05: TRUE
# Se rechaza H_0
# Como se había planteado, los taxis toman viajes más largos que los ubers















