# Caso 2 – Billetera Digital: Pago y Movimientos (Angular)

Billetera digital construida con **dos componentes funcionales** que se comunican mediante flujo padre ↔ hijo:

| Componente | Rol |
|---|---|
| `BilleteraComponent` (padre) | Dueño del estado: saldo (`S/ 250.00` inicial) y arreglo de movimientos mediante `signal()`. Muestra el saldo con interpolación, el historial con `@for` y el mensaje "Aún no hay movimientos" con `@if`. |
| `NuevoMovimientoComponent` (hijo) | Recibe el saldo con `input()`, muestra el formulario con Bootstrap (tipo y monto), valida en tiempo real y emite solo solicitudes válidas con `output()`. Muestra errores con `@if` y bloquea el botón con `[disabled]`. |

`App` (`app.ts`) solo actúa como contenedor principal. No se emplean servicios, enrutamiento, formularios reactivos ni backend; el estado vive en memoria dentro del componente padre.

## Versiones utilizadas

| Herramienta | Versión |
|---|---|
| Node.js | 20.x+ |
| npm | 10.x+ |
| Angular / Angular CLI | 19.x+ (Standalone) |
| Bootstrap | 5.3.x |
| Editor | Visual Studio Code |

## Comandos de ejecución

```bash
# 1. Instalar dependencias del proyecto
npm install

# 2. Iniciar servidor de desarrollo (http://localhost:4200/)
npm start          # equivalente a: ng serve

# (Opcional) Compilar para producción en carpeta dist/
npm run build
```

## Estructura

src/app/
├── app.ts / app.html                    # contenedor principal
├── movimiento.model.ts                  # interfaz Movimiento { tipo, monto }
├── billetera/                           # componente PADRE
│   ├── billetera.ts
│   └── billetera.html
└── nuevo-movimiento/                    # componente HIJO
    ├── nuevo-movimiento.ts
    └── nuevo-movimiento.html

## Flujo padre ↔ hijo

BilleteraComponent ── [saldo]="saldo()" (input) → NuevoMovimientoComponent
BilleteraComponent ← (movimientoValido) (output) ── NuevoMovimientoComponent

## Pruebas funcionales

| # | Acción | Resultado esperado |
|:---:|---|---|
| **1** | Abrir la aplicación | Saldo S/ 250.00; historial vacío |
| **2** | Registrar recarga de S/ 100.00 | Saldo S/ 350.00; recarga incorporada al historial |
| **3** | Registrar gasto de S/ 50.00 | Saldo S/ 300.00; gasto aparece antes que recarga |
| **4** | Intentar gasto de S/ 400.00 | Se rechaza; aparece un error; saldo continúa en S/ 300.00 |
| **5** | Ingresar cero, negativo o monto vacío | Se rechaza; no cambia el saldo ni el historial |

## Autor

Integrantes del Grupo 15
