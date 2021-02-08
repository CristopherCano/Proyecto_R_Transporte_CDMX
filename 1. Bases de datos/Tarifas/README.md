# Tarifas 

### Descripción

El archivo ```tarifas.csv``` contiene los datos de tarifas relacionadas al desglose del costo total de un viaje realizado dentro del rango de fechas utilizadas en la base de datos principal (2016-2017).
Las columnas son las siguientes

- ```Transporte```: Tipo de Taxi o Uber 
- ```banderazo```: Tarifa inicial del tipo de transporte.
- ```tarifa_dist```: Tarifa que se agrega cada cierta distancia avanzada. (250mts. para Taxis, 1km. para Uber)
- ```tarifa_ tiempo```: Tarifa que se agrega cada cierto tiempo transcurrido. (45seg. para Taxis, 1min. para Uber)
- ```tarifa_min```: Costo final que será aplicado en caso de que el monto calculado no supere esta cantidad.

Las tarifas relacionadas a los Taxis están reguladas por la Secretaría de Movilidad de la Ciudad de México, éstas se publican regularmente en la Gaceta Oficial, que es el órgano del Gobierno de la Ciudad de México, que tiene como finalidad publicar todas aquellas disposiciones emanadas de autoridad competente que tengan aplicación en el ámbito de la CDMX y están disponibles para su consulta en Internet.

Las tarifas de Uber se consiguieron al consultar múltiples páginas de Internet que brindaban información acerca de ello, se hizo una comparación general de toda la información y se seleccionó aquella que concordara con la mayoría. En su app y sitio web, Uber muestra el desglose de tarifas, sin embargo, éstas son actuales y no se adaptan a las fechas de nuestra base de datos. También se intentó acceder a una API para la consulta de costos, pero a pesar de generar una cuenta, no se contaban con los permisos necesarios para las consultas de información.


