<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<fmt:setLocale value="en_US"/>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Mi Billetera Digital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark">
    <div class="container">
        <span class="navbar-brand fw-semibold">Mi Billetera Digital</span>
        <span class="badge bg-secondary">JSP + Servlet</span>
    </div>
</nav>

<main class="container py-4">
    <!-- Panel Superior -->
    <div class="row g-3 mb-4">
        <!-- Saldo -->
        <div class="col-md-6">
            <div class="card shadow-sm h-100">
                <div class="card-body">
                    <h6 class="text-uppercase text-muted small mb-1">Saldo disponible</h6>
                    <p class="display-6 fw-bold text-success mb-1">
                        S/ <fmt:formatNumber value="${billetera.saldo}" pattern="#,##0.00"/>
                    </p>
                    <small class="text-muted">
                        <c:choose>
                            <c:when test="${empty billetera.movimientos}">Aún no hay movimientos</c:when>
                            <c:otherwise>Después de ${fn:length(billetera.movimientos)} movimiento(s) válido(s)</c:otherwise>
                        </c:choose>
                    </small>
                </div>
            </div>
        </div>
        <!-- Explicación -->
        <div class="col-md-6">
            <div class="card border-primary-subtle bg-primary-subtle h-100">
                <div class="card-body">
                    <span class="badge bg-primary mb-2">GET / Servlet</span>
                    <p class="mb-1">Obtiene el saldo y el historial de la sesión HTTP.</p>
                    <small class="text-muted">Envía los datos a la vista JSP para mostrarlos.</small>
                </div>
            </div>
        </div>
    </div>

    <!-- Alertas de Éxito -->
    <c:if test="${not empty mensajeOk}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <c:out value="${mensajeOk}"/>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Cerrar"></button>
        </div>
    </c:if>

    <div class="row g-3 mb-4">
        <!-- Historial -->
        <div class="${not empty error ? 'col-lg-8' : 'col-12'}">
            <h5 class="fw-semibold">Movimientos recientes</h5>
            <div class="card shadow-sm">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-dark">
                        <tr>
                            <th>Tipo</th>
                            <th class="text-end">Monto (S/)</th>
                            <th class="text-center">Orden</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${empty billetera.movimientos}">
                                <tr>
                                    <td colspan="3" class="text-center text-muted py-4">Aún no hay movimientos</td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="mov" items="${billetera.movimientos}" varStatus="st">
                                    <tr>
                                        <td>
                                            <span class="badge rounded-pill px-4 py-2 ${mov.recarga ? 'bg-success' : 'bg-danger'}">
                                                <c:out value="${mov.tipo}"/>
                                            </span>
                                        </td>
                                        <td class="text-end fw-bold ${mov.recarga ? 'text-success' : 'text-danger'}">
                                                ${mov.recarga ? '+' : '-'} <fmt:formatNumber value="${mov.monto}" pattern="#,##0.00"/>
                                        </td>
                                        <td class="text-center text-muted small">
                                            <c:choose>
                                                <c:when test="${st.first}">Más reciente</c:when>
                                                <c:otherwise>Anterior</c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Alerta de Error (Validaciones) -->
        <c:if test="${not empty error}">
            <div class="col-lg-4">
                <div class="card border-danger h-100">
                    <div class="card-body">
                        <h6 class="text-danger fw-semibold">Movimiento rechazado</h6>
                        <c:if test="${not empty gastoSolicitado}">
                            <p class="mb-1 small">Gasto solicitado: S/ <fmt:formatNumber value="${gastoSolicitado}" pattern="#,##0.00"/></p>
                            <p class="mb-2 small">Saldo disponible: S/ <fmt:formatNumber value="${billetera.saldo}" pattern="#,##0.00"/></p>
                        </c:if>
                        <div class="alert alert-danger py-2 mb-0" role="alert">
                            <c:out value="${error}"/>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
    </div>

    <!-- Formulario -->
    <div class="card shadow-sm">
        <div class="card-body">
            <h5 class="fw-semibold">Nuevo movimiento</h5>
            <form method="post" action="${pageContext.request.contextPath}/billetera" class="row g-3 align-items-end">
                <div class="col-md-4">
                    <label for="tipo" class="form-label small text-muted">Tipo</label>
                    <select id="tipo" name="tipo" class="form-select">
                        <option value="Recarga" ${tipoIngresado == 'Recarga' ? 'selected' : ''}>Recarga</option>
                        <option value="Gasto" ${tipoIngresado == 'Gasto' ? 'selected' : ''}>Gasto</option>
                    </select>
                </div>
                <div class="col-md-4">
                    <label for="monto" class="form-label small text-muted">Monto (S/)</label>
                    <input id="monto" name="monto" type="text" inputmode="decimal"
                           class="form-control ${not empty error ? 'is-invalid' : ''}"
                           placeholder="0.00" value="<c:out value='${montoIngresado}'/>">
                </div>
                <div class="col-md-4 d-grid">
                    <button type="submit" class="btn btn-primary">Registrar movimiento</button>
                </div>
            </form>
        </div>
    </div>
</main>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>