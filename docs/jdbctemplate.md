

# Ayuda rápida: uso de `JdbcTemplate` en repositorios Spring

Este documento muestra ejemplos básicos de cómo usar `JdbcTemplate` dentro de una clase `Repository`.

Los ejemplos usan entidades genéricas como `Producto` y `Categoria`. Debes adaptar los nombres de clases, tablas, columnas y atributos al modelo real de tu aplicación.

---

## 1. Crear un repositorio JDBC

Un repositorio es la clase que se encarga de acceder a la base de datos.

```java
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class ProductoRepository {

    private final JdbcTemplate jdbcTemplate;

    public ProductoRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }
}
```

`JdbcTemplate` permite ejecutar consultas SQL desde Java.

---

## 2. Consultar todos los registros

Para obtener varios registros se usa `query`.

```java
public List<Producto> findAll() {
    String sql = "SELECT id, nombre, precio, stock FROM productos";

    return jdbcTemplate.query(sql, (rs, rowNum) -> {
        Producto producto = new Producto();
        producto.setId(rs.getLong("id"));
        producto.setNombre(rs.getString("nombre"));
        producto.setPrecio(rs.getBigDecimal("precio"));
        producto.setStock(rs.getInt("stock"));
        return producto;
    });
}
```

Imports habituales:

```java
import java.util.List;
```

---

## 3. Crear un método RowMapper

Si vas a convertir muchas veces una fila de la base de datos en un objeto Java, puedes crear un método privado.

```java
private Producto mapToProducto(ResultSet rs, int rowNum) throws SQLException {
    Producto producto = new Producto();
    producto.setId(rs.getLong("id"));
    producto.setNombre(rs.getString("nombre"));
    producto.setPrecio(rs.getBigDecimal("precio"));
    producto.setStock(rs.getInt("stock"));
    return producto;
}
```

Y usarlo así:

```java
public List<Producto> findAll() {
    String sql = "SELECT id, nombre, precio, stock FROM productos";
    return jdbcTemplate.query(sql, this::mapToProducto);
}
```

Imports necesarios:

```java
import java.sql.ResultSet;
import java.sql.SQLException;
```

---

## 4. Buscar un registro por id

Para buscar un único registro se puede usar `queryForObject`.

```java
public Optional<Producto> findById(Long id) {
    String sql = "SELECT id, nombre, precio, stock FROM productos WHERE id = ?";

    try {
        Producto producto = jdbcTemplate.queryForObject(sql, this::mapToProducto, id);
        return Optional.of(producto);
    } catch (EmptyResultDataAccessException e) {
        return Optional.empty();
    }
}
```

Imports necesarios:

```java
import java.util.Optional;
import org.springframework.dao.EmptyResultDataAccessException;
```

El símbolo `?` representa un parámetro.

Correcto:

```java
String sql = "SELECT id, nombre FROM productos WHERE id = ?";
```

Incorrecto:

```java
String sql = "SELECT id, nombre FROM productos WHERE id = " + id;
```

---

## 5. Insertar un registro

Para insertar datos se usa `update`.

```java
public void save(Producto producto) {
    String sql = """
        INSERT INTO productos (nombre, precio, stock)
        VALUES (?, ?, ?)
        """;

    jdbcTemplate.update(
        sql,
        producto.getNombre(),
        producto.getPrecio(),
        producto.getStock()
    );
}
```

El orden de los valores debe coincidir con el orden de las columnas del `INSERT`.

---

## 6. Actualizar un registro

Para actualizar datos también se usa `update`.

```java
public void update(Producto producto) {
    String sql = """
        UPDATE productos
        SET nombre = ?, precio = ?, stock = ?
        WHERE id = ?
        """;

    jdbcTemplate.update(
        sql,
        producto.getNombre(),
        producto.getPrecio(),
        producto.getStock(),
        producto.getId()
    );
}
```

---

## 7. Eliminar un registro

```java
public void deleteById(Long id) {
    String sql = "DELETE FROM productos WHERE id = ?";
    jdbcTemplate.update(sql, id);
}
```

---

## 8. Filtrar registros

Para filtrar datos se usa `WHERE`.

### Filtrar por texto

```java
public List<Producto> findByNombreContaining(String texto) {
    String sql = """
        SELECT id, nombre, precio, stock
        FROM productos
        WHERE nombre LIKE ?
        """;

    String parametro = "%" + texto + "%";

    return jdbcTemplate.query(sql, this::mapToProducto, parametro);
}
```

### Filtrar por un valor exacto

```java
public List<Producto> findByStock(Integer stock) {
    String sql = """
        SELECT id, nombre, precio, stock
        FROM productos
        WHERE stock = ?
        """;

    return jdbcTemplate.query(sql, this::mapToProducto, stock);
}
```

### Filtrar por un valor mínimo

```java
public List<Producto> findByStockMinimo(Integer stockMinimo) {
    String sql = """
        SELECT id, nombre, precio, stock
        FROM productos
        WHERE stock >= ?
        """;

    return jdbcTemplate.query(sql, this::mapToProducto, stockMinimo);
}
```

---

## 9. Consultas con relación entre tablas

Supongamos dos tablas:

```text
categorias
----------
id
nombre

productos
---------
id
nombre
precio
categoria_id
```

Consulta con `JOIN`:

```java
public List<Producto> findAllWithCategoria() {
    String sql = """
        SELECT
            p.id,
            p.nombre,
            p.precio,
            c.id AS categoria_id,
            c.nombre AS categoria_nombre
        FROM productos p
        LEFT JOIN categorias c ON p.categoria_id = c.id
        """;

    return jdbcTemplate.query(sql, this::mapToProductoWithCategoria);
}
```

Método de mapeo:

