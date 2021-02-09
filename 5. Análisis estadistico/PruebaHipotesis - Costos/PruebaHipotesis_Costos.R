#Cargar librerías
TL <- read.csv("h.TaxiLibre.csv")
UX <- read.csv("h.UberX.csv")

#Juntar data.frames
precio1 <- rbind(TL, UX)

#Graficar boxplots
qplot(x = precio1$V1, y = precio1$V2,
      geom = "boxplot", data = precio1,
      xlab = "Transporte", 
      ylab = "Costo ($)",
      fill = I("lightblue"))

#Cálculo de estadísticos
precio1 %>%
  group_by(V1) %>%
  summarize(N = n(),
            Media = round(mean(V2), 0),
            Desv.Estandar = round(sd(V2), 0),
            Err.Estandar = round(sd(V2) / sqrt(N), 0))

#Función t.test para cálculo de estadísticos
costo.t.test <- t.test(V2 ~ V1, data = precio1)
costo.t.test 

#P-value
costo.t.test$p.value

#Diferencia de medias
round(costo.t.test$estimate[1] - costo.t.test$estimate[2], 1)


