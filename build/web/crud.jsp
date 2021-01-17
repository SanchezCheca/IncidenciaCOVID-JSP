<%@page import="java.util.ArrayList"%>
<%@page import="Modelo.Usuario"%>
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
                    <h4 class="h4">Panel de administrador: Usuarios</h4>
                </div>

                <!-- Cuerpo -->
                <div class="col-12 mt-4 px-4 d-flex justify-content-center">
                    <table class="table table-hover w-75" style="text-align: center">
                        <thead>
                            <tr>
                                <th scope="col">ID</th>
                                <th scope="col">Nombre</th>
                                <th scope="col">Correo</th>
                                <th scope="col">¿Admin?</th>
                                <th scope="col">¿Autor?</th>
                                <th scope="col">Activo</th>
                                <th colspan="2">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (session.getAttribute("usuarios") != null) {
                                    ArrayList usuarios = (ArrayList) session.getAttribute("usuarios");
                                    for (int i = 0; i < usuarios.size(); i++) {
                                        Usuario u = (Usuario) usuarios.get(i);
                            %>
                            <tr>
                        <form name="administracionUsuario" action="controladores/controladorCRUD.jsp" method="POST">
                            <th scope="row"><%=u.getId()%></th>
                            <input type="hidden" name="id" value="<%=u.getId()%>">
                            <td><input class="form-control" type="text" name="nombre" value="<%=u.getNombre()%>"></td>
                            <td><input class="form-control" type="email" name="correo" value="<%=u.getCorreo()%>"></td>
                            <td><input type="checkbox" name="admin" value="1" 
                                       <%
                                           if (u.isAdmin()) {
                                               out.print("checked");
                                           }
                                       %>></td>
                            <td><input type="checkbox" name="autor" value="1" 
                                       <%
                                           if (u.isAutor()) {
                                               out.print("checked");
                                           }
                                       %>></td>
                            <td><input type="checkbox" name="activo" value="1" 
                                       <%
                                           if (u.getActivo() == 1) {
                                               out.print("checked");
                                           }

                                       %>></td>
                            <td><input type="submit" class="btn btn-success" name="actualizarUsuario" value="Guardar"></td>
                            <td><input type="submit" class="btn btn-danger" name="eliminarUsuario" value="Eliminar"></td>
                        </form>
                        </tr>
                        <%                                }
                            }
                        %>
                        </tbody>
                    </table>
                </div>
                <jsp:include page="recursos/footer.jsp"/>
            </div>

        </div>
    </body>
</html>
