export type TipoMovimiento = 'Recarga' | 'Gasto';

export interface Movimiento {
  tipo: TipoMovimiento;
  monto: number;
}