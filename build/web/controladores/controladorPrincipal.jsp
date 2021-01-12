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

        String mensaje = "";
        if (u != null) {
            mensaje = "Has iniciado sesi�n como " + u.getNombre();
            session.setAttribute("usuarioIniciado", u);
        } else {
            mensaje = "ERROR: Correo y/o contrase�a incorrectos";
        }

        session.setAttribute("mensaje", mensaje);
        response.sendRedirect("../index.jsp");
    }

    //--------------------------------BOT�N "Iniciar sesi�n"
    if (request.getParameter("administrarUsuarios") != null) {
        String mensaje = "";
        if (session.getAttribute("usuarioIniciado") != null) {
            Usuario u = (Usuario) session.getAttribute("usuarioIniciado");
            if (u.isAdmin()) {
                //RECIBIR TODOS LOS USUARIOS
            } else {
                mensaje = "ERROR: No tienes permiso para ver esta p�gina.";
            }
        } else {
            mensaje = "Ha ocurrido alg�n error.";
        }
    }
%>