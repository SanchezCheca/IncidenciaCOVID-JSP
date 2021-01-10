<%@page import="Modelo.ConexionEstatica"%>
<%

    
    //--------------------------------BOTÓN "Aceptar registro"
    if (request.getParameter("aceptarRegistro") != null) {
        String correo = request.getParameter("correo");
        String pass = request.getParameter("pass");
        String nombre = request.getParameter("nombre");
        String sexo = request.getParameter("sexo");
        int edad = Integer.parseInt(request.getParameter("edad"));

        ConexionEstatica.nueva();

        String mensaje = "";
        if (ConexionEstatica.existeUsuario(correo) == null) {
            ConexionEstatica.Insertar_Usuario(correo, pass, nombre, sexo, edad);
            ConexionEstatica.cerrarBD();

            mensaje = "Se ha registrado el usuario " + nombre;
            session.setAttribute("mensaje", mensaje);
            response.sendRedirect("../index.jsp");
        } else {
            ConexionEstatica.cerrarBD();

            mensaje = "ERROR: Este correo ya está registrado.";
            session.setAttribute("mensaje", mensaje);
            response.sendRedirect("../vistas/registro.jsp");
        }
    }
%>