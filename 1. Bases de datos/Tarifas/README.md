# Tarifas 

### Descripción

El archivo ```tarifas.csv``` contiene los datos de tarifas relacionadas al desglose del costo total de un viaje realizado.
Las columnas son las siguientes

- ```Transporte```: Tipo de Taxi o Uber 
- ```banderazo```: Tarifa inicial del tipo de transporte.
- ```tarifa_dist```: Tarifa que se agrega cada cierta distancia avanzada. (250mts. para Taxis, 1km. para Uber)
- ```tarifa_ tiempo```: Tarifa que se agrega cada cierto tiempo transcurrido. (45seg. para Taxis, 1min. para Uber)
- ```tarifa_min```: Costo final que será aplicado en caso de que el monto calculado no supere esta cantidad.
