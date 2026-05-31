# Examen de Programación — DAM1

Aplicación Spring Boot con Thymeleaf y MySQL

Duración: 2 horas y 30 minutos

Tecnologías: Spring Boot, Thymeleaf, Maven, MySQL, JDBC o JPA

Entrega: proyecto completo según indique el profesor

---

## 1. Objetivo del examen

El objetivo del examen es completar una aplicación web para gestionar tareas de un pequeño equipo de trabajo.

El proyecto base ya incluye la estructura inicial, la configuración de Spring Boot, la conexión a una base de datos MySQL mediante Docker Compose, varias plantillas HTML estáticas y documentación de ayuda en la carpeta `docs`.

Tu trabajo consiste en desarrollar la parte funcional de la aplicación:

- crear el modelo de datos en Java;
- crear los repositorios necesarios;
- crear la capa de servicio;
- crear los controladores;
- adaptar las plantillas HTML a Thymeleaf;
- conectar la aplicación con los datos reales de la base de datos;
- implementar las operaciones principales sobre las tareas.

La aplicación deberá seguir una arquitectura por capas:

- capa de presentación: controladores y vistas Thymeleaf;
- capa de servicio: lógica de aplicación y validaciones;
- capa de persistencia: acceso a datos mediante JDBC o JPA.

---

## 2. Qué se proporciona en el proyecto base

El proyecto base incluye:

- un proyecto Maven con Spring Boot;
- dependencias necesarias para Spring MVC, Thymeleaf, JDBC, JPA y MySQL;
- configuración de conexión a MySQL en `application.properties`;
- un `docker-compose.yml` para levantar la base de datos;
- un script SQL de inicialización con tablas y datos de prueba;
- plantillas HTML estáticas ya maquetadas;
- documentación de ayuda en la carpeta `docs`.

No se proporciona la implementación de la aplicación.

En concreto, deberás crear tú:

- las clases del modelo;
- los repositorios;
- los servicios;
- los controladores;
- la adaptación dinámica de las vistas Thymeleaf;
- las validaciones necesarias;
- la lógica para crear, consultar, editar y filtrar tareas.

---

## 3. Documentación disponible en la carpeta docs

Dentro de la carpeta `docs` tienes documentos de ayuda que puedes consultar durante el desarrollo.

### `docs/jdbctemplate.md`

Contiene una guía rápida sobre el uso de `JdbcTemplate` dentro de repositorios Spring.

Incluye ejemplos genéricos de:

- cómo crear un repositorio con `JdbcTemplate`;
- cómo usar `query`;
- cómo usar `queryForObject`;
- cómo usar `update`;
- cómo crear métodos de mapeo tipo `RowMapper`;
- cómo insertar, actualizar y eliminar registros;
- cómo trabajar con fechas y booleanos;
- cómo hacer consultas con relaciones entre tablas.

Los ejemplos utilizan modelos genéricos como `Producto` y `Categoria`. Debes adaptarlos a las tablas y clases reales de este examen.

### `docs/queries.md`

Contiene consultas SQL que pueden ser útiles para implementar los repositorios del examen.

Incluye consultas para:

- obtener todas las tareas;
- obtener una tarea por identificador;
- obtener las personas asignables;
- insertar tareas;
- actualizar tareas;
- eliminar tareas;
- filtrar tareas;
- buscar por texto;
- comprobar si existen registros.

Estas consultas están pensadas como apoyo. Debes decidir cuáles necesitas usar y cómo integrarlas en tus repositorios.

### `docs/thymeleaf.md`

Contiene ayuda sobre el uso básico de Thymeleaf.

Incluye ejemplos de:

- mostrar textos dinámicos;
- recorrer listas;
- crear enlaces dinámicos;
- enviar formularios;
- rellenar campos de formulario;
- cargar opciones en un `select`;
- marcar opciones seleccionadas;
- mostrar mensajes o bloques condicionales.

Debes usar esta ayuda para adaptar las plantillas HTML estáticas proporcionadas y convertirlas en vistas dinámicas.

---

## 4. Puesta en marcha de la base de datos

Antes de comenzar, levanta la base de datos con:

```bash
docker compose up -d
```

Después, arranca la aplicación Spring Boot desde tu IDE o desde terminal.

La configuración de conexión a la base de datos ya está incluida en el proyecto.

Datos de conexión configurados:

```text
Servidor: localhost
Puerto: 3307
Base de datos: examen_dam1
Usuario: dam1
Contraseña: dam1
```

Si necesitas reiniciar completamente la base de datos y volver a cargar los datos iniciales, puedes ejecutar:

```bash
docker compose down -v
docker compose up -d
```

---

## 5. Base de datos

La base de datos contiene información sobre tareas y personas del equipo.

Cada tarea almacena información relacionada con:

- qué tarea hay que realizar;
- una descripción;
- el estado en el que se encuentra;
- su prioridad;
- la fecha límite;
- si está completada;
- la persona asignada.

También existen personas del equipo que pueden tener tareas asignadas.

Debes analizar la estructura de la base de datos proporcionada y crear las clases Java necesarias.

La aplicación tendrá como máximo 2 entidades principales.

No se proporcionan las entidades Java. Elegir las clases, los atributos y los tipos de datos adecuados forma parte del examen.

---

## 6. Vistas HTML proporcionadas

El proyecto incluye varias páginas HTML estáticas ya maquetadas.

Estas páginas contienen datos de ejemplo y enlaces ficticios. No están conectadas a la aplicación.

Debes adaptar estas páginas para convertirlas en vistas Thymeleaf dinámicas.

El objetivo no es crear un diseño visual desde cero, sino conectar las vistas con los datos reales de la aplicación.

