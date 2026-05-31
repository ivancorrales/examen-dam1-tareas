## **1. Consultar todas las tareas con su persona asignada**

```sql
SELECT
    t.id,
    t.titulo,
    t.descripcion,
    t.estado,
    t.prioridad,
    t.fecha_limite,
    t.completada,
    e.id AS empleado_id,
    e.nombre AS empleado_nombre,
    e.email AS empleado_email
FROM tareas t
LEFT JOIN empleados e ON t.empleado_id = e.id;
```

---

## **2. Consultar una tarea por id con su persona asignada**

```sql
SELECT
    t.id,
    t.titulo,
    t.descripcion,
    t.estado,
    t.prioridad,
    t.fecha_limite,
    t.completada,
    e.id AS empleado_id,
    e.nombre AS empleado_nombre,
    e.email AS empleado_email
FROM tareas t
LEFT JOIN empleados e ON t.empleado_id = e.id
WHERE t.id = ?;
```

---

## **3. Consultar todas las personas asignables**

```sql
SELECT
    id,
    nombre,
    email
FROM empleados;
```

---

## **4. Consultar una persona por id**

```sql
SELECT
    id,
    nombre,
    email
FROM empleados
WHERE id = ?;
```

---

## **5. Insertar una nueva tarea**

```sql
INSERT INTO tareas (
    titulo,
    descripcion,
    estado,
    prioridad,
    fecha_limite,
    completada,
    empleado_id
)
VALUES (?, ?, ?, ?, ?, ?, ?);
```

Orden de parámetros:

```
titulo
descripcion
estado
prioridad
fecha_limite
completada
empleado_id
```

---

## **6. Actualizar una tarea existente**

```sql
UPDATE tareas
SET
    titulo = ?,
    descripcion = ?,
    estado = ?,
    prioridad = ?,
    fecha_limite = ?,
    completada = ?,
    empleado_id = ?
WHERE id = ?;
```

Orden de parámetros:

```
titulo
descripcion
estado
prioridad
fecha_limite
completada
empleado_id
id
```

---

## **7. Eliminar una tarea**

```sql
DELETE FROM tareas
WHERE id = ?;
```

---

## **8. Filtrar tareas por estado**

```sql
SELECT
    t.id,
    t.titulo,
    t.descripcion,
    t.estado,
    t.prioridad,
    t.fecha_limite,
    t.completada,
    e.id AS empleado_id,
    e.nombre AS empleado_nombre,
    e.email AS empleado_email
FROM tareas t
LEFT JOIN empleados e ON t.empleado_id = e.id
WHERE t.estado = ?;
```

---

## **9. Filtrar tareas por prioridad**

```sql
SELECT
    t.id,
    t.titulo,
    t.descripcion,
    t.estado,
    t.prioridad,
    t.fecha_limite,
    t.completada,
    e.id AS empleado_id,
    e.nombre AS empleado_nombre,
    e.email AS empleado_email
FROM tareas t
LEFT JOIN empleados e ON t.empleado_id = e.id
WHERE t.prioridad = ?;
```

---

## **10. Filtrar tareas por persona asignada**

```sql
SELECT
    t.id,
    t.titulo,
    t.descripcion,
    t.estado,
    t.prioridad,
    t.fecha_limite,
    t.completada,
    e.id AS empleado_id,
    e.nombre AS empleado_nombre,
    e.email AS empleado_email
FROM tareas t
LEFT JOIN empleados e ON t.empleado_id = e.id
WHERE t.empleado_id = ?;
```

---

## **11. Buscar tareas por texto en título o descripción**

```sql
SELECT
    t.id,
    t.titulo,
    t.descripcion,
    t.estado,
    t.prioridad,
    t.fecha_limite,
    t.completada,
    e.id AS empleado_id,
    e.nombre AS empleado_nombre,
    e.email AS empleado_email
FROM tareas t
LEFT JOIN empleados e ON t.empleado_id = e.id
WHERE t.titulo LIKE ? OR t.descripcion LIKE ?;
```

En Java, el parámetro se construiría así:

```java
String parametro = "%" + texto + "%";
```

Y se pasaría dos veces:

```java
jdbcTemplate.query(sql, rowMapper, parametro, parametro);
```

---

## **12. Filtrar tareas por completada**

```sql
SELECT
    t.id,
    t.titulo,
    t.descripcion,
    t.estado,
    t.prioridad,
    t.fecha_limite,
    t.completada,
    e.id AS empleado_id,
    e.nombre AS empleado_nombre,
    e.email AS empleado_email
FROM tareas t
LEFT JOIN empleados e ON t.empleado_id = e.id
WHERE t.completada = ?;
```

---

## **13. Ordenar tareas por fecha límite**

```sql
SELECT
    t.id,
    t.titulo,
    t.descripcion,
    t.estado,
    t.prioridad,
    t.fecha_limite,
    t.completada,
    e.id AS empleado_id,
    e.nombre AS empleado_nombre,
    e.email AS empleado_email
FROM tareas t
LEFT JOIN empleados e ON t.empleado_id = e.id
ORDER BY t.fecha_limite ASC;
```

---

## **14. Contar tareas**

```sql
SELECT COUNT(*)
FROM tareas;
```

---

## **15. Comprobar si existe una tarea**

```sql
SELECT COUNT(*)
FROM tareas
WHERE id = ?;
```

---

## **16. Comprobar si existe una persona asignable**

```sql
SELECT COUNT(*)
FROM empleados
WHERE id = ?;
```

---

## **17. Consultar solo tareas pendientes**

```sql
SELECT
    t.id,
    t.titulo,
    t.descripcion,
    t.estado,
    t.prioridad,
    t.fecha_limite,
    t.completada,
    e.id AS empleado_id,
    e.nombre AS empleado_nombre,
    e.email AS empleado_email
FROM tareas t
LEFT JOIN empleados e ON t.empleado_id = e.id
WHERE t.estado = 'PENDIENTE';
```

---

## **18. Consultar solo tareas en proceso**

```sql
SELECT
    t.id,
    t.titulo,
    t.descripcion,
    t.estado,
    t.prioridad,
    t.fecha_limite,
    t.completada,
    e.id AS empleado_id,
    e.nombre AS empleado_nombre,
    e.email AS empleado_email
FROM tareas t
LEFT JOIN empleados e ON t.empleado_id = e.id
WHERE t.estado = 'EN_PROCESO';
```

---

## **19. Consultar solo tareas completadas**

```sql
SELECT
    t.id,
    t.titulo,
    t.descripcion,
    t.estado,
    t.prioridad,
    t.fecha_limite,
    t.completada,
    e.id AS empleado_id,
    e.nombre AS empleado_nombre,
    e.email AS empleado_email
FROM tareas t
LEFT JOIN empleados e ON t.empleado_id = e.id
WHERE t.estado = 'COMPLETADA';
```

---

## **20. Consultar tareas de prioridad alta**

```sql
SELECT
    t.id,
    t.titulo,
    t.descripcion,
    t.estado,
    t.prioridad,
    t.fecha_limite,
    t.completada,
    e.id AS empleado_id,
    e.nombre AS empleado_nombre,
    e.email AS empleado_email
FROM tareas t
LEFT JOIN empleados e ON t.empleado_id = e.id
WHERE t.prioridad = 'ALTA';
```
