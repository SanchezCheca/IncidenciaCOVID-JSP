<%@page import="Modelo.ConexionEstatica"%>
<%@page import="Modelo.Usuario"%>
<%@page import="java.util.ArrayList"%>
<%

    
    //--------------------------------BOTÓN "Aceptar registro"
    if (request.getParameter("aceptarRegistro") != null) {
        String correo = request.getParameter("correo");
        String nombre = request.getParameter("nombre");
        String pass = request.getParameter("pass");

        System.out.println("Hola!");
        ConexionEstatica.nueva();

        String mensaje = "";
        if (ConexionEstatica.existeUsuario(correo)) {
            ConexionEstatica.insertUser(nombre, correo, pass);
            ConexionEstatica.cerrarBD();

            mensaje = "Se ha registrado el usuario " + nombre;
            session.setAttribute("mensaje", mensaje);
            response.sendRedirect("../index.jsp");
        } else {
            ConexionEstatica.cerrarBD();

            mensaje = "ERROR: Este correo ya está registrado.";
            session.setAttribute("mensaje", mensaje);
            response.sendRedirect("../registro.jsp");
        }
    }
%>