## **1. Qué es Thymeleaf y por qué se usa con Spring**

Thymeleaf es un motor de plantillas para Java orientado a HTML “natural”, es decir, plantillas que siguen siendo HTML válido incluso antes de renderizarse. Con Spring MVC se usa para devolver vistas HTML desde controladores, leyendo datos del Model y aplicando atributos th:* en la plantilla. Spring y Thymeleaf documentan esta integración como una opción habitual para sustituir JSP y construir vistas de servidor.

---

## **2. Dependencias y estructura básica**

En Spring Boot, lo normal es usar estos starters:

```xml
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>

    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-thymeleaf</artifactId>
    </dependency>
</dependencies>
```

Spring Boot auto-configura Thymeleaf cuando detecta el starter, y por defecto busca plantillas en src/main/resources/templates. Además, con DevTools los cambios en plantillas suelen recargarse sin reiniciar toda la aplicación.

Estructura típica:

```java
src/main/java/com/ejemplo/demo
  ├── DemoApplication.java
  └── web/
      └── HomeController.java

src/main/resources/
  ├── templates/
  │   └── home.html
  └── application.yml
```

---

## **3. Primer ejemplo completo**

### **Controlador**

```java
package com.ejemplo.demo.web;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @GetMapping("/home")
    public String home(Model model) {
        model.addAttribute("titulo", "Bienvenido a Thymeleaf");
        model.addAttribute("usuario", "Iván");
        return "home";
    }
}
```

### **Plantilla home.html**

```html
<!DOCTYPE html>
<html lang="es" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title th:text="${titulo}">Título por defecto</title>
</head>
<body>
    <h1 th:text="${titulo}">Título por defecto</h1>
    <p th:text="'Hola, ' + ${usuario}">Hola, usuario</p>
</body>
</html>
```

Aquí ya aparecen dos ideas clave:

- el controlador devuelve el nombre de la vista: home
- Thymeleaf reemplaza el contenido con th:text

Eso es la base de casi todo. La sintaxis ${...} accede a variables del modelo, y th:text sustituye el cuerpo del elemento escapando HTML.

---

## **4. Sintaxis base que debes conocer**

### **Variables del modelo: ${...}**

Sirven para leer atributos del Model.

```html
<p th:text="${usuario}">Nombre</p>
```

### **Mensajes i18n: #{...}**

Sirven para leer mensajes de messages.properties.

```html
<p th:text="#{app.titulo}">Título</p>
```

### **URLs: @{...}**

Sirven para construir rutas y URLs.

```html
<a th:href="@{/home}">Inicio</a>
```

### **Selección sobre objeto: {...}**

Se usa mucho en formularios con th:object.

```html
<input th:field="*{nombre}">
```

### **Expresiones de fragmento: ~{...}**

Sirven para insertar o reemplazar fragmentos.

```html
<div th:replace="~{fragments/header :: menu}"></div>
```

Estas son las expresiones nucleares del dialecto estándar y de la integración con Spring.

---

## **5. Directivas Thymeleaf más importantes**

## **th:text**

Reemplaza el texto de una etiqueta, escapando HTML.

```html
<p th:text="${mensaje}">Texto por defecto</p>
```

Si mensaje = "<b>hola</b>", se verá como texto literal, no como HTML.

## **th:utext**

Reemplaza el contenido sin escapar HTML.

```html
<div th:utext="${htmlGenerado}">HTML aquí</div>
```

Úsalo con cuidado, porque puede introducir XSS si el contenido no es seguro. Thymeleaf distingue explícitamente entre salida escapada y no escapada.

## **th:if y th:unless**

Renderizan o no un elemento según una condición.

```html
<p th:if="${activo}">Usuario activo</p>
<p th:unless="${activo}">Usuario inactivo</p>
```

Ejemplos útiles:

```html
<div th:if="${lista != null and !#lists.isEmpty(lista)}">Hay datos</div>
<div th:unless="${#lists.isEmpty(lista)}">La lista no está vacía</div>
```

## **th:switch y th:case**

Útil cuando hay varios estados.

```html
<div th:switch="${estado}">
    <p th:case="'PENDIENTE'">Pendiente</p>
    <p th:case="'EN_PROCESO'">En proceso</p>
    <p th:case="'FINALIZADO'">Finalizado</p>
    <p th:case="*">Estado desconocido</p>
</div>
```

## **th:each**

Itera colecciones.

```html
<ul>
    <li th:each="alumno : ${alumnos}" th:text="${alumno.nombre}">Alumno</li>
</ul>
```

