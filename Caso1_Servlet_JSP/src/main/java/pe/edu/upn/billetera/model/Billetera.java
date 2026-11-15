package pe.edu.upn.billetera.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class Billetera implements Serializable {
    private static final long serialVersionUID = 1L;
    public static final BigDecimal SALDO_INICIAL = new BigDecimal("250.00");

    private BigDecimal saldo = SALDO_INICIAL;
    private final List<Movimiento> movimientos = new ArrayList<>();

    public BigDecimal getSaldo() { return saldo; }

    // Retorna la lista inmutable para la vista
    public List<Movimiento> getMovimientos() {
        return Collections.unmodifiableList(movimientos);
    }

    public void recargar(BigDecimal monto) {
        saldo = saldo.add(monto);
        // Agrega el movimiento al inicio del historial
        movimientos.add(0, new Movimiento(Movimiento.RECARGA, monto));
    }

    public void gastar(BigDecimal monto) {
        saldo = saldo.subtract(monto);
        movimientos.add(0, new Movimiento(Movimiento.GASTO, monto));
    }
}