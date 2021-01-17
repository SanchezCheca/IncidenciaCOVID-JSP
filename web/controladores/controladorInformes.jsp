<%@page import="Modelo.Informe"%>
<%@page import="Modelo.Usuario"%>
<%@page import="Modelo.ConexionEstatica"%>
<%
    /**
     * Crea un nuevo informe
     */
    if (request.getParameter("crearInforme") != null) {
        String semana = request.getParameter("semana");
        String region = request.getParameter("region");
        int nInfectados = Integer.parseInt(request.getParameter("nInfectados"));
        int nFallecidos = Integer.parseInt(request.getParameter("nFallecidos"));
        int nAltas = Integer.parseInt(request.getParameter("nAltas"));

        String mensaje = "";

        //Comprueba que no existe un informe para esa semana y región
        ConexionEstatica.nueva();
        if (!ConexionEstatica.isInforme(semana, region)) {
            //Recupera el id del usuario iniciado (autor)
            if (session.getAttribute("usuarioIniciado") != null) {
                Usuario u = (Usuario) session.getAttribute("usuarioIniciado");
                int idAutor = u.getId();
                ConexionEstatica.insertInforme(semana, region, nInfectados, nFallecidos, nAltas, idAutor);
                mensaje = "Se ha creado el informe";
            } else {
                mensaje = "Ha ocurrido algún error: Vuelve a iniciar sesión";
            }
        } else {
            mensaje = "ERROR: Ya existe un informe para esa semana y regióin";
        }
        session.setAttribute("mensaje", mensaje);
        response.sendRedirect("../crearInforme.jsp");

    }

    /**
     * Carga el informe de la BD y lo guarda en la sesión
     */
    if (request.getParameter("verInforme") != null) {
        int id = Integer.parseInt(request.getParameter("id"));

        ConexionEstatica.nueva();
        Informe informe = ConexionEstatica.getInforme(id);
        ConexionEstatica.cerrarBD();

        session.setAttribute("informe", informe);
        response.sendRedirect("../verInforme.jsp");
    }

    /**
     * Actualiza un informe
     */
    if (request.getParameter("actualizarInforme") != null) {
        int id = Integer.parseInt(request.getParameter("id"));
        int nInfectados = Integer.parseInt(request.getParameter("nInfectados"));
        int nFallecidos = Integer.parseInt(request.getParameter("nFallecidos"));
        int nAltas = Integer.parseInt(request.getParameter("nAltas"));

        if (session.getAttribute("usuarioIniciado") != null) {
            Usuario u = (Usuario) session.getAttribute("usuarioIniciado");
            int idAutor = u.getId();

            ConexionEstatica.nueva();
            ConexionEstatica.updateInforme(id, nInfectados, nFallecidos, nAltas, idAutor);
            Informe i = ConexionEstatica.getInforme(id);
            ConexionEstatica.cerrarBD();
            session.setAttribute("informe", i);
            session.setAttribute("mensaje", "Se ha actualizado el informe.");
        } else {
            session.setAttribute("mensaje", "Ha ocurrido algún error");
        }
        response.sendRedirect("../verInforme.jsp");
    }
%>