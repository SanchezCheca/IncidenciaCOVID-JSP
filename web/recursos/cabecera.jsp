<%@page import="Modelo.Usuario"%>
<nav class="navbar navbar-expand navbar-light bg-white w-100 rounded-top">
    <a class = "navbar-brand" href = "index.jsp">
        <img src = "images/logo.png" width = "100" height = "auto" alt = "logo inCOVID">
    </a>
    <div class = "collapse navbar-collapse" id = "navbarNavDropdown">
        <ul class = "navbar-nav">
            <li class = "nav-item">
                <a class = "nav-link" href = "index.jsp">Informes de incidencia</a>
            </li>
            <%
                Usuario u = null;
                if (session.getAttribute("usuarioIniciado") != null) {
                    u = (Usuario) session.getAttribute("usuarioIniciado");
                    if (u.isAutor()) {
            %>
            <li class="nav-item">
                <a class = "nav-link" href = "crearInforme.jsp">+Nuevo informe</a>
            </li>
            <%
                    }
                }
            %>
        </ul>
        <div class = "dropdown ml-auto">
            <a class = "nav-link dropdown-toggle desplegable" href = "#" id = "navbarDropdownMenuLink" data-toggle = "dropdown" aria-haspopup = "true" aria-expanded = "false">
                Perfil
            </a>
            <div class = "dropdown-menu" aria-labelledby = "navbarDropdownMenuLink">

                <%
                    if (session.getAttribute("usuarioIniciado") != null) {
                        //Ha iniciado sesión, se muestran otras opciones

                %>
                <form name="menu" action="controladores/controladorPrincipal.jsp" method="POST">
                    <%                        if (u.isAdmin()) {
                    %>
                    <input type="submit" name="administrarUsuarios" class="dropdown-item" value="Administrar usuarios">
                    <input type="submit" name="administrarRegiones" class="dropdown-item" value="Administrar regiones">
                    <%
                        }
                    %>
                    <input type="submit" name="cerrarSesion" class="dropdown-item" value="Cerrar sesión">
                </form>
                <%
                } else {
                    //No ha iniciado sesión
                %>
                <a class = "dropdown-item" href = "login.jsp">Iniciar sesión</a>
                <a class = "dropdown-item" href = "registro.jsp">Crear cuenta</a>
                <%
                    }
                %>
            </div>
        </div>
    </div>
</nav>
<%
    //Muestra mensaje de alerta/error
    if (session.getAttribute("mensaje") != null) {
%>
<div class = "col-12 bg-warning d-flex justify-content-center">
    <%
        out.print(session.getAttribute("mensaje"));
    %>
</div>
<%
        session.removeAttribute("mensaje");
    }
%>