Puedes usar el estado de iteración:

```html
<tr th:each="alumno, stat : ${alumnos}">
    <td th:text="${stat.count}">1</td>
    <td th:text="${alumno.nombre}">Nombre</td>
    <td th:text="${stat.even} ? 'par' : 'impar'">par</td>
</tr>
```

stat da acceso a cosas como index, count, size, first, last, even, odd.

## **th:object**

Define un objeto base para expresiones *{...}.

```html
<form th:object="${usuarioForm}">
    <input th:field="*{nombre}">
    <input th:field="*{email}">
</form>
```

Muy usado en formularios con Spring.

## **th:field**

Enlaza un campo HTML con una propiedad del objeto del formulario.

```html
<input type="text" th:field="*{nombre}">
<input type="email" th:field="*{email}">
<input type="checkbox" th:field="*{aceptaCondiciones}">
<select th:field="*{rol}">
    <option value="ADMIN">Admin</option>
    <option value="USER">User</option>
</select>
```

Con Spring, th:field gestiona nombre, id, valor, selección, checkboxes y binding con BindingResult. La integración Spring+Thymeleaf documenta específicamente estas utilidades para formularios y validación.

## **th:errors**

Muestra errores de validación.

```html
<div th:if="${#fields.hasErrors('nombre')}" th:errors="*{nombre}">
    Error en nombre
</div>
```

## **th:errorclass**

Añade una clase CSS si el campo tiene error.

```html
<input type="text" th:field="*{nombre}" th:errorclass="is-invalid">
```

## **th:with**

Define variables locales temporales.

```html
<div th:with="precioConIva=${precio * 1.21}">
    <span th:text="${precioConIva}">0</span>
</div>
```

Muy útil para simplificar expresiones largas.

## **th:attr**

Permite establecer atributos manualmente.

```html
<img th:attr="src=${rutaImagen},alt=${descripcion}">
```

En la práctica suele ser mejor usar los atributos específicos.

## **th:href y th:src**

Para enlaces e imágenes.

```html
<a th:href="@{/usuarios/{id}(id=${usuario.id})}">Ver usuario</a>
<img th:src="@{/img/logo.png}" alt="Logo">
```

## **th:value**

Para valores de inputs.

```html
<input type="hidden" th:value="${usuario.id}">
```

## **th:id , th:name , th:title , th:alt**

Asignan atributos concretos.

```html
<input th:id="'campo-' + ${usuario.id}" th:name="nombreUsuario">
```

## **th:classappend y th:styleappend**

Añaden clases o estilos sin sobrescribir lo anterior.

```html
<div class="card" th:classappend="${destacado} ? ' card-destacada' : ''"></div>
```

```html
<p style="font-size:14px" th:styleappend="${error} ? 'color:red;' : ''"></p>
```

## **th:fragment**

Define un fragmento reutilizable.

```html
<header th:fragment="cabecera(titulo)">
    <h1 th:text="${titulo}">Título</h1>
</header>
```

## **th:replace**

Reemplaza el elemento actual por el fragmento.

```html
<div th:replace="~{fragments/header :: cabecera('Inicio')}"></div>
```

## **th:insert**

Inserta el fragmento dentro del elemento actual.

```html
<div th:insert="~{fragments/header :: cabecera('Inicio')}"></div>
```

La documentación de Thymeleaf y Spring cubre fragmentos, layouts y la diferencia entre insertar y reemplazar.

## **th:remove**

Elimina etiqueta, cuerpo o ambos.

```html
<div th:remove="all">Este bloque desaparece</div>
```

Útil en prototipos o plantillas base.

## **th:inline**

Permite procesar expresiones dentro de JavaScript, CSS o texto.

### **JavaScript inline**

```html
<script th:inline="javascript">
    let nombre = [[${usuario.nombre}]];
    let activo = [[${usuario.activo}]];
</script>
```

### **CSS inline**

```html
<style th:inline="css">
    .avatar {
        background-image: url([[${rutaAvatar}]]);
    }
</style>
```

---

## **6. URLs con parámetros y rutas**

### **Ruta simple**

```html
<a th:href="@{/alumnos}">Alumnos</a>
```

### **Ruta con variable**

```html
<a th:href="@{/alumnos/{id}(id=${alumno.id})}">Ver</a>
```

### **Ruta con query params**

```html
<a th:href="@{/buscar(q=${texto}, pagina=${pagina})}">Buscar</a>
```

### **URL externa**

```html
<a th:href="@{https://www.ejemplo.com}">Externa</a>
```

