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
| IDE | IntelliJ IDEA 2026.3 |

> Importante: se requiere **Tomcat 10.1** (paquetes `jakarta.*`). Tomcat 9 no es compatible.

## Estructura

```text
src/main/java/pe/edu/upn/billetera/
├── controller/BilleteraServlet.java   # GET muestra datos, POST procesa movimiento
└── model/
    ├── Billetera.java                 # saldo (S/ 250.00 inicial) + historial
    └── Movimiento.java                # tipo (Recarga/Gasto) + monto
src/main/webapp/WEB-INF/views/
└── billetera.jsp                      # vista con JSTL (<c:forEach>, <c:if>), sin scriptlets
