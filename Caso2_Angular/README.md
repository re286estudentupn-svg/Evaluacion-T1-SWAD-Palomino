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

BilleteraComponent ── [saldo]="saldo()" (input) ──▶ NuevoMovimientoComponent
BilleteraComponent ◀── (movimientoValido) (output) ── NuevoMovimientoComponent

Pruebas funcionales#AcciónResultado esperado1Abrir la aplicaciónSaldo S/ 250.00; "Aún no hay movimientos"2Recarga de S/ 100.00Saldo S/ 350.00; recarga en el historial3Gasto de S/ 50.00Saldo S/ 300.00; el gasto aparece antes que la recarga4Gasto de S/ 400.00Mensaje "Saldo insuficiente…" y botón deshabilitado; saldo sigue en S/ 300.005Monto 0, negativo o vacíoMensaje de error y botón deshabilitado; no cambia saldo ni historial
