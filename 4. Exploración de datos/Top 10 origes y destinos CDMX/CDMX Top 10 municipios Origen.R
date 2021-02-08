### Cargamos las paqueterias
library(dplyr)
library(ggplot2)


### Cargamos los datos a la workspace
municipios.cdmx <- read.csv("cdmx_transporte_clean3.csv", stringsAsFactors=T)

### Municipio de origen
(col.mun.origen<-select(municipios.cdmx, municipios_origen) %>% 
  group_by(municipios_origen) %>%
  count(municipios_origen, sort = TRUE))

### Municipio de destino
(col.mun.destino<-select(municipios.cdmx, municipios_destino) %>% 
    group_by(municipios_destino) %>%
    count(municipios_destino, sort = TRUE))

### Datafram agrupando municipios por origen y destino
col.mun.origen$lugar <- rep("origen", 40)
col.mun.destino$lugar <- rep("destino", 40)

col.mun.origen<-rename(col.mun.origen, municipios = "municipios_origen")
col.mun.destino<-rename(col.mun.destino, municipios = "municipios_destino")

destinos <- rbind2(col.mun.origen, col.mun.destino)
destinos

0.
ggplot(filter(destinos, n>400)) +
  geom_bar(aes(x = reorder(municipios, n), y=n, fill = lugar), 
           stat = "identity", show.legend = FALSE) + facet_wrap(lugar~., scales = "free_y") +
  coord_flip(clip = 'off') + 
  geom_text(aes(x = reorder(municipios, n), 
                y=n, label = as.character(n)), nudge_y = 0.5) +
  labs(title="Origen y destino más frecuetes", subtitle = "CDMX", xlab ) +
  ylab("Número de viajes") + theme(axis.title.y=element_blank(),
                                   axis.ticks.y=element_blank())+
  scale_fill_manual(values=c("#ff0033", "#00b3ff")) 


### Tipo de transporte
tipo.transporte<-select(municipios.cdmx, Transporte) %>% 
    group_by(Transporte) %>%
    count(Transporte, sort = TRUE)

2.
### GrÃ¡fico de barras tipo de transporte
ggplot(tipo.transporte) +
  geom_bar(aes(x = reorder(Transporte, n), y=n, fill = Transporte), stat = "identity", show.legend = FALSE) +
  geom_text(aes(x = reorder(Transporte, n), y=n, label = as.character(n)), nudge_y = 120) +
  coord_flip(clip = 'off') +
  labs(title="Tipo de Transporte", subtitle = "CDMX") +
  ylab("Número de viajes") + theme(axis.title.y=element_blank(),
                                   axis.ticks.y=element_blank()) +
  scale_fill_manual(values=c("#ffcc00", "#ffd633","#ffdb4d", "#0033ff","#ff0033","#000000","#262626"))


### Alcadias de origen por Transporte
(municipio.transporte.o<-select(municipios.cdmx, Transporte, municipios_origen) %>% 
    group_by(municipios_origen, Transporte) %>%
    count(municipios_origen,sort = TRUE))




3.
### GrÃ¡fico municipios de origen por tipo de transporte
ggplot(filter(municipio.transporte.o, n > 2)) +
  geom_bar(aes(x = reorder(Transporte, n), y=n, fill = Transporte), stat = "identity", show.legend = FALSE) +
  coord_flip(clip = 'off') +
  geom_text(aes(x = reorder(Transporte, n), y=n, label = as.character(n)), nudge_y = 10, size=2.1) +
  facet_wrap(municipios_origen~., scales = "free_x",  strip.position = "top") + ylab("Número de viajes") +
  labs(title="Municipios origen", subtitle = "CDMX") + theme(axis.title.y=element_blank(),
                                                               axis.ticks.y=element_blank()) +
  scale_fill_manual(values=c("#ffcc00", "#ffd633","#ffdb4d", "#0033ff","#ff0033","#000000","#262626")) 



4.
patron.t <- '(Taxi)'
pos.t<-grep(patron.t, municipio.transporte.o$Transporte)

all.taxis<-municipio.transporte.o[pos.t,]