La sintaxis @{...} es la recomendada para construir enlaces porque maneja contexto, parámetros y variables de ruta.

---

## **7. Formularios con Spring y Thymeleaf**

### **DTO/Form**

```java
package com.ejemplo.demo.web;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

@Data
public class UsuarioForm {

    @NotBlank
    private String nombre;

    @Email
    private String email;

    private boolean aceptaCondiciones;

}
```

### **Controlador**

```java
package com.ejemplo.demo.web;

import jakarta.validation.Valid;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/usuarios")
public class UsuarioController {

    @GetMapping("/nuevo")
    public String mostrarFormulario(Model model) {
        model.addAttribute("usuarioForm", new UsuarioForm());
        return "usuarios/form";
    }

    @PostMapping
    public String guardar(@Valid @ModelAttribute("usuarioForm") UsuarioForm form, BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            return "usuarios/form";
        }
        return "redirect:/usuarios/exito";
    }
}
```

### **Plantilla**

```html
<!DOCTYPE html>
<html lang="es" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>Formulario</title>
</head>
<body>

<form th:action="@{/usuarios}" th:object="${usuarioForm}" method="post">
    <div>
        <label for="nombre">Nombre</label>
        <input id="nombre" type="text" th:field="*{nombre}" th:errorclass="is-invalid">
        <div th:if="${#fields.hasErrors('nombre')}" th:errors="*{nombre}">Error nombre</div>
    </div>

    <div>
        <label for="email">Email</label>
        <input id="email" type="email" th:field="*{email}" th:errorclass="is-invalid">
        <div th:if="${#fields.hasErrors('email')}" th:errors="*{email}">Error email</div>
    </div>

    <div>
        <label>
            <input type="checkbox" th:field="*{aceptaCondiciones}">
            Acepto las condiciones
        </label>
    </div>

    <button type="submit">Guardar</button>
</form>

</body>
</html>
```

Esto cubre el flujo más típico de formularios en Spring MVC con Thymeleaf. La guía oficial de integración con Spring describe el uso de th:object, th:field, objetos de error y binding.

---

## **8. Fragmentos y layouts**

### **Archivo fragments/header.html**

```html
<!DOCTYPE html>
<html lang="es" xmlns:th="http://www.thymeleaf.org">
<body>
    <header th:fragment="menu(titulo)">
        <h1 th:text="${titulo}">Título</h1>
        <nav>
            <a th:href="@{/home}">Inicio</a>
            <a th:href="@{/usuarios/nuevo}">Nuevo usuario</a>
        </nav>
    </header>
</body>
</html>
```

### **Uso con th:replace**

```html
<div th:replace="~{fragments/header :: menu('Panel principal')}"></div>
```

### **Diferencia rápida**

- th:replace: sustituye el nodo completo
- th:insert: mete el fragmento dentro del nodo actual

Para composiciones más avanzadas existe también el Layout Dialect, pero con fragmentos estándar ya se resuelve muchísimo.

---

## **9. Internacionalización**

### **messages.properties**

```toml
app.titulo=Aplicación de ejemplo
usuario.nombre=Nombre
usuario.email=Correo electrónico
```

### **Plantilla**

```html
<h1 th:text="#{app.titulo}">Título</h1>
<label th:text="#{usuario.nombre}">Nombre</label>
<label th:text="#{usuario.email}">Email</label>
```

También con parámetros:

```java
saludo=Hola, {0}
```

```html
<p th:text="#{saludo(${usuario.nombre})}">Hola</p>
```

Thymeleaf usa la infraestructura de mensajes de Spring para i18n cuando está integrado con Spring MVC.

---

## **10. Operadores y expresiones útiles**

### **Concatenación**

```html
<p th:text="'Hola ' + ${usuario.nombre}"></p>
```

### **Ternario**

```html
<span th:text="${activo} ? 'Sí' : 'No'">Sí</span>
```

### **Elvis**

```html
<span th:text="${usuario.apodo} ?: 'Sin apodo'">Apodo</span>
```

### **Comparaciones**

```html
<div th:if="${edad >= 18}">Mayor de edad</div>
```

### **Acceso a propiedades**

```html
<p th:text="${usuario.nombre}"></p>
<p th:text="${usuario.direccion.ciudad}"></p>
```

### **Acceso a listas y mapas**

```html
<p th:text="${alumnos[0].nombre}"></p>
<p th:text="${mapa['clave']}"></p>
```

---

## **11. Objetos de utilidad frecuentes**

