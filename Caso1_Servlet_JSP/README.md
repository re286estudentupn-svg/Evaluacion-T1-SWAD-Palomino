# Caso 1 – Billetera Digital: Recarga y Movimientos (Servlet + JSP)

Aplicación web en Java puro (sin frameworks) que muestra el saldo y el historial de una billetera digital y permite registrar **recargas** y **gastos**. La vista se genera en el servidor (JSP + JSTL) y los datos se guardan en la **sesión HTTP** (`HttpSession`).

## Versiones utilizadas

| Herramienta | Versión |
|---|---|
| Java (JDK) | 21.0.11 (Eclipse Temurin) |
| Apache Maven | 3.9.x |
| Apache Tomcat | 10.1.61 (Jakarta EE 10) |
| Jakarta Servlet API | 6.0.0 |
| Jakarta JSTL | 3.0.0 (API 3.0.0 / impl. GlassFish 3.0.1) |
| Bootstrap | 5.3.3 (CDN) |
| IDE | IntelliJ IDEA 2024.x |

> Importante: se requiere **Tomcat 10.1** (paquetes `jakarta.*`). Tomcat 9 no es compatible.

## Estructura

```
src/main/java/pe/edu/upn/billetera/
|-- controller/BilleteraServlet.java   # GET muestra datos, POST procesa movimiento
+-- model/
    |-- Billetera.java                 # saldo (S/ 250.00 inicial) + historial
    +-- Movimiento.java                # tipo (Recarga/Gasto) + monto
src/main/webapp/WEB-INF/views/
+-- billetera.jsp                      # vista con JSTL (<c:forEach>, <c:if>), sin scriptlets
```

## Funcionamiento

- `GET /billetera` -> el Servlet obtiene la billetera de la sesión y hace `forward()` a la JSP.
- `POST /billetera` -> el Servlet valida:
  - monto vacío -> *"El monto es obligatorio."*
  - monto no numérico -> *"El monto debe ser un valor numérico."*
  - monto <= 0 -> *"El monto debe ser mayor que cero."*
  - gasto mayor al saldo -> *"Saldo insuficiente para realizar el gasto."*

  Si hay error, se muestra en la misma vista **sin modificar** saldo ni historial.
  Si es válido, actualiza el saldo, inserta el movimiento **al inicio** del historial y aplica **Post-Redirect-Get** (`sendRedirect`) para evitar reenvíos al actualizar.

## Pasos de ejecución

### Opción A: Desde IntelliJ IDEA
1. Abrir la carpeta `Caso1_Servlet_JSP` en IntelliJ IDEA y recargar las dependencias de `pom.xml`.
2. Ir a *Run -> Edit Configurations -> + -> Tomcat Server -> Local* y seleccionar la carpeta de instalación de **Apache Tomcat 10.1.61** con JRE Temurin 21.
3. En la pestaña *Deployment*, agregar el artefacto `Caso1_Servlet_JSP:war exploded` con contexto `/billetera`.
4. Presionar **Run** y abrir `http://localhost:8080/billetera/`.

### Opción B: Despliegue manual del archivo `.war`
1. Ejecutar el ciclo `package` desde el panel de Maven en IntelliJ IDEA (o `mvn clean package`). Se genera `target/billetera.war`.
2. Copiar `target/billetera.war` dentro de la carpeta `webapps/` de Apache Tomcat 10.1.61.
3. Iniciar el servidor con `bin\startup.bat` y abrir `http://localhost:8080/billetera/`.

## Pruebas funcionales

| # | Acción | Resultado esperado |
|:---:|---|---|
| **1** | Abrir la aplicación | Saldo S/ 250.00; historial vacío ("Aún no hay movimientos") |
| **2** | Registrar recarga de S/ 100.00 | Saldo S/ 350.00; recarga incorporada al historial |
| **3** | Registrar gasto de S/ 50.00 | Saldo S/ 300.00; gasto aparece antes que recarga |
| **4** | Intentar gasto de S/ 400.00 | Rechazado: "Saldo insuficiente para realizar el gasto."; saldo continúa en S/ 300.00 |
| **5** | Ingresar cero, negativo, vacío o texto | Rechazado con mensaje de alerta; no cambia el saldo ni el historial |

## Autor

**Renzo Alexander Palomino Ramos**
