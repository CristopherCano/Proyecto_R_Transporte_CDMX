### Cargamos las paqueterias
library(tidyverse)
library(lubridate)

### Cargamos los datos a la workspace
municipios.cdmx <- read.csv("cdmx_rutas_municipios.csv", stringsAsFactors=T)

### Municipio de origen
(col.mun.origen<-select(municipios.cdmx, municipios_origen) %>% 
  group_by(municipios_origen) %>%
  count(municipios_origen, sort = TRUE))

### Convertimos a date la columna pickup_date
(col.mun.origen$pickup_date<-as.Date(col.mun.origen$pickup_date,"%d/%m/%Y"))

### Ordenamos las fechas en orden ascendete de año
col.mun.origen<-arrange(col.mun.origen, pickup_date)

### Municipio de destino
(col.mun.destino<-select(municipios.cdmx, municipios_destino) %>% 
  group_by(municipios_destino) %>%
  count(municipios_destino, sort = TRUE))

### Tipo de transporte
(tipo.transporte<-select(municipios.cdmx, Transporte) %>% 
    group_by(Transporte) %>%
    count(Transporte, sort = TRUE))

### Alcadias de origen por Taxi Libre
(municipio.transporte.o<-select(municipios.cdmx, Transporte, municipios_origen) %>% 
    group_by(municipios_origen, Transporte) %>%
    count(municipios_origen,sort = TRUE))

### Alcadias de destino por Taxi Libre
(municipio.transporte.d<-select(municipios.cdmx, Transporte, municipios_destino) %>% 
    group_by(municipios_destino, Transporte) %>%
    count(municipios_destino,sort = TRUE))

### Gráfico Municipios más populares de origen  
ggplot(col.mun.origen[1:10,]) +
  geom_bar(aes(x = reorder(municipios_origen, n), y=n, fill = municipios_origen), stat = "identity") +
  coord_flip(clip = 'off') + ggtitle("municipios de origen") 

### Gráfico Municipios más populares de destino
ggplot(col.mun.destino[1:10,]) +
  geom_bar(aes(x = reorder(municipios_destino, n), y=n, fill = municipios_destino), stat = "identity") +
  coord_flip(clip = 'off') + ggtitle("municipios de destino")

### Gráfico de barras tipo de transporte
ggplot(tipo.transporte) +
  geom_bar(aes(x = reorder(Transporte, n), y=n, fill = Transporte), stat = "identity", show.legend = FALSE) +
  coord_flip(clip = 'off') + ggtitle("municipios de destino")

### Gráfico municipios de origen por tipo de transporte
ggplot(municipio.transporte.o) +
  geom_bar(aes(x = reorder(Transporte, n), y=n, fill = Transporte), stat = "identity", show.legend = FALSE) +
  coord_flip(clip = 'off') + ggtitle("municipios de destino") +
  facet_wrap(municipios_origen~., scales = "free_x",  strip.position = "top") 

### Gráfico municipios de origen por taxi libre
ggplot(filter(municipio.transporte.o, Transporte == "Taxi Libre")) +
  geom_bar(aes(x = reorder(municipios_origen, n), y=n, fill = municipios_origen), stat = "identity", show.legend = FALSE) +
  coord_flip(clip = 'off') + ggtitle("Municipios de origen Taxi Libre")

### Gráfico municipios de origen por Taxi de Sitio
ggplot(filter(municipio.transporte.o, Transporte == "Taxi de Sitio")) +
  geom_bar(aes(x = reorder(municipios_origen, n), y=n, fill = municipios_origen), stat = "identity", show.legend = FALSE) +
  coord_flip(clip = 'off') + ggtitle("Municipios de origen Taxi de Sitio")

### Gráfico municipios de origen por Radio Taxi
ggplot(filter(municipio.transporte.o, Transporte == "Radio Taxi")) +
  geom_bar(aes(x = reorder(municipios_origen, n), y=n, fill = municipios_origen), stat = "identity", show.legend = FALSE) +
  coord_flip(clip = 'off') + ggtitle("Municipios de origen Radio Taxi")

### Gráfico municipios de origen por UberX
ggplot(filter(municipio.transporte.o, Transporte == "UberX")) +
  geom_bar(aes(x = reorder(municipios_origen, n), y=n, fill = municipios_origen), stat = "identity", show.legend = FALSE) +
  coord_flip(clip = 'off') + ggtitle("Municipios de origen UberX")

### Gráfico municipios de origen por UberXL
ggplot(filter(municipio.transporte.o, Transporte == "UberXL")) +
  geom_bar(aes(x = reorder(municipios_origen, n), y=n, fill = municipios_origen), stat = "identity", show.legend = FALSE) +
  coord_flip(clip = 'off') + ggtitle("Municipios de origen UberXL")

### Gráfico municipios de origen por UberSUV
ggplot(filter(municipio.transporte.o, Transporte == "UberSUV")) +
  geom_bar(aes(x = reorder(municipios_origen, n), y=n, fill = municipios_origen), stat = "identity", show.legend = FALSE) +
  coord_flip(clip = 'off') + ggtitle("Municipios de origen UberSUV")

### Gráfico municipios de origen por UberBlack
ggplot(filter(municipio.transporte.o, Transporte == "UberBlack")) +
  geom_bar(aes(x = reorder(municipios_origen, n), y=n, fill = municipios_origen), stat = "identity", show.legend = FALSE) +
  coord_flip(clip = 'off') + ggtitle("Municipios de origen UberBlack")
