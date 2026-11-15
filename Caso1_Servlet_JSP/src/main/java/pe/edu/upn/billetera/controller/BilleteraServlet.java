package pe.edu.upn.billetera.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import pe.edu.upn.billetera.model.Billetera;
import pe.edu.upn.billetera.model.Movimiento;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;

@WebServlet(name = "BilleteraServlet", urlPatterns = {"", "/billetera"})
public class BilleteraServlet extends HttpServlet {

    private static final String VISTA = "/WEB-INF/views/billetera.jsp";
    private static final String ATTR_BILLETERA = "billetera";
    private static final String ATTR_MENSAJE_OK = "mensajeOk";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        obtenerBilletera(session); // Asegura que exista en sesión

        // Manejo de mensajes de éxito tras un POST
        Object mensajeOk = session.getAttribute(ATTR_MENSAJE_OK);
        if (mensajeOk != null) {
            req.setAttribute(ATTR_MENSAJE_OK, mensajeOk);
            session.removeAttribute(ATTR_MENSAJE_OK);
        }

        mostrarVista(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();
        Billetera billetera = obtenerBilletera(session);

        String tipo = req.getParameter("tipo");
        String montoTexto = req.getParameter("monto");

        // Retener los datos si hay error
        req.setAttribute("tipoIngresado", tipo);
        req.setAttribute("montoIngresado", montoTexto);

        // --- Validaciones (Requisitos del documento) ---
        if (!Movimiento.RECARGA.equals(tipo) && !Movimiento.GASTO.equals(tipo)) {
            error(req, resp, "Seleccione un tipo de movimiento válido.");
            return;
        }

        if (montoTexto == null || montoTexto.isBlank()) {
            error(req, resp, "El monto es obligatorio.");
            return;
        }

        BigDecimal monto;
        try {
            monto = new BigDecimal(montoTexto.trim().replace(",", "."));
        } catch (NumberFormatException e) {
            error(req, resp, "El monto debe ser un valor numérico.");
            return;
        }

        if (monto.compareTo(BigDecimal.ZERO) <= 0) {
            error(req, resp, "El monto debe ser mayor que cero.");
            return;
        }

        if (monto.scale() > 2) {
            error(req, resp, "El monto puede tener como máximo 2 decimales.");
            return;
        }
        monto = monto.setScale(2, RoundingMode.UNNECESSARY);

        if (Movimiento.GASTO.equals(tipo) && monto.compareTo(billetera.getSaldo()) > 0) {
            req.setAttribute("gastoSolicitado", monto);
            error(req, resp, "Saldo insuficiente para realizar el gasto.");
            return;
        }

        // --- Operación válida ---
        if (Movimiento.RECARGA.equals(tipo)) {
            billetera.recargar(monto);
        } else {
            billetera.gastar(monto);
        }

        session.setAttribute(ATTR_MENSAJE_OK, "Movimiento registrado: " + tipo + " de S/ " + monto);

        // Post-Redirect-Get
        resp.sendRedirect(req.getContextPath() + "/billetera");
    }

    private Billetera obtenerBilletera(HttpSession session) {
        Billetera billetera = (Billetera) session.getAttribute(ATTR_BILLETERA);
        if (billetera == null) {
            billetera = new Billetera();
            session.setAttribute(ATTR_BILLETERA, billetera);
        }
        return billetera;
    }

    private void error(HttpServletRequest req, HttpServletResponse resp, String mensaje) throws ServletException, IOException {
        req.setAttribute("error", mensaje);
        mostrarVista(req, resp);
    }

    private void mostrarVista(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher(VISTA).forward(req, resp);
    }
}