Deberás sustituir los datos estáticos por datos procedentes de los controladores y de la base de datos.

Se valorará que mantengas la estructura visual proporcionada y que uses Thymeleaf correctamente.

---

## 7. Requisitos técnicos

La aplicación debe cumplir estos requisitos:

- usar Spring Boot;
- usar Thymeleaf para las vistas;
- acceder a MySQL mediante JDBC o JPA;
- seguir una estructura por capas;
- no acceder directamente a la base de datos desde los controladores;
- no implementar la lógica principal en las vistas;
- no usar listas en memoria como sustituto de la base de datos;
- no modificar la estructura de las tablas proporcionadas;
- no crear más de 2 entidades principales.

En caso de usar JPA, no se debe permitir que Hibernate cree o modifique las tablas automáticamente.

No se aceptará una configuración basada en:

```properties
spring.jpa.hibernate.ddl-auto=create
spring.jpa.hibernate.ddl-auto=create-drop
spring.jpa.hibernate.ddl-auto=update
```

---

## 8. Funcionalidades que debes implementar

### 8.1. Modelo de datos y estructura por capas

Crea las clases necesarias para representar los datos de la aplicación.

Debes decidir:

- qué entidades necesita la aplicación;
- qué atributos debe tener cada entidad;
- qué tipos Java son adecuados para cada dato;
- cómo representar la relación entre las tareas y las personas;
- qué repositorios, servicios y controladores son necesarios.

La aplicación debe estar organizada, como mínimo, en paquetes similares a:

```text
controller
service
repository
model
```

---

### 8.2. Listado de tareas

Implementa una pantalla principal que muestre el listado de tareas existentes.

Ruta recomendada:

```text
GET /tareas
```

La tabla debe mostrar información suficiente para identificar cada tarea:

- título o nombre de la tarea;
- estado;
- prioridad;
- fecha límite;
- persona asignada;
- si está completada.

Desde el listado debe poder accederse al detalle de una tarea y a la edición de una tarea.

La página HTML del listado ya está proporcionada. Debes adaptarla a Thymeleaf para que muestre datos reales.

---

### 8.3. Detalle de una tarea

Implementa una pantalla para consultar el detalle de una tarea concreta.

Ruta recomendada:

```text
GET /tareas/{id}
```

La pantalla debe mostrar toda la información relevante de la tarea.

La página HTML del detalle ya está proporcionada. Debes adaptarla a Thymeleaf para que muestre los datos reales de la tarea seleccionada.

Si la tarea no existe, la aplicación debe gestionarlo de forma sencilla, por ejemplo redirigiendo al listado, mostrando un mensaje de error o mostrando una página de error controlada.

---

### 8.4. Crear una nueva tarea

Implementa un formulario para crear nuevas tareas.

Rutas recomendadas:

```text
GET /tareas/nueva
POST /tareas
```

El formulario debe permitir introducir la información necesaria para crear una tarea completa.

La persona asignada deberá poder seleccionarse entre las personas existentes en la base de datos.

Al guardar, la tarea debe persistirse en MySQL y la aplicación debe volver al listado.

La página HTML del formulario ya está proporcionada. Debes adaptarla a Thymeleaf para que funcione correctamente.

---

### 8.5. Editar una tarea existente

Implementa una pantalla para editar una tarea existente.

Rutas recomendadas:

```text
GET /tareas/{id}/editar
POST /tareas/{id}/editar
```

La pantalla debe cargar los datos actuales de la tarea y permitir modificarlos.

Debe ser posible cambiar también la persona asignada.

Al guardar, los cambios deben persistirse en la base de datos.

Puedes usar la misma plantilla de formulario para crear y editar.

---

### 8.6. Validaciones básicas

Añade validaciones para evitar guardar tareas con datos incorrectos.

Como mínimo, no deben guardarse tareas si faltan datos importantes como:

- título o nombre de la tarea;
- descripción;
- estado;
- prioridad;
- fecha límite;
- persona asignada.

Puedes implementar las validaciones usando anotaciones de validación o mediante comprobaciones en la capa de servicio.

Si hay errores, la aplicación debe impedir el guardado y permitir corregir los datos.

---

### 8.7. Filtro sencillo

Añade un filtro en el listado de tareas.

Puedes implementar uno de los siguientes filtros:

- filtrar por estado;
- filtrar por prioridad;
- filtrar por persona asignada;
- buscar por texto en el título o descripción.

Solo es obligatorio implementar un filtro.

---

### 8.8. Eliminación de tareas

Puedes implementar la eliminación de tareas.

Ruta recomendada:

```text
POST /tareas/{id}/eliminar
```

Tras eliminar una tarea, la aplicación debe redirigir al listado.

---

## 9. Requisitos mínimos de funcionamiento

Para que la aplicación se considere funcional, debe:

- arrancar correctamente;
- conectarse a la base de datos MySQL proporcionada;
- usar Thymeleaf para mostrar páginas;
- tener separación básica entre controlador, servicio y repositorio;
- mostrar un listado de tareas desde la base de datos;
- permitir crear una nueva tarea.

Un proyecto que no compile o no arranque tendrá una valoración muy limitada, aunque tenga partes del código escritas.

Un proyecto que no use base de datos real no se considerará una solución válida.

---

## 10. Entrega

Debes entregar el proyecto completo según indique el profesor.

El proyecto deberá incluir:

- código fuente;
- `pom.xml`;
- configuración proporcionada;
- vistas Thymeleaf adaptadas;
- breve explicación de la solución.

En la explicación final deberás indicar:

- si has usado JDBC o JPA;
- qué entidades has creado;
- qué funcionalidades has implementado;
- cualquier decisión importante que quieras explicar.

