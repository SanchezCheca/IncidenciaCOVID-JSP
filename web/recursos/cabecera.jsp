<nav class="navbar navbar-expand navbar-light bg-white w-100 rounded-top">
    <a class = "navbar-brand" href = "index.jsp">
        <img src = "images/logo.png" width = "100" height = "auto" alt = "logo inCOVID">
    </a>
    <div class = "collapse navbar-collapse" id = "navbarNavDropdown">
        <ul class = "navbar-nav">
            <li class = "nav-item <?php
            if (substr($dir, -9) == 'index.php') {
                echo 'active';
            }
            ?>">
                <a class = "nav-link" href = "index.jsp">Informes de incidencia</a>
            </li>
        </ul>
        <div class = "dropdown ml-auto">
            <a class = "nav-link dropdown-toggle desplegable" href = "#" id = "navbarDropdownMenuLink" data-toggle = "dropdown" aria-haspopup = "true" aria-expanded = "false">
                Perfil
            </a>
            <div class = "dropdown-menu" aria-labelledby = "navbarDropdownMenuLink">
                <?php
                if (isset($usuarioIniciado)) {
                    //Ha iniciado sesión, se muestran otras opciones
                    ?>
                    <form name="menu" action="<?php echo $ruta . 'controladores/controladorPrincipal.php'; ?>" method="POST">
                        <?php
                        if ($usuarioIniciado->isAdmin()) {
                            ?>
                            <input type="submit" name="administrarUsuarios" class="dropdown-item" value="Administrar usuarios">
                            <input type="submit" name="administrarRegiones" class="dropdown-item" value="Administrar regiones">
                            <?php
                        }
                        ?>
                        <input type="submit" name="cerrarSesion" class="dropdown-item" value="Cerrar sesión">
                    </form>
                    <?php
                } else {
                    //No ha iniciado sesión, se muestran la opción de inicio y registro
                    ?>
                    <a class = "dropdown-item" href = "login.jsp">Iniciar sesión</a>
                    <a class = "dropdown-item" href = "registro.jsp">Crear cuenta</a>
                    <?php
                }
                ?>
            </div>
        </div>
    </div>
</nav>