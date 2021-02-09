### Cargamos las paqueterias
library(tidyverse)
library(lubridate)

### Cargamos los datos a la workspace
municipios.cdmx <- read.csv("cdmx_transporte_clean3.csv", stringsAsFactors=T)

### Municipio de destino
(col.mun.destino<-select(municipios.cdmx, municipios_destino) %>% 
    group_by(municipios_destino) %>%
    count(municipios_destino, sort = TRUE))

### Alcadias de destino por Transporte
(municipio.transporte.d<-select(municipios.cdmx, Transporte, municipios_destino) %>% 
    group_by(municipios_destino, Transporte) %>%
    count(municipios_destino,sort = TRUE))

###top tiempo de espera misma alcaldia
mun.time <- select(cdmx.rutas, municipios_origen, municipios_destino, wait_sec)
mun.same<-filter(mun.time, municipios_origen == municipios_destino)

count.same.mun<-mun.same %>% group_by(municipios_origen)  %>%
  count(municipios_destino, sort = TRUE)

write.csv(count.same.mun, "viajessinsalirmun.csv")

# uber tiempo de espera
(unber.mun<-filter(mun.same, wait_sec > 172.19) %>% group_by(municipios_origen)  %>%
  count(municipios_destino, sort = TRUE))

write.csv(unber.mun, "tiempodeesperamun.csv")

(unber.mun<-filter(mun.same, wait_sec > 0) %>% group_by(municipios_origen)  %>%
    count(municipios_destino, sort = TRUE))


0.
### Gráfico municipios de destino por tipo de transporte
ggplot(municipio.transporte.d) +
  geom_bar(aes(x = reorder(Transporte, n), y=n, fill = Transporte), stat = "identity", show.legend = FALSE) +
  coord_flip(clip = 'off') + ggtitle("municipios de destino") +
  facet_wrap(municipios_destino~., scales = "free_x",  strip.position = "top") 

1.
patron.t <- '(Taxi)'
pos.t<-grep(patron.t, municipio.transporte.d$Transporte)

all.taxis<-municipio.transporte.d[pos.t,]


ggplot(filter(all.taxis, n>56)) +
  geom_bar(aes(x = reorder(Transporte, -n), y=n, fill = municipios_destino, group= municipios_destino),
           colour = "white",stat = "identity", position = "dodge", show.legend = FALSE) +
  geom_text(aes(x = reorder(Transporte, -n), y=n, label = as.character(n), group = municipios_destino),
            position = position_dodge(width = 0.9),
            hjust = 0.5, size = 3, vjust=-0.4) +
  geom_text(aes(x = reorder(Transporte, -n), y=n, label = as.character(municipios_destino), group = municipios_destino),
            position = position_dodge(width = 0.9),
            hjust = 1.2, size = 2, angle = 90) +
  scale_y_continuous(limits=c(-90,1040)) + theme(axis.title.x=element_blank(),
                                                 axis.ticks.x=element_blank()) + ylab("N�mero de viajes") +
  labs(title="Municipios destino por tipo de taxi", subtitle = "CDMX")

2.
patron.u <- '(Uber)'
pos.u<-grep(patron.u, municipio.transporte.d$Transporte)

all.uber<-municipio.transporte.d[pos.u,]

ggplot(filter(all.uber, n>=2)) +
  geom_bar(aes(x = reorder(Transporte, -n), y=n, fill = municipios_destino, group= municipios_destino),
           colour = "white",stat = "identity", position = "dodge", show.legend = FALSE) +
  geom_text(aes(x = reorder(Transporte, -n), y=n, label = as.character(n), group = municipios_destino),
            position = position_dodge(width = 0.9),
            hjust = 0.5, size = 3, vjust=-0.4) +
  geom_text(aes(x = reorder(Transporte, -n), y=n, label = as.character(municipios_destino), group = municipios_destino),
            position = position_dodge(width = 0.93),
            vjust=.4,hjust = 1.2, size = 2, angle = 90) +
  scale_y_continuous(limits=c(-1,16)) + theme(axis.title.x=element_blank(),
                                              axis.ticks.x=element_blank()) + ylab("N�mero de viajes") +
  labs(title="Municipios destino por tipo de Uber", subtitle = "CDMX")


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
