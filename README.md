**Introducción**

Este repositorio contiene un análisis del comportamiento del internet en Argentina desde 2014 hasta 2023, o sea una década de información.
El análisis se conforma de un EDA dónde extraemos los datos necesarios y se transforman y analizan para tener un panorama mas amplio y detallado y poder decidir los siquientes pasos a tomar, una base de datos SQL que contiene los datos ya tranformados en el EDA y 
estructurados de forma relacional. La misma base de datos parece alcanzar 4NF ya que todas las filas contienen un solo valor (1NF), en todas las tablas, las columnas que no son key dependen de la primary key (2NF), las columnas dependientes de la primary key no tienen
interdependcia entre ellas (3NF) y no cuenta con dependencias multivaluadas (4NF). Es bastante pequeña, pero vale la pena mencionarlo.

El dashboard es interactivo y cuenta con botones para filtrar por año y trimestre, así como con KPI y varios indicadores de los valores correspondientes.

**Estructura del repositorio**

- Dataset original: Contiene el archivo excel del data original sin ningun cambio de mi parte.
- Datasets separados: Contiene archivos CSV que resultan de la separación resultante del EDA para dejarlos casi listos para las tablas SQL.
- Notebooks: contiene el EDA en un archivo ipynb para mayor claridad y organización, con markdowns comentados con los hallazgos y las ideas que van surgiendo.
- PowerBI: Dashboard creado
- SQL: Script usado para la creación de la base de datos, así como una imagen del reverse engineer para ver las relaciones de las tablas.

**Metodología**

-EDA:
Se comienza examinando el dataset y planteando los objetivos para tener claro los subsets de datos que necesitamos para la base de datos y la visualización posterior. No encontré valores nulos ya que es un dataset muy bien procesado y con una madurez ya establecida. En el camino se generan algunos graficos para medir y observar las tendencias y correlaciones de los datos y se toma un enfoque más general, siendo primero a nivel nacional y luego a nivel provincia para tener dimensiones de información entendibles, ya que un análisis a nivel local sería mucho mas extenso y particular, corriendo el riesgo de caer en cantidades enormes de datos dificiles de graficar de manera concreta no siendo mucho mejor que leer un CSV en crudo.
Se cambian algunos datos y se crean nuevas tablas con pandas para facilitar el SQL. Al final se exportan los csv a la carpeta de Datasets separados para importarlos a MySQL.


-SQL: 
La database internet contiene tablas de provincia, partidos y localidades con identificadores para crear relaciones y por medio de JOIN se puede saber en que provincia y partido está alguna localidad.
Las tablas de evolucion_provincia y evolucion_nacional toman un enfoque al tiempo, mostrando el cambio en metricas como el acceso a internet, los ingresos generados o las velocidades, siendo divisibles hasta el trimestre. Para su creación se usó data de varios csv por lo que si haciamos varios LOAD INFILE seguidos, se nos multiplicaban las filas, por lo que se usó una tabla auxiliar de carga con "columnas comodín" para soportar varios tipos de datos, y al ser datasets del mismo largo se les asignó un Id de carga que coincide con el Id de evolución, para posteriormente actualizar la tabla correspondiente por medio de JOIN.
Se incluye un PDF con la imagen de la base y sus relaciones

-Dashboard: 
Se importó la base de datos y requirió de pocas transformaciones como cambio de nombre, tipo de dato o agregaciones para las gráficas correspondientes. La primera página toma un enfoque nacional y la segunda dividio en provincia, manteniendo así generalizaciones de datos faciles de comprender a escalas manejables, dando buenos insights generales del panorama por país y provincia.
Se calcularon 3 KPI por medio de medidas calculadas y son: 
  - Crecimiento por provincia del numero de hogares con internet contra trimestre anterior: Se selecciona una provincia en el treemap, un año y un trimestre y se muestra el aumento porcentual de hogares con internet respecto al trimestre anterior. Se propone un objetivo del 2%.
  - Ingreso promedio por conexión: Mide el ingreso promedio a nivel nacional por conexión en el año seleccionado.
  - Aumento de la velocidad promedio contra el año previo: A nivel nacional, se selecciona un año y el KPI devuelve el aumento porcentual de la velocidad promedio comparando el año anterior.
El análisis completo y las observaciones se describen en la siguiente sección

**Análisis** 

El mas obvio resultado a nivel nacional es la velocidad promedio, siendo esta de 125Mbps en 2023, alcanzando aumentos del 25% como mínimo de manera constante exceptuando el 2021 y se puede deber a la pandemia, siendo el 2023 el año con el mayor aumento que llegó al 78%. Un aumento del 50% al 78% de habitantes con internet en una década, acercando la posibilidad de alcanzar más del 90% en los próximos años. 
En cuanto a la información que más interesa a las empresas proveedoras de internet, con el aumento del alcance de la población y el incremento general en la calidad, ha venido un aumento en ingresos generados bastante considerable, siendo el 2023 el año con mas ingresos generado alcanzando los 522677 millones de pesos, duplicando al 2022 con 252169 millones, lo que parece ser un patrón que continuará ya que todos los años se alcanza un ingreso que casi duplica al pasado, y parece ser que cada año la brecha entre ambos se hace más y más grande siendo un gran incentivo para nuevas empresas y por lo tanto, para mejorar la competitividad entre empresas ya operando. Se grafica un KPI para medir el ingreso promedio por cada conexión registrada, siendo en el 2023 de 5750 pesos, de nuevo logrando un aumento contra el año pasado, lo cual se puede deber al aumento en la velocidad siendo igualmente un gran incentivo para las compañias para mantenerse y mejorar su servicio por medio del alcance y la velocidad,, pero igual es un número que se debe de tener bien ciudado ya que no debe aumentar al punto de ser inaccesible para los consumidores, ya que bajaría los consumos, ingresos y progreso de la interconexión del país.

A nivel provincia contamos con selección de año y trimestre, se muestra una clara ventaja en todas las métricas en Buenos Aires y la Capital. En 2023 tienen 50 de las 90 millones de conexiones registradas, al igual que velocidades promedio de 139 y 212 Mbps respectivamente. Tenemos a la mano el KPI de crecimiento de % de hogares con acceso a internet, con un objetivo propuesto de 2%. Capital federal rara vez alcanza ese objetivo trimestral, mostrando caídas frecuentes en el porcentaje, siendo una historia similar en Buenos Aires, esto se puede deber a los precios mas elevados de dichas provincias. 
Por otro lado, tenemos provincias como Tierra de Fuego y Chubut, que cuentan con pocos accesos y velocidades promedio bajas, rondando los 20Mbps. 
Las compañias podrían ver como area de oportunidad dichas provincias con menor desarrollo en telecomunicaciones ya que hay un mercado sin explotar, aunque no tan grande como Buenos Aires o Capital, pero mas extenso y siendo la oportunidad para introducir nuevas tecnologías como el internet satelital para areas remotas de Tierra de Fuego, Fibra óptica para provincias cercanas a la infraestructura de la capital como La Pampa, Córdoba o Santa Fé, al igual que opciones de bajo costo en provincias con métricas bajas como Jujuy, Chubut o San Juan. 
Hay un gran mercado en la capital y Buenos Aires, pero hay uno con más oportunidad de innovación, captación fácil de clientes y aumento del desarrollo en provincias con métricas reducidas.

