# Prueba de Hipotesis - Costos (UberX - TaxiLibre)

#### Método: Prueba de hipótesis para la diferencia de medias (μ1−μ2)

* Preparar variables para su uso
```R
#Cargar archivos
TL <- read.csv("h.TaxiLibre.csv")
UX <- read.csv("h.UberX.csv")

#Juntar data.frames
precio1 <- rbind(TL, UX)
```
* Boxplot con los precios de UberX y TaxiLibre
```R
qplot(x = precio1$V1, y = precio1$V2,
      geom = "boxplot", data = precio1,
      xlab = "Transporte", 
      ylab = "Costo ($)",
      fill = I("lightblue"))
```

![image](https://user-images.githubusercontent.com/72113099/107296495-1e5ba480-6a37-11eb-9059-a8355ce175a1.png)

* Cálculo de Media, Desviación Estándar, Error Estándar
```R
precio1 %>%
  group_by(V1) %>%
  summarize(N = n(),
            Media = round(mean(V2), 0),
            Desv.Estandar = round(sd(V2), 0),
            Err.Estandar = round(sd(V2) / sqrt(N), 0))
```
Resultado:
```R
#  V1             N Media Desv.Estandar Err.Estandar
#   <chr>      <int> <dbl>         <dbl>        <dbl>
# 1 Taxi Libre  4462    24            10            0
# 2 UberX        129    15             8            1
```
* Uso de función `t.test` para obtener estadísticos
```R
costo.t.test <- t.test(V2 ~ V1, data = precio1)
costo.t.test 
```
Resultado:
```R
#	Welch Two Sample t-test
#
# data:  V2 by V1
# t = 12.529, df = 139.37, p-value < 2.2e-16
# alternative hypothesis: true difference in means is not equal to 0
# 95 percent confidence interval:
#   7.885555 10.840595
# sample estimates:
# mean in group Taxi Libre      mean in group UberX 
#                 24.35634                 14.99326 
```

```R

```

```R

```
