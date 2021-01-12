<%@page import="Modelo.ConexionEstatica"%>
<%@page import="Modelo.Usuario"%>
<%@page import="java.util.ArrayList"%>
<%
    if (request.getParameter("actualizarUsuario") != null) {
        int id = Integer.parseInt(request.getParameter("id"));
        String nombre = request.getParameter("nombre");
        String correo = request.getParameter("correo");

        boolean admin = false;
        String s[] = request.getParameterValues("admin");
        if (s != null && s.length != 0) {
            admin = true;
        }

        boolean autor = false;
        s = request.getParameterValues("autor");
        if (s != null && s.length != 0) {
            autor = true;
        }

        int activo = 0;
        s = request.getParameterValues("admin");
        if (s != null && s.length != 0) {
            activo = 1;
        }

        //Comprueba si es administrador
        boolean esAdmin = false;
        ConexionEstatica.nueva();
        ArrayList rolesUsuario = ConexionEstatica.getRoles(id);
        ConexionEstatica.cerrarBD();
        for (int i = 0; i < rolesUsuario.size(); i++) {
            int rol = (int) rolesUsuario.get(i);
            if (rol == 1) {
                esAdmin = true;
            }
        }

        //Comprueba si es autor
        boolean esAutor = false;
        for (int i = 0; i < rolesUsuario.size(); i++) {
            int rol = (int) rolesUsuario.get(i);
            if (rol == 0) {
                esAdmin = true;
            }
        }

        //Comprueba si se ha cambiado el correo
        ConexionEstatica.nueva();
        String correoOriginal = ConexionEstatica.getCorreoById(id);
        System.out.println(correoOriginal);
        boolean existeCorreo = ConexionEstatica.existeUsuario(correo);
        ConexionEstatica.cerrarBD();

        if (correoOriginal.compareTo(correo) != 0 && existeCorreo) {
            //Ha cambiado el correo de un usuario por otro que ya existe en la BD
            session.setAttribute("mensaje", "ERROR: El correo ya está siendo utilizado.");
            response.sendRedirect("../crud.jsp");
        } else {
            //Elimina o inserta el rol '1' (administrador)
            if (esAdmin && !admin) {
                ConexionEstatica.nueva();
                ConexionEstatica.removeRol(id, 1);
                ConexionEstatica.cerrarBD();
            } else if (!esAdmin && admin) {
                ConexionEstatica.nueva();
                ConexionEstatica.addRol(id, 1);
                ConexionEstatica.cerrarBD();
            }

            //Elimina o inserta el rol '0' (autor)
            if (esAutor && !autor) {
                ConexionEstatica.nueva();
                ConexionEstatica.removeRol(id, 0);
                ConexionEstatica.cerrarBD();
            } else {
                ConexionEstatica.nueva();
                ConexionEstatica.addRol(id, 0);
                ConexionEstatica.cerrarBD();
            }
            
            //Actualiza los datos del usuario
            ConexionEstatica.nueva();
            ConexionEstatica.updateUser(id, nombre, correo, activo);
            
            session.setAttribute("mensaje", "Se ha actualizado el usuario");
            response.sendRedirect("../controladores/controladorPrincipal.jsp?administrarUsuarios=1");
        }

    }
%>