ggplot(filter(all.taxis, n>56, municipios_origen != "Cuajimalpa de Morelos")) +
  geom_bar(aes(x = reorder(Transporte, -n), y=n, fill = municipios_origen, group= municipios_origen),
           colour = "white",stat = "identity", position = "dodge", show.legend = FALSE) +
  geom_text(aes(x = reorder(Transporte, -n), y=n, label = as.character(n), group = municipios_origen),
            position = position_dodge(width = 0.9),
            hjust = 0.5, size = 3, vjust=-0.4) +
  geom_text(aes(x = reorder(Transporte, -n), y=n, label = as.character(municipios_origen), group = municipios_origen),
            position = position_dodge(width = 0.9),
            hjust = 1.2, size = 2, angle = 90) +
  scale_y_continuous(limits=c(-90,1040)) + theme(axis.title.x=element_blank(),
                                               axis.ticks.x=element_blank()) + ylab("Número de viajes") +
  labs(title="Municipios origen por tipo de taxi", subtitle = "CDMX")

5.
patron.u <- '(Uber)'
pos.u<-grep(patron.u, municipio.transporte.o$Transporte)

all.uber<-municipio.transporte.o[pos.u,]

ggplot(filter(all.uber, n>=2)) +
  geom_bar(aes(x = reorder(Transporte, -n), y=n, fill = municipios_origen, group= municipios_origen),
           colour = "white",stat = "identity", position = "dodge", show.legend = FALSE) +
  geom_text(aes(x = reorder(Transporte, -n), y=n, label = as.character(n), group = municipios_origen),
            position = position_dodge(width = 0.9),
            hjust = 0.5, size = 3, vjust=-0.4) +
  geom_text(aes(x = reorder(Transporte, -n), y=n, label = as.character(municipios_origen), group = municipios_origen),
            position = position_dodge(width = 0.93),
            vjust=.4,hjust = 1.2, size = 2, angle = 90) +
  scale_y_continuous(limits=c(-1,13)) + theme(axis.title.x=element_blank(),
                                                 axis.ticks.x=element_blank()) + ylab("Número de viajes") +
  labs(title="Municipios origen por tipo de Uber", subtitle = "CDMX")


### GrÃ¡fico municipios de origen por taxi libre
ggplot(filter(municipio.transporte.o, Transporte == "Taxi Libre", n>100)) +
  geom_bar(aes(x = reorder(municipios_origen, n), y=n, fill = municipios_origen), stat = "identity", show.legend = FALSE) +
  coord_flip(clip = 'off')  + ylab("Número de viajes") + 
  labs(title="Municipios de origen Taxi Libre", subtitle = "CDMX") +
  theme(axis.title.y=element_blank(), axis.ticks.x=element_blank())

### GrÃ¡fico municipios de origen por Taxi de Sitio
ggplot(filter(municipio.transporte.o, Transporte == "Taxi de Sitio")) +
  geom_bar(aes(x = reorder(municipios_origen, n), y=n, fill = municipios_origen), stat = "identity", show.legend = FALSE) +
  coord_flip(clip = 'off') + ggtitle("Municipios de origen Taxi de Sitio")

### GrÃ¡fico municipios de origen por Radio Taxi
ggplot(filter(municipio.transporte.o, Transporte == "Radio Taxi")) +
  geom_bar(aes(x = reorder(municipios_origen, n), y=n, fill = municipios_origen), stat = "identity", show.legend = FALSE) +
  coord_flip(clip = 'off') + ggtitle("Municipios de origen Radio Taxi")

### GrÃ¡fico municipios de origen por UberX
ggplot(filter(municipio.transporte.o, Transporte == "UberX")) +
  geom_bar(aes(x = reorder(municipios_origen, n), y=n, fill = municipios_origen), stat = "identity", show.legend = FALSE) +
  coord_flip(clip = 'off') + ggtitle("Municipios de origen UberX")

### GrÃ¡fico municipios de origen por UberXL
ggplot(filter(municipio.transporte.o, Transporte == "UberXL")) +
  geom_bar(aes(x = reorder(municipios_origen, n), y=n, fill = municipios_origen), stat = "identity", show.legend = FALSE) +
  coord_flip(clip = 'off') + ggtitle("Municipios de origen UberXL")

### GrÃ¡fico municipios de origen por UberSUV
ggplot(filter(municipio.transporte.o, Transporte == "UberSUV")) +
  geom_bar(aes(x = reorder(municipios_origen, n), y=n, fill = municipios_origen), stat = "identity", show.legend = FALSE) +
  coord_flip(clip = 'off') + ggtitle("Municipios de origen UberSUV")

### GrÃ¡fico municipios de origen por UberBlack
ggplot(filter(municipio.transporte.o, Transporte == "UberBlack")) +
  geom_bar(aes(x = reorder(municipios_origen, n), y=n, fill = municipios_origen), stat = "identity", show.legend = FALSE) +
  coord_flip(clip = 'off') + ggtitle("Municipios de origen UberBlack")

