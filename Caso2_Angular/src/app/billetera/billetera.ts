import { Component, signal } from '@angular/core';
import { DecimalPipe } from '@angular/common';
import { NuevoMovimientoComponent } from '../nuevo-movimiento/nuevo-movimiento';
import { Movimiento } from '../movimiento.model';

@Component({
  selector: 'app-billetera',
  imports: [NuevoMovimientoComponent, DecimalPipe],
  templateUrl: './billetera.html',
  styleUrl: './billetera.css'
})
export class BilleteraComponent {
  saldo = signal(250);
  movimientos = signal<Movimiento[]>([]);

  registrarMovimiento(mov: Movimiento): void {
    if (!(mov.monto > 0) || (mov.tipo === 'Gasto' && mov.monto > this.saldo())) {
      return;
    }

    const delta = mov.tipo === 'Recarga' ? mov.monto : -mov.monto;
    this.saldo.update(s => Math.round((s + delta) * 100) / 100);
    this.movimientos.update(lista => [mov, ...lista]);
  }
}