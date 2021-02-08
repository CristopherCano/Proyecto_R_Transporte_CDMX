# Proyecto CDMX transporte

![cdmx_map](https://user-images.githubusercontent.com/71915068/106938254-5d5ec280-66e4-11eb-888b-04479511535f.png)

## Contenido

#### [1. Bases de datos](https://github.com/CristopherCano/Proyecto_R_Transporte_CDMX/tree/main/1.%20Bases%20de%20datos)
- [Tarifas](https://github.com/CristopherCano/Proyecto_R_Transporte_CDMX/blob/main/1.%20Bases%20de%20datos/Tarifas/README.md)
- [Viajes](https://github.com/CristopherCano/Proyecto_R_Transporte_CDMX/tree/main/1.%20Bases%20de%20datos/Viajes)

#### [2. Extracción de datos](https://github.com/CristopherCano/Proyecto_R_Transporte_CDMX/blob/main/2.%20Extracci%C3%B3n%20de%20datos/README.md)
#### [3. Limpieza de datos](https://github.com/CristopherCano/Proyecto_R_Transporte_CDMX/blob/main/3.%20Limpieza%20de%20datos/README.md)
#### [4. Exploración de datos](https://github.com/CristopherCano/Proyecto_R_Transporte_CDMX/tree/main/4.%20Exploraci%C3%B3n%20de%20datos)

- [Heat maps](https://github.com/CristopherCano/Proyecto_R_Transporte_CDMX/blob/main/4.%20Exploraci%C3%B3n%20de%20datos/Heat%20maps/README.md)
- [Tarifas y Costos Finales](https://github.com/CristopherCano/Proyecto_R_Transporte_CDMX/blob/main/4.%20Exploraci%C3%B3n%20de%20datos/Tarifas%20-%20Costo%20Viaje/README.md)
- [Origenes y destinos viajes](https://github.com/CristopherCano/Proyecto_R_Transporte_CDMX/blob/main/4.%20Exploraci%C3%B3n%20de%20datos/Top%2010%20origes%20y%20destinos%20CDMX/README.md)
- [Análisis de Distancias, Tiempos de espera en el trafico y Velocidad](https://github.com/CristopherCano/Proyecto_R_Transporte_CDMX/blob/main/4.%20Exploraci%C3%B3n%20de%20datos/Velocidad-Distancia-Tiempo%20Detenido/README.md)
- [Análisis de Viajes y Tráfico](https://github.com/CristopherCano/Proyecto_R_Transporte_CDMX/blob/main/4.%20Exploraci%C3%B3n%20de%20datos/Viajes-Tr%C3%A1fico/README.md)

#### [5. Análisis estadistico](https://github.com/CristopherCano/Proyecto_R_Transporte_CDMX/tree/main/5.%20An%C3%A1lisis%20estadistico)
- [Reduccipn tiempo detenido por días](https://github.com/CristopherCano/Proyecto_R_Transporte_CDMX/blob/main/5.%20An%C3%A1lisis%20estadistico/Reducci%C3%B3n%20Tiempo%20Detenido%20Por%20D%C3%ADas/README.md)
- [Análisis de Distancias, Tiempos de espera en el trafico y Velocidad](https://github.com/CristopherCano/Proyecto_R_Transporte_CDMX/blob/main/5.%20An%C3%A1lisis%20estadistico/Velocidad-Distancia-Tiempo%20Detenido/README.md)

## Descripción de la base de datos

### Información
Este conjunto de datos se recopiló utilizando la aplicación EC Taxímetro. Una herramienta fácil de usar desarrollada para comparar tarifas, que le brinda al usuario una tarifa precisa basada en GPS para calcular el costo del viaje en taxi. Debido a la capacidad de verificar que se le cobre de manera justa, nuestra aplicación es muy popular en varias ciudades. Alentamos a nuestros usuarios a que nos envíen URL con las tarifas de taxi / transporte en sus ciudades para seguir aumentando nuestra base de datos.

### Acerca de los datos
Los datos se recopilan desde junio de 2016 hasta el 20 de julio de 2017. Los datos no están completamente limpios, muchos usuarios olvidan apagar el taxímetro cuando terminan la ruta.

- La aplicación obtiene las tarifas disponibles para su ubicación en función de su GPS
- Los usuarios pueden iniciar un taxímetro en su propio teléfono y verificar que se les cobre de manera justa
- Se muestra al usuario información útil durante el viaje: velocidad, tiempo de espera, distancia, actualización de GPS, precisión de GPS, rango de error
- Es posible navegar por varias ciudades y países cuyas tarifas están disponibles para su uso. Si una tarifa no está en la aplicación, ahora es más fácil que nunca avisarnos gracias a Questbee Apps.

### Ubicación
CDMX


### Datos
- ```id``` - indicador unico por cada viaje
- ```vendor_id``` - el tipo de tarifa ingresada por el usuario (taxi, Uber, Cabify)
- ```pickup_datetime``` - fecha y hora en que se activó el medidor
- ```dropoff_datetime``` - fecha y hora en que se desactivo el medidor
- ```pickup_longitude``` - longitud donde el viaje partio
- ```pickup_latitude``` - latitud donde el viaje partio
- ```dropoff_longitude``` - longitud donde el viaje termino
- ```dropoff_latitude``` - latitud donde el viaje termino
- ```store_and_fwd_flag``` - establezca siempre en N, que coincida con el conjunto de datos.
- ```trip_duration``` - duración del viaje en segundos
- ```dist_meters``` - la distancía del viaje en metros
- ```wait_sec``` - el tiempo que el carro estuvo completamente detenido durante el viaje en segundos.
