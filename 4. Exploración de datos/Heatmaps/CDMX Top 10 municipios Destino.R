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

### Gráfico municipios de destino por tipo de transporte
ggplot(municipio.transporte.d) +
  geom_bar(aes(x = reorder(Transporte, n), y=n, fill = Transporte), stat = "identity", show.legend = FALSE) +
  coord_flip(clip = 'off') + ggtitle("municipios de destino") +
  facet_wrap(municipios_destino~., scales = "free_x",  strip.position = "top") 

### Gráfico municipios de destino por taxi libre
ggplot(filter(municipio.transporte.d, Transporte == "Taxi Libre")) +
  geom_bar(aes(x = reorder(municipios_destino, n), y=n, fill = municipios_destino), stat = "identity", show.legend = FALSE) +
  coord_flip(clip = 'off') + ggtitle("Municipios de destino Taxi Libre")

### Gráfico municipios de destino por Taxi de Sitio
ggplot(filter(municipio.transporte.d, Transporte == "Taxi de Sitio")) +
  geom_bar(aes(x = reorder(municipios_destino, n), y=n, fill = municipios_destino), stat = "identity", show.legend = FALSE) +
  coord_flip(clip = 'off') + ggtitle("Municipios de destino Taxi de Sitio")

### Gráfico municipios de destino por Radio Taxi
ggplot(filter(municipio.transporte.d, Transporte == "Radio Taxi")) +
  geom_bar(aes(x = reorder(municipios_destino, n), y=n, fill = municipios_destino), stat = "identity", show.legend = FALSE) +
  coord_flip(clip = 'off') + ggtitle("Municipios de destino Radio Taxi")

### Gráfico municipios de destino por UberX
ggplot(filter(municipio.transporte.d, Transporte == "UberX")) +
  geom_bar(aes(x = reorder(municipios_destino, n), y=n, fill = municipios_destino), stat = "identity", show.legend = FALSE) +
  coord_flip(clip = 'off') + ggtitle("Municipios de destino UberX")

### Gráfico municipios de destino por UberXL
ggplot(filter(municipio.transporte.d, Transporte == "UberXL")) +
  geom_bar(aes(x = reorder(municipios_destino, n), y=n, fill = municipios_destino), stat = "identity", show.legend = FALSE) +
  coord_flip(clip = 'off') + ggtitle("Municipios de destino UberXL")

### Gráfico municipios de destino por UberSUV
ggplot(filter(municipio.transporte.d, Transporte == "UberSUV")) +
  geom_bar(aes(x = reorder(municipios_destino, n), y=n, fill = municipios_destino), stat = "identity", show.legend = FALSE) +
  coord_flip(clip = 'off') + ggtitle("Municipios de destino UberSUV")

### Gráfico municipios de destino por UberBlack
ggplot(filter(municipio.transporte.d, Transporte == "UberBlack")) +
  geom_bar(aes(x = reorder(municipios_destino, n), y=n, fill = municipios_destino), stat = "identity", show.legend = FALSE) +
  coord_flip(clip = 'off') + ggtitle("Municipios de destino UberBlack")
