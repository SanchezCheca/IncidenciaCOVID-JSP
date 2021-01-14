<%@page import="Modelo.ConexionEstatica"%>
<%@page import="Modelo.Usuario"%>
<%@page import="java.util.ArrayList"%>
<%

    //--------------------------------BOT�N "Aceptar registro"
    if (request.getParameter("aceptarRegistro") != null) {
        String correo = request.getParameter("correo");
        String nombre = request.getParameter("nombre");
        String pass = request.getParameter("pass");

        System.out.println("Hola!");
        ConexionEstatica.nueva();

        String mensaje = "";
        if (!ConexionEstatica.existeUsuario(correo)) {
            ConexionEstatica.insertUser(nombre, correo, pass);
            ConexionEstatica.cerrarBD();

            mensaje = "Se ha registrado el usuario " + nombre;
            session.setAttribute("mensaje", mensaje);
            response.sendRedirect("../index.jsp");
        } else {
            ConexionEstatica.cerrarBD();

            mensaje = "ERROR: Este correo ya est� registrado.";
            session.setAttribute("mensaje", mensaje);
            response.sendRedirect("../registro.jsp");
        }
    }

    //--------------------------------BOT�N "Iniciar sesi�n"
    if (request.getParameter("inicioSesion") != null) {
        String correo = request.getParameter("correo");
        String pass = request.getParameter("pass");

        ConexionEstatica.nueva();
        Usuario u = ConexionEstatica.getUsuario(correo, pass);
        ConexionEstatica.cerrarBD();

        String mensaje = "";
        if (u != null) {
            if (u.getActivo() == 1) {
                mensaje = "Has iniciado sesi�n como " + u.getNombre();
                session.setAttribute("usuarioIniciado", u);
            } else {
                mensaje = "Tu cuenta a�n no ha sido activada, tienes que esperar a que un administrador la active";
            }

        } else {
            mensaje = "ERROR: Correo y/o contrase�a incorrectos";
        }

        session.setAttribute("mensaje", mensaje);
        response.sendRedirect("../index.jsp");
    }

    //--------------------------------BOT�N "Cerrar sesi�n"
    if (request.getParameter("cerrarSesion") != null) {
        session.removeAttribute("usuarioIniciado");
        session.setAttribute("mensaje", "Has cerrado la sesi�n");
        response.sendRedirect("../index.jsp");
    }

    //--------------------------------BOT�N "Administrar usuarios"
    if (request.getParameter("administrarUsuarios") != null) {
        String mensaje = "";
        if (session.getAttribute("usuarioIniciado") != null) {
            Usuario u = (Usuario) session.getAttribute("usuarioIniciado");
            if (u.isAdmin()) {
                ConexionEstatica.nueva();
                ArrayList usuarios = ConexionEstatica.getAllUsers();
                ConexionEstatica.cerrarBD();
                session.setAttribute("usuarios", usuarios);
                response.sendRedirect("../crud.jsp");
            } else {
                mensaje = "ERROR: No tienes permiso para ver esta p�gina.";
            }
        } else {
            mensaje = "Ha ocurrido alg�n error.";
        }
    }

%>