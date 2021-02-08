# Análsis de viajes en la CDMX

Cargamos las librerias y los datos
```R

### Cargamos las paqueterias
library(dplyr)
library(ggplot2)

### Cargamos los datos a la workspace
municipios.cdmx <- read.csv("cdmx_transporte_clean3.csv", stringsAsFactors=T)

```
Mediante ```dplyr``` agrupamos los municipios de origen 

```R
### Municipio de origen
col.mun.origen<-select(municipios.cdmx, municipios_origen) %>% 
  group_by(municipios_origen) %>%
  count(municipios_origen, sort = TRUE)

### Municipio de destino
col.mun.destino<-select(municipios.cdmx, municipios_destino) %>% 
    group_by(municipios_destino) %>%
    count(municipios_destino, sort = TRUE)

### Datafram agrupando municipios por origen y destino
col.mun.origen$lugar <- rep("origen", 40)
col.mun.destino$lugar <- rep("destino", 40)

col.mun.origen<-rename(col.mun.origen, municipios = "municipios_origen")
col.mun.destino<-rename(col.mun.destino, municipios = "municipios_destino")

destinos <- rbind2(col.mun.origen, col.mun.destino)
```
![1 Tabla](https://user-images.githubusercontent.com/71915068/107163646-5fd54c80-6970-11eb-8525-9508db7897e6.PNG)

Creamos el gráfico
```R
ggplot(filter(destinos, n>200)) +
  geom_bar(aes(x = reorder(municipios, n), y=n, fill = lugar), 
           stat = "identity", show.legend = FALSE) + facet_wrap(lugar~., scales = "free_y") +
  coord_flip(clip = 'off') + 
  geom_text(aes(x = reorder(municipios, n), 
                y=n, label = as.character(n)), nudge_y = 0.5) +
  labs(title="Origen y destino más frecuetes", subtitle = "CDMX", xlab ) +
  ylab("Número de viajes") + theme(axis.title.y=element_blank(),
                                   axis.ticks.y=element_blank())+
  scale_fill_manual(values=c("#ff0033", "#00b3ff")) 
```

Origen y Destino más frecuentes\
![OyD viajes](https://user-images.githubusercontent.com/71915068/107141306-79818000-68ed-11eb-892c-3a14ca5ff60d.png)

Agrupamos los viajes por tipo de transporte
```R
### Tipo de transporte
tipo.transporte<-select(municipios.cdmx, Transporte) %>% 
    group_by(Transporte) %>%
    count(Transporte, sort = TRUE)
```
![2 Viajes](https://user-images.githubusercontent.com/71915068/107164041-a461e780-6972-11eb-87b6-481b44a9b198.PNG)

Realizamos una gráfica de barras de los viajes totales por tipo de transporte
```R
ggplot(tipo.transporte) +
  geom_bar(aes(x = reorder(Transporte, n), y=n, fill = Transporte), stat = "identity", show.legend = FALSE) +
  geom_text(aes(x = reorder(Transporte, n), y=n, label = as.character(n)), nudge_y = 120) +
  coord_flip(clip = 'off') +
  labs(title="Tipo de Transporte", subtitle = "CDMX") +
  ylab("Número de viajes") + theme(axis.title.y=element_blank(),
                                   axis.ticks.y=element_blank()) +
  scale_fill_manual(values=c("#ffcc00", "#ffd633","#ffdb4d", "#0033ff","#ff0033","#000000","#262626"))
```
 Número de viajes por tipo de transporte\
![Viajes por tipo de transporte](https://user-images.githubusercontent.com/71915068/107141339-b483b380-68ed-11eb-9a84-4768618ce766.png)


### Agrupamos los viajes por origen
```R
municipio.transporte.o<-select(municipios.cdmx, Transporte, municipios_origen) %>% 
    group_by(municipios_origen, Transporte) %>%
    count(municipios_origen,sort = TRUE)
```
Ya que deseamos conocer en cuales alacaldias parten los ```Taxis``` en sus viajes, creamos el siguien gráfico para comparar.

```R
patron.t <- '(Taxi)'
pos.t<-grep(patron.t, municipio.transporte.o$Transporte)

all.taxis<-municipio.transporte.o[pos.t,]
```

```R
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
```
Municipios origen taxis comparación
![Municipios origen tp](https://user-images.githubusercontent.com/71915068/107161718-37dfec00-6964-11eb-9059-e5bf63a00ae3.png)

Tambien deseamos conocer en cuales alacaldias parten los ```Ubers``` en sus viajes, creamos el siguien gráfico para comparar.
```R
patron.u <- '(Uber)'
pos.u<-grep(patron.u, municipio.transporte.o$Transporte)

all.uber<-municipio.transporte.o[pos.u,]
```

```R
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

```
Municipios origen uber comparación
![Municipios origen uber](https://user-images.githubusercontent.com/71915068/107161921-7d50e900-6965-11eb-8b4a-6d0da89c4ada.png)


### Agrupamos los viajes por destino
```R
### Alcadias de destino por Transporte
(municipio.transporte.d<-select(municipios.cdmx, Transporte, municipios_destino) %>% 
    group_by(municipios_destino, Transporte) %>%
    count(municipios_destino,sort = TRUE))

```
Paro conocer en cuales alacaldias son los destinos más frecuentes por parte de los ```Taxis``` en sus viajes, creamos el siguien gráfico para comparar.

```R
patron.t <- '(Taxi)'
pos.t<-grep(patron.t, municipio.transporte.d$Transporte)

all.taxis<-municipio.transporte.d[pos.t,]
```
```R
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
                                                 axis.ticks.x=element_blank()) + ylab("Número de viajes") +
  labs(title="Municipios destino por tipo de taxi", subtitle = "CDMX")

```
Municipios destino taxis comparación
![Municipios destino taxis](https://user-images.githubusercontent.com/71915068/107162981-69f54c00-696c-11eb-980d-d7026c94fb93.png)


Paro conocer en cuales alacaldias son los destinos más frecuentes por parte de los ```Ubers``` en sus viajes, creamos el siguien gráfico para comparar.
```R
patron.u <- '(Uber)'
pos.u<-grep(patron.u, municipio.transporte.d$Transporte)

all.uber<-municipio.transporte.d[pos.u,]

```
```R
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
                                              axis.ticks.x=element_blank()) + ylab("Número de viajes") +
  labs(title="Municipios destino por tipo de Uber", subtitle = "CDMX")

```
Municipios destino uber comparación
![Municipios destino uber](https://user-images.githubusercontent.com/71915068/107162998-83969380-696c-11eb-9808-0b4be7d11fd7.png)
