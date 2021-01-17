<%@page import="Modelo.Region"%>
<%@page import="Modelo.Informe"%>
<%@page import="Modelo.ConexionEstatica"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Date"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
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
        <div  class="containter d-flex justify-content-center">
            <div class="row principal rounded">
                <jsp:include page="recursos/cabecera.jsp"/>
                <%
                    ConexionEstatica.nueva();
                    ArrayList informes = ConexionEstatica.getAllInformes();
                    ArrayList regiones = ConexionEstatica.getAllUniqueRegiones();
                    ArrayList semanas = ConexionEstatica.getAllSemanas();
                    ConexionEstatica.cerrarBD();

                    //Filtro
                    ArrayList informesFiltrados = new ArrayList();
                    String filtroRegion = null;
                    String filtroSemana = null;
                    if (request.getParameter("filtrar") != null) {
                        filtroRegion = request.getParameter("filtroRegion");
                        filtroSemana = request.getParameter("filtroSemana");

                        Informe informe;
                        for (int i = 0; i < informes.size(); i++) {
                            informe = (Informe) informes.get(i);
                            if ((informe.getSemana() == filtroSemana || filtroSemana == "TODAS") && (informe.getRegion() == filtroRegion || filtroRegion == "TODAS")) {
                                informesFiltrados.add(informe);
                            }
                        }
                        informes = informesFiltrados;
                    }

                    //Calcula los datos totales
                    int infectados = 0;
                    int fallecidos = 0;
                    int altas = 0;
                    Informe informe;
                    if (informes.size() > 0) {
                        for (int i = 0; i < informes.size(); i++) {
                            informe = (Informe) informes.get(i);
                            infectados += informe.getnInfectados();
                            fallecidos += informe.getnFallecidos();
                            altas += informe.getnAltas();
                        }
                    } else {
                %>
                <div class="col-12 d-flex justify-content-center">
                    <p class="text-danger mt-4">No hay informes que coincidan con tu búsqueda.</p>
                </div>
                <%
                    }
                %>

                <!-- Filtro -->
                <div class="col-2 mt-4 ml-4">
                    <h5 class="h5">Filtrar por:</h5>
                </div>
                <div class="col-8 mt-4">
                    <form name="filtro" action="index.jsp" method="POST">
                        <div class="form-group">
                            <label for="filtroRegion">Región: </label>
                            <select class="form-control" name="filtroRegion">
                                <option value="TODAS">TODAS</option>
                                <%
                                    Region region;
                                    for (int i = 0; i < regiones.size(); i++) {
                                        region = (Region) regiones.get(i);
                                %>
                                <option value="<%=region.getNombre()%>" <% if (filtroRegion != null && filtroRegion == region.getNombre()) {
                                        out.print("selected");
                                    }
                                        %>>
                                    <%
                                        out.print(region.getNombre());
                                    %>
                                </option>
                                <%
                                    }
                                %>
                            </select>
                            <label for="filtroSemana">Semana: </label>
                            <select class="form-control" name="filtroSemana">
                                <option value="TODAS">TODAS</option>
                                <%
                                    String semana;
                                    for (int i = 0; i < semanas.size(); i++) {
                                        semana = (String) semanas.get(i);
                                %>
                                <option value="<%=semana%>" 
                                        <%
                                            if (filtroSemana != null && filtroSemana == semana) {
                                                out.print("selected");
                                            }
                                        %>><%=semana%></option>
                                <%
                                    }
                                %>
                            </select>
                        </div>

                </div>
                <div class="col-1 mt-5">
                    <input class="btn btn-dark" type="submit" name="filtrar" value="Aplicar">
                    </form>
                </div>

                <!-- Primera seccion -->
                <div class="col-12 mt-4 ml-4">
                    <h4 class="h4">Datos totales</h4>
                </div>

                <div class="col-12 mt-4 px-4 d-flex justify-content-center">
                    <table class="table table-hover w-75">
                        <thead>
                            <tr>
                                <th scope="col">Infectados</th>
                                <th scope="col">Fallecidos</th>
                                <th scope="col">Altas</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><%=infectados%></td>
                                <td><%=fallecidos%></td>
                                <td><%=altas%></td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- Título de la sección -->
                <div class="col-12 mt-4 ml-4">
                    <h4 class="h4">Todos los informes</h4>
                </div>

                <!-- Cuerpo -->
                <div class="col-12 mt-4 px-4 d-flex justify-content-center">
                    <table class="table table-hover w-75">
                        <thead>
                            <tr>
                                <th scope="col">Semana</th>
                                <th scope="col">Región</th>
                                <th scope="col"></th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (informes.size() > 0) {
                                    for (int i = 0; i < informes.size(); i++) {
                                        informe = (Informe) informes.get(i);
                            %>
                            <tr>
                                <td><%=informe.getSemana()%></td>
                                <td><%=informe.getRegion()%></td>
                                <td>
                                    <form name="verInforme" action="controladores/controladorInformes.jsp" method="POST">
                                        <input type="hidden" name="id" value="<%=informe.getId()%>">
                                        <input type="submit" class="btn btn-primary" name="verInforme" value="Ver informe">
                                    </form>
                                </td>
                            </tr>
                            <%
                                    }
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
