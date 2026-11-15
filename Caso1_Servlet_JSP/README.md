# Evaluación T1 - Caso 1: Billetera Digital (Servlet + JSP)

Aplicación web desarrollada en Java puro aplicando el patrón MVC sin frameworks adicionales, renderizando las vistas en el servidor y manteniendo el estado en la sesión HTTP. 
Desarrollado individualmente por Renzo Alexander Palomino Ramos.

## Herramientas y Versiones
* **Lenguaje:** Java (JDK 21 - Eclipse Temurin 21.0.11)
* **Servidor de Aplicaciones:** Apache Tomcat 10.1.61
* **Librerías Web:** Jakarta Servlet API 6.0.0, Jakarta Standard Tag Library (JSTL) 3.0
* **Empaquetado:** Apache Maven 3.9
* **Presentación:** Bootstrap 5.3.3 (vía CDN)

## Pasos para ejecutar el proyecto
1. Clonar el repositorio en la máquina local.
2. Abrir el proyecto en IntelliJ IDEA (versión Ultimate o Community con soporte Maven).
3. Recargar el archivo `pom.xml` para descargar las dependencias de Jakarta.
4. Generar el archivo compilado ejecutando el ciclo de vida de Maven: `mvn clean package`. El archivo se ubicará en `target/billetera.war`.
5. Configurar un servidor local apuntando a la carpeta de instalación de **Apache Tomcat 10.1.x** y vinculando el JRE a Java 21.
6. En la configuración de despliegue (Deployment) del servidor, agregar el artefacto `Caso1_Servlet_JSP:war exploded` y establecer el *Application context* a `/billetera`.
7. Iniciar el servidor (Run) y abrir el navegador en `http://localhost:8080/billetera/`.