Thymeleaf ofrece varios objetos utilitarios para listas, cadenas, números, fechas, etc. En los tutoriales oficiales aparecen como parte del dialecto estándar.

### **Strings**

```html
<p th:text="${#strings.toUpperCase(usuario.nombre)}"></p>
<p th:text="${#strings.isEmpty(usuario.apodo)}"></p>
```

### **Lists**

```html
<div th:if="${#lists.isEmpty(alumnos)}">No hay alumnos</div>
```

### **Numbers**

```html
<p th:text="${#numbers.formatDecimal(precio, 1, 2)}"></p>
```

### **Temporals/fechas**

```html
<p th:text="${#temporals.format(fecha, 'dd/MM/yyyy')}"></p>
```

---

## **12. JavaScript con datos del servidor**

Una necesidad muy habitual.

```jsx
<script th:inline="javascript">
    const usuario = {
        id: [[${usuario.id}]],
        nombre: [[${usuario.nombre}]],
        activo: [[${usuario.activo}]]
    };
</script>
```

[[...]] dentro de th:inline="javascript" serializa valores para JS de forma segura y cómoda.

---

## **13. HTML5 puro con data-th-***

Si no quieres usar namespace XML o prefieres HTML5 puro:

```html
<p data-th-text="${usuario.nombre}">Nombre</p>
```

Thymeleaf permite esa forma para mantener HTML5 limpio y válido.

---

## **14. Configuración útil en application.yml**

```yaml
spring:
  thymeleaf:
    prefix: classpath:/templates/
    suffix: .html
    cache: false
    mode: HTML

  mvc:
    hiddenmethod:
      filter:
        enabled: true
```

Puntos típicos:

- cache: false en desarrollo
- prefix y suffix si quieres personalizar
- mode: HTML para HTML moderno

Spring Boot auto-configura Thymeleaf y permite personalizar sus propiedades mediante configuración externa.

---

## **15. Errores habituales**

### **Error: no encuentra plantilla**

Suele pasar porque el archivo no está en src/main/resources/templates o el controlador devuelve mal el nombre.

```java
return "home";
```

debe corresponder con:

```java
templates/home.html
```

### **Error: usar**

### **@RestController**

Si devuelves vistas, debe ser @Controller, no @RestController.

### **Error: mezclar th:text con HTML esperado**

Si quieres renderizar HTML, th:text no vale; usarías th:utext, pero con mucho cuidado.

### **Error: formularios sin th:object**

th:field funciona mejor cuando el formulario tiene un objeto base.

### **Error: querer usar Thymeleaf como si fuera React**

Thymeleaf es servidor-side. Renderiza HTML en el servidor; no sustituye un framework SPA.

---

## **16. Ejemplo completo de tabla con iteración, condiciones y enlaces**

```html
<!DOCTYPE html>
<html lang="es" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>Listado de alumnos</title>
</head>
<body>

<h1>Alumnos</h1>

<table border="1">
    <thead>
    <tr>
        <th>#</th>
        <th>Nombre</th>
        <th>Email</th>
        <th>Estado</th>
        <th>Acciones</th>
    </tr>
    </thead>
    <tbody>
    <tr th:each="alumno, stat : ${alumnos}">
        <td th:text="${stat.count}">1</td>
        <td th:text="${alumno.nombre}">Nombre</td>
        <td th:text="${alumno.email}">email@demo.com</td>
        <td>
            <span th:if="${alumno.activo}">Activo</span>
            <span th:unless="${alumno.activo}">Inactivo</span>
        </td>
        <td>
            <a th:href="@{/alumnos/{id}(id=${alumno.id})}">Ver</a>
        </td>
    </tr>
    </tbody>
</table>

<div th:if="${#lists.isEmpty(alumnos)}">
    No hay alumnos registrados.
</div>

</body>
</html>
```

---

## **17. Resumen rápido de directivas clave**

- th:text: texto escapado
- th:utext: texto no escapado
- th:if, th:unless: condiciones
- th:switch, th:case: múltiples casos
- th:each: iteración
- th:object: objeto base
- th:field: binding de formularios
- th:errors, th:errorclass: validación
- th:with: variables locales
- th:href, th:src: enlaces y recursos
- th:value, th:id, th:name: atributos comunes
- th:classappend, th:styleappend: añadir clase/estilo
- th:fragment: declarar fragmento
- th:replace, th:insert: reutilización de vistas
- th:inline: JS/CSS inline
- ${...}, #{...}, @{...}, *{...}, ~{...}: tipos de expresión

---