```java
private Producto mapToProductoWithCategoria(ResultSet rs, int rowNum) throws SQLException {
    Categoria categoria = new Categoria();
    categoria.setId(rs.getLong("categoria_id"));
    categoria.setNombre(rs.getString("categoria_nombre"));

    Producto producto = new Producto();
    producto.setId(rs.getLong("id"));
    producto.setNombre(rs.getString("nombre"));
    producto.setPrecio(rs.getBigDecimal("precio"));
    producto.setCategoria(categoria);

    return producto;
}
```

---

## 10. Insertar un registro con clave foránea

Si una tabla tiene una columna que apunta a otra tabla, normalmente se guarda el id relacionado.

```java
public void save(Producto producto, Long categoriaId) {
    String sql = """
        INSERT INTO productos (nombre, precio, stock, categoria_id)
        VALUES (?, ?, ?, ?)
        """;

    jdbcTemplate.update(
        sql,
        producto.getNombre(),
        producto.getPrecio(),
        producto.getStock(),
        categoriaId
    );
}
```

---

## 11. Actualizar un registro con clave foránea

```java
public void update(Producto producto, Long categoriaId) {
    String sql = """
        UPDATE productos
        SET nombre = ?, precio = ?, stock = ?, categoria_id = ?
        WHERE id = ?
        """;

    jdbcTemplate.update(
        sql,
        producto.getNombre(),
        producto.getPrecio(),
        producto.getStock(),
        categoriaId,
        producto.getId()
    );
}
```

---

## 12. Trabajar con fechas

Si en SQL tienes una columna de tipo `DATE`, en Java puedes usar `LocalDate`.

Leer una fecha:

```java
LocalDate fecha = rs.getDate("fecha_alta").toLocalDate();
```

Guardar una fecha:

```java
Date.valueOf(producto.getFechaAlta())
```

Imports necesarios:

```java
import java.sql.Date;
import java.time.LocalDate;
```

Ejemplo:

```java
public void save(Cliente cliente) {
    String sql = """
        INSERT INTO clientes (nombre, fecha_alta)
        VALUES (?, ?)
        """;

    jdbcTemplate.update(
        sql,
        cliente.getNombre(),
        Date.valueOf(cliente.getFechaAlta())
    );
}
```

---

## 13. Trabajar con booleanos

Leer un booleano:

```java
boolean activo = rs.getBoolean("activo");
```

Guardar un booleano:

```java
jdbcTemplate.update(sql, producto.getActivo());
```

---

## 14. Obtener el número de filas afectadas

`jdbcTemplate.update` devuelve el número de filas afectadas.

```java
public boolean deleteById(Long id) {
    String sql = "DELETE FROM productos WHERE id = ?";
    int filasAfectadas = jdbcTemplate.update(sql, id);
    return filasAfectadas > 0;
}
```

También puede usarse en `update`:

```java
public boolean update(Producto producto) {
    String sql = """
        UPDATE productos
        SET nombre = ?, precio = ?, stock = ?
        WHERE id = ?
        """;

    int filasAfectadas = jdbcTemplate.update(
        sql,
        producto.getNombre(),
        producto.getPrecio(),
        producto.getStock(),
        producto.getId()
    );

    return filasAfectadas > 0;
}
```

---

## 15. Contar registros

```java
public Integer count() {
    String sql = "SELECT COUNT(*) FROM productos";
    return jdbcTemplate.queryForObject(sql, Integer.class);
}
```

---

## 16. Comprobar si existe un registro

```java
public boolean existsById(Long id) {
    String sql = "SELECT COUNT(*) FROM productos WHERE id = ?";
    Integer total = jdbcTemplate.queryForObject(sql, Integer.class, id);
    return total != null && total > 0;
}
```

---

## 17. Métodos más usados de JdbcTemplate

`query` se usa cuando esperas varios resultados.

```java
jdbcTemplate.query(sql, rowMapper);
jdbcTemplate.query(sql, rowMapper, parametro1, parametro2);
```

`queryForObject` se usa cuando esperas un único resultado.

```java
jdbcTemplate.queryForObject(sql, rowMapper, id);
jdbcTemplate.queryForObject(sql, Integer.class);
```

`update` se usa para `INSERT`, `UPDATE` y `DELETE`.

```java
jdbcTemplate.update(sql, valor1, valor2, valor3);
```

---

## 18. Recomendaciones

- Usa `?` para los parámetros.
- No concatenes valores del usuario dentro del SQL.
- No escribas SQL en los controladores.
- Los métodos del repositorio deben tener nombres claros.
- Adapta siempre los nombres de columnas al script SQL real.
- Si una consulta se repite, crea un método `mapTo...`.
- Si puede no existir un registro, usa `Optional`.

---

## 19. Errores frecuentes

`Table does not exist`: el nombre de la tabla no coincide o la base de datos no está inicializada.

`Column not found`: el nombre de la columna usado en Java no coincide con el SQL.

`Incorrect date value`: la fecha no se está convirtiendo correctamente.

`There is no getter for property`: Thymeleaf intenta acceder a una propiedad que no existe o no tiene getter.

`Communications link failure`: la aplicación no puede conectarse a MySQL. Comprueba que Docker está levantado.

---

## 20. Resumen rápido

```java
// Listar
jdbcTemplate.query(sql, rowMapper);

// Buscar uno
jdbcTemplate.queryForObject(sql, rowMapper, id);

// Insertar
jdbcTemplate.update(sql, valor1, valor2, valor3);

// Actualizar
jdbcTemplate.update(sql, valor1, valor2, valor3, id);

// Eliminar
jdbcTemplate.update(sql, id);

// Contar
jdbcTemplate.queryForObject(sql, Integer.class);
```