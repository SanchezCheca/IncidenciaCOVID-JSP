<%@page import="Modelo.Usuario"%>
<%@page import="Modelo.Informe"%>
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

        <div class="container-fluid d-flex justify-content-center">
            <div class="row principal rounded">
                <jsp:include page="recursos/cabecera.jsp"/>

                <%
                    //Comprueba si se está editando el informe
                    if (request.getParameter("editarInforme") != null) {
                %>
                <!-- Título de la sección -->
                <div class="col-12 mt-4 ml-4">
                    <h3 class="h3">Editar informe</h3>
                </div>
                <!-- Cuerpo -->
                <div class="col-12 mt-4 px-4 d-flex justify-content-center">
                    <table class="table table-hover" style="text-align: center">
                        <thead>
                            <tr>
                                <th scope="col">Semana</th>
                                <th scope="col">Región</th>
                                <th scope="col">Nº de infectados</th>
                                <th scope="col">Nº de fallecidos</th>
                                <th scope="col">Nº de altas</th>
                                <th colspan="2" scope="col"></th>
                            </tr>
                        </thead>
                        <tbody>
                        <form name="editarInforme" action="controladores/controladorInformes.jsp" method="POST">
                            <%
                                Informe informe;
                                if (session.getAttribute("informe") != null) {
                                    informe = (Informe) session.getAttribute("informe");
                            %>
                            <tr>
                                <td><%=informe.getSemana()%></td>
                                <td><%=informe.getRegion()%></td>
                                <td><input type="number" name="nInfectados" value="<%=informe.getnInfectados()%>"></td>
                                <td><input type="number" name="nFallecidos" value="<%=informe.getnFallecidos()%>"></td>
                                <td><input type="number" name="nAltas" value="<%=informe.getnAltas()%>"></td>
                            <input type="hidden" name="id" value="<%=informe.getId()%>">
                            <td><input type="submit" name="actualizarInforme" value="Guardar" class="btn btn-success"></td>
                        </form>
                        <td><a href="verInforme.jsp"><button class="btn btn-warning">Cancelar</button></a></td>
                        </tr>
                        <%
                            } else {
                                session.setAttribute("mensaje", "Ha ocurrido algún error");
                                response.sendRedirect("index.jsp");
                            }
                        %>
                        </tbody>
                    </table>
                </div>
                <%
                } else {
                %>
                <!-- Título de la sección -->
                <div class="col-12 mt-4 ml-4">
                    <h3 class="h3">Ver informe</h3>
                </div>

                <!-- Cuerpo -->
                <div class="col-12 mt-4 px-4 d-flex justify-content-center">
                    <table class="table table-hover w-75" style="text-align: center">
                        <thead>
                            <tr>
                                <th scope="col">Semana</th>
                                <th scope="col">Región</th>
                                <th scope="col">Nº de infectados</th>
                                <th scope="col">Nº de fallecidos</th>
                                <th scope="col">Nº de altas</th>
                                <th scope="col">Autor</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                Informe informe = null;
                                if (session.getAttribute("informe") != null) {
                                    informe = (Informe) session.getAttribute("informe");
                            %>
                            <tr>
                                <td><%=informe.getSemana()%></td>
                                <td><%=informe.getRegion()%></td>
                                <td><%=informe.getnInfectados()%></td>
                                <td><%=informe.getnFallecidos()%></td>
                                <td><%=informe.getnAltas()%></td>
                                <td><%=informe.getNombreAutor()%></td>
                            </tr>
                            <%
                                } else {
                                    session.setAttribute("mensaje", "Ha ocurrido algún error");
                                    response.sendRedirect("index.jsp");
                                }
                            %>

                        </tbody>
                    </table>
                </div>
                <%
                    if (session.getAttribute("usuarioIniciado") != null) {
                        Usuario u = (Usuario) session.getAttribute("usuarioIniciado");
                        if (u.isAutor()) {
                %>
                <div class="col-12 d-flex justify-content-center">
                    <form name="editar" action="verInforme.jsp" method="POST">
                        <input type="submit" class="btn btn-secondary" name="editarInforme" value="EDITAR">
                    </form>
                </div>
                <%
                            }
                        }

                    }
                %>

                <jsp:include page="recursos/footer.jsp"/>
            </div>
        </div>
    </body>
</html>
