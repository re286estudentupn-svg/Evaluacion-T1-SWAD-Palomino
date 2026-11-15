import { Component, input, output } from '@angular/core';
import { DecimalPipe } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Movimiento, TipoMovimiento } from '../movimiento.model';

@Component({
  selector: 'app-nuevo-movimiento',
  imports: [FormsModule, DecimalPipe],
  templateUrl: './nuevo-movimiento.html',
  styleUrl: './nuevo-movimiento.css'
})
export class NuevoMovimientoComponent {
  saldo = input.required<number>();
  movimientoValido = output<Movimiento>();

  tipo: TipoMovimiento = 'Recarga';
  monto: number | null = null;
  tocado = false;

  get montoValido(): boolean {
    const m = this.monto;
    return typeof m === 'number' && Number.isFinite(m) && m > 0
      && Math.round(m * 100) / 100 === m;
  }

  get saldoInsuficiente(): boolean {
    return this.tipo === 'Gasto' && this.montoValido && this.monto! > this.saldo();
  }

  get formularioValido(): boolean {
    return this.montoValido && !this.saldoInsuficiente;
  }

  registrar(): void {
    if (!this.formularioValido) {
      return;
    }
    this.movimientoValido.emit({ tipo: this.tipo, monto: this.monto! });
    this.monto = null;
    this.tocado = false;
  }
}