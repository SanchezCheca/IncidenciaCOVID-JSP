<%@page import="Modelo.Region"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Modelo.ConexionEstatica"%>
<%@page import="Modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Inicio - inCOVID</title>

        <!-- Bootstrap -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css"
              integrity="sha384-TX8t27EcRE3e/ihU7zmQxVncDAy5uIKz4rEkgIXeMed4M0jlfIDPvg6uqKI2xXr2" crossorigin="anonymous">
        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"
                integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj"
        crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.bundle.min.js"
                integrity="sha384-ho+j7jyWK8fNQe+A12Hb8AhRq26LrZ/JpcUGGOn+Y7RsweNrtN/tE3MoK7ZeZDyx"
        crossorigin="anonymous"></script>

        <!-- Estilos -->
        <link rel="stylesheet" href="estilos/misEstilos.css">

    </head>
    <body>
        <%String[] semanas = {"Jan 11 - Jan 17", "Jan 4 - Jan 10", "Dec 28 - Jan 3", "Dec 21 - Dec 27", "Dec 14 - Dec 20", "Dec 7 - Dec 13", "Nov 30 - Dec 6", "Nov 23 - Nov 29", "Nov 16 - Nov 22", "Nov 9 - Nov 15", "Nov 2 - Nov 8", "Oct 26 - Nov 1"};%>
        <div  class="containter d-flex justify-content-center">
            <div class="row principal rounded">
                <jsp:include page="recursos/cabecera.jsp"/>

                <%
                    if (session.getAttribute("usuarioIniciado") != null) {
                        Usuario u = (Usuario) session.getAttribute("usuarioIniciado");
                        if (!u.isAutor()) {
                            session.setAttribute("mensaje", "No tienes permiso para ver esta página");
                            response.sendRedirect("index.jsp");
                        }
                    } else {
                        session.setAttribute("mensaje", "Ha ocurrido algún error");
                        response.sendRedirect("index.jsp");
                    }
                %>

                <!-- Título de la sección -->
                <div class="col-12 mt-4 ml-4">
                    <h3 class="h3">Nuevo informe</h3>
                </div>

                <!-- Cuerpo -->
                <div class="col-12 mt-4 px-4 d-flex justify-content-center">
                    <form class="w-75" name="formularioNuevoInforme" action="controladores/controladorInformes.jsp" method="POST">
                        <div class="form-group">
                            <label for="semana">Semana</label>
                            <select class="form-control" name="semana">
                                <%
                                    for (int i = 0; i < semanas.length; i++) {
                                %>
                                <option value="<%=semanas[i]%>"><%=semanas[i]%></option>
                                <%
                                    }
                                %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="region">Región</label>
                            <select class="form-control" name="region">
                                <%
                                    //Recupera la lista de regiones de la bd
                                    ConexionEstatica.nueva();
                                    ArrayList regiones = ConexionEstatica.getAllRegiones();
                                    ConexionEstatica.cerrarBD();

                                    for (int i = 0; i < regiones.size(); i++) {
                                        Region r = (Region) regiones.get(i);
                                %>
                                <option value="<%=r.getId()%>"><%=r.getNombre()%></option>
                                <%
                                    }
                                %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="nInfectados">Nº de infectados</label>
                            <input class="form-control" name="nInfectados" type="number" required="">
                        </div>
                        <div class="form-group">
                            <label for="nFallecidos">Nº de fallecidos</label>
                            <input class="form-control" name="nFallecidos" type="number" required="">
                        </div>
                        <div class="form-group">
                            <label for="nAltas">Nº de altas</label>
                            <input class="form-control" name="nAltas" type="number" required="">
                        </div>
                        <input type="submit" name="crearInforme" value="Crear informe" class="btn btn-primary w-100">
                    </form>
                </div>
                <div class="col-12 d-flex justify-content-center mt-3">
                    <p><a href="index.jsp">Volver</a></p>
                </div>
                <jsp:include page="recursos/footer.jsp"/>
            </div>
        </div>

    </body>
</html>
