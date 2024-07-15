**Introduccioin**

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
