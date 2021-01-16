<%@page import="java.util.ArrayList"%>
<%@page import="Modelo.Usuario"%>
<%@page import="Modelo.Region"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Administrar usuarios - inCOVID</title>

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

        <div class="container-fluid d-flex justify-content-center">
            <div class="row principal rounded">
                <jsp:include page="recursos/cabecera.jsp"/>
                <%
                    if (session.getAttribute("usuarioIniciado") != null) {
                        Usuario usuarioIniciado = (Usuario) session.getAttribute("usuarioIniciado");
                        if (!usuarioIniciado.isAdmin()) {
                            String mensaje = "ERROR: No tienes permiso para ver esta página.";
                            session.setAttribute("mensaje", mensaje);
                            response.sendRedirect("index.jsp");
                        }
                    } else {
                        String mensaje = "Ha ocurrido algún error.";
                        session.setAttribute("mensaje", mensaje);
                        response.sendRedirect("index.jsp");
                    }
                %>

                <!-- Título de la sección -->
                <div class="col-12 mt-4 ml-4">
                    <h4 class="h4">Crear región</h4>
                </div>

                <div class="col-12 mt-4 px-4 d-flex justify-content-center">
                    <form name="administracionRegion" action="controladores/controladorCRUD.jsp" method="POST">
                        <div class="form-inline w-100">
                            <input type="text" name="nombre" placeholder="Nombre de la región" class="form-control">
                            <input type="submit" name="crearRegion" value="Crear región" class="btn btn-success">
                        </div>

                    </form>
                </div>

                <!-- Título de la sección -->
                <div class="col-12 mt-4 ml-4">
                    <h4 class="h4">Todas las regiones</h4>
                </div>

                <!-- Cuerpo -->
                <div class="col-12 mt-4 px-4 d-flex justify-content-center">
                    <table class="table table-hover w-75" style="text-align: center">
                        <thead>
                            <tr>
                                <th scope="col">ID</th>
                                <th scope="col">Nombre</th>
                                <th colspan="2" scope="col">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (session.getAttribute("regiones") != null) {
                                    ArrayList regiones = (ArrayList) session.getAttribute("regiones");
                                    for (int i = 1; i < regiones.size(); i++) {
                                        Region r = (Region) regiones.get(i);
                            %>
<tr>
                        <form name="administracionRegion" action="controladores/controladorCRUD.jsp" method="POST">
                            <th scope="row"><%=r.getId()%></th>
                            <input type="hidden" name="id" value="<%=r.getId()%>">
                            <td><input class="form-control" type="text" name="nombre" value="<%=r.getNombre()%>"></td>

                            <td><input type="submit" class="btn btn-success" name="actualizarRegion" value="Guardar"></td>
                            <td><input type="submit" class="btn btn-danger" name="eliminarRegion" value="Eliminar"></td>
                        </form>
                        </tr>
                            <%
                                    }
                                } else {
                                    session.setAttribute("mensaje", "Ha ocurrido algún error");
                                    response.sendRedirect("index.jsp");
                                }
                            %>
                        </tbody>
                    </table>
                </div>
                
            </div>

        </div>
    </body>
</html>
