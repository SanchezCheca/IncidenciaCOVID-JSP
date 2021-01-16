package Modelo;

import Auxiliar.Constantes;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JOptionPane;

/**
 *
 * @author daniel
 */
public class ConexionEstatica {

    //********************* Atributos *************************
    private static java.sql.Connection Conex;
    //Atributo a través del cual hacemos la conexión física.
    private static java.sql.Statement Sentencia_SQL;
    //Atributo que nos permite ejecutar una sentencia SQL
    private static java.sql.ResultSet Conj_Registros;

    /**
     * Crea la conexión
     */
    public static void nueva() {
        try {
            //Cargar el driver/controlador
            String controlador = "com.mysql.jdbc.Driver";
            Class.forName(controlador);

            String URL_BD = "jdbc:mysql://localhost/" + Constantes.BBDD;

            //Realizamos la conexión a una BD con un usuario y una clave.
            Conex = java.sql.DriverManager.getConnection(URL_BD, Constantes.usuario, Constantes.password);
            Sentencia_SQL = Conex.createStatement();
            System.out.println("Conexion realizada con éxito");

        } catch (Exception e) {
            System.err.println("Exception: " + e.getMessage());
        }
    }

    /**
     * Cierra la conexión
     */
    public static void cerrarBD() {
        try {
            Conex.close();
            System.out.println("Desconectado de la Base de Datos"); // Opcional para seguridad
        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(null, ex.getMessage(), "Error de Desconexion", JOptionPane.ERROR_MESSAGE);
        }
    }

    /**
     * Devuelve true si existe el usuario
     *
     * @param correo
     * @return
     */
    public static boolean existeUsuario(String correo) {
        boolean existe = false;
        try {
            String sentencia = "SELECT * FROM usuarios WHERE correo = '" + correo + "'";
            ConexionEstatica.Conj_Registros = ConexionEstatica.Sentencia_SQL.executeQuery(sentencia);
            if (ConexionEstatica.Conj_Registros.next())//Si devuelve true es que existe.
            {
                existe = true;
            }
        } catch (SQLException ex) {
            System.out.println("Error en el acceso a la BD.");
        }
        return existe;
    }

    /**
     * Devuelve un usuario si existe y la combinación correo-pass es correcta
     *
     * @param correo
     * @param pass
     * @return
     */
    public static Usuario getUsuario(String correo, String pass) {
        Usuario existe = null;
        try {
            String sentencia = "SELECT * FROM usuarios WHERE correo = '" + correo + "' AND pass='" + pass + "'";
            ConexionEstatica.Conj_Registros = ConexionEstatica.Sentencia_SQL.executeQuery(sentencia);
            if (ConexionEstatica.Conj_Registros.next())//Si devuelve true es que existe.
            {
                int id = Conj_Registros.getInt("id");
                String nombre = Conj_Registros.getString("nombre");
                int activo = Conj_Registros.getInt("activo");

                //Recupera los roles
                String sentenciaRoles = "SELECT idRol FROM usuario_rol WHERE idUsuario =" + id;
                ConexionEstatica.Conj_Registros = ConexionEstatica.Sentencia_SQL.executeQuery(sentenciaRoles);
                ArrayList roles = new ArrayList();
                while (ConexionEstatica.Conj_Registros.next()) {
                    roles.add(ConexionEstatica.Conj_Registros.getInt("idRol"));
                }

                existe = new Usuario(id, nombre, correo, roles, activo);
            }
        } catch (SQLException ex) {
            System.out.println("Error en el acceso a la BD.");
        }
        return existe;//Si devolvemos null el usuario no existe.
    }

    /**
     * Inserta un nuevo registro en la tabla usuarios
     */
    public static void insertUser(String nombre, String correo, String pass) throws SQLException {
        String sentencia = "INSERT INTO usuarios VALUES(id, '" + nombre + "', '" + correo + "', '" + pass + "', 0)";
        ConexionEstatica.Sentencia_SQL.executeUpdate(sentencia);
    }

    /**
     * Devuelve un ArrayList con todos los usuarios de la BD
     */
    public static ArrayList getAllUsers() {
        ArrayList usuarios = new ArrayList();
        try {
            String sentencia = "SELECT * FROM usuarios";
            ConexionEstatica.Conj_Registros = ConexionEstatica.Sentencia_SQL.executeQuery(sentencia);
            while (ConexionEstatica.Conj_Registros.next()) {
                int id = Conj_Registros.getInt("id");
                String nombre = Conj_Registros.getString("nombre");
                String correo = Conj_Registros.getString("correo");
                int activo = Conj_Registros.getInt("activo");
                ArrayList roles = new ArrayList();

                Usuario u = new Usuario(id, nombre, correo, roles, activo);
                usuarios.add(u);
            }

            //Carga los roles de los usuarios
            for (int i = 0; i < usuarios.size(); i++) {
                ArrayList roles = new ArrayList();
                Usuario u = (Usuario) usuarios.get(i);
                roles = ConexionEstatica.getRoles(u.getId());
                u.setRol(roles);
                usuarios.set(i, u);
            }
        } catch (SQLException ex) {
            System.out.println("Error: " + ex.getMessage());
        }
        return usuarios;
    }

    /**
     * Devuelve un ArrayList con los roles del usuario definido por su id
     *
     * @param id
     * @return
     */
    public static ArrayList getRoles(int id) {
        ArrayList roles = new ArrayList();
        try {
            String sentencia = "SELECT idRol FROM usuario_rol WHERE idUsuario=" + id;
            ConexionEstatica.Conj_Registros = ConexionEstatica.Sentencia_SQL.executeQuery(sentencia);
            while (ConexionEstatica.Conj_Registros.next()) {
                int rol = Conj_Registros.getInt("idRol");
                roles.add(rol);
            }
        } catch (SQLException ex) {
            System.out.println("Error: " + ex.getMessage());
        }
        return roles;
    }

    /**
     * Devuelve el correo de un usuario definido por su id
     *
     * @param id
     * @return
     */
    public static String getCorreoById(int id) {
        String correo = "";

        String sentencia = "SELECT correo FROM usuarios WHERE id=" + id;
        try {
            ConexionEstatica.Conj_Registros = ConexionEstatica.Sentencia_SQL.executeQuery(sentencia);
            if (ConexionEstatica.Conj_Registros.next()) {
                correo = Conj_Registros.getString("correo");
            }
        } catch (SQLException ex) {
            System.out.println("Error en bd (getCorreoById): " + ex.getMessage());
        }

        return correo;
    }

    /**
     * Elimina el rol de un usuario
     *
     * @param idUsuario
     * @param idRol
     */
    public static void removeRol(int idUsuario, int idRol) {
        String sentencia = "DELETE FROM usuario_rol WHERE idUsuario=" + idUsuario + " AND idRol=" + idRol;
        try {
            ConexionEstatica.Sentencia_SQL.executeUpdate(sentencia);
        } catch (SQLException ex) {
            System.out.println("Error en bd (removeRol): " + ex.getMessage());
        }
    }

    /**
     * Añade un nuevo rol a un usuario
     *
     * @param idUsuario
     * @param rol
     */
    public static void addRol(int idUsuario, int rol) {
        String sentencia = "INSERT INTO usuario_rol VALUES(" + idUsuario + ", " + rol + ")";
        try {
            ConexionEstatica.Sentencia_SQL.executeUpdate(sentencia);
        } catch (SQLException ex) {
            System.out.println("Error en bd (addRol): " + ex.getMessage());
        }
    }

    /**
     * Actualiza los datos de un usuario
     *
     * @param id
     * @param nombre
     * @param correo
     * @param activo
     */
    public static void updateUser(int id, String nombre, String correo, int activo) {
        String sentencia = "UPDATE usuarios SET nombre='" + nombre + "', correo='" + correo + "', activo=" + activo + " WHERE id=" + id;
        try {
            System.out.println("EJECUTANDO QUERY: " + sentencia);
            ConexionEstatica.Sentencia_SQL.executeUpdate(sentencia);
        } catch (SQLException ex) {
            System.out.println("Error en bd (updateUser): " + ex.getMessage());
        }
    }

    /**
     * Elimina un usuario de la BD
     *
     * @param id
     */
    public static void removeUser(int id) {
        try {
            String sentencia = "DELETE FROM usuarios WHERE id=" + id;
            ConexionEstatica.Sentencia_SQL.executeUpdate(sentencia);
        } catch (SQLException ex) {
            System.out.println("Error al eliminar: " + ex.getMessage());
        }
    }

    /**
     * Elimina todos los roles asignados a un usuario
     *
     * @param id
     */
    public static void removeAllRoles(int id) {
        try {
            String sentencia = "DELETE FROM usuario_rol WHERE idUsuario=" + id;
            ConexionEstatica.Sentencia_SQL.executeUpdate(sentencia);
        } catch (SQLException ex) {
            System.out.println("Error al eliminar: " + ex.getMessage());
        }
    }

    /**
     * Devuelve un ArrayList con todas las regiones de la BD
     *
     * @return
     */
    public static ArrayList getAllRegiones() {
        ArrayList regiones = new ArrayList();
        String sentencia = "SELECT * FROM regiones";
        try {
            ConexionEstatica.Conj_Registros = ConexionEstatica.Sentencia_SQL.executeQuery(sentencia);
            while (ConexionEstatica.Conj_Registros.next()) {
                int id = Conj_Registros.getInt("id");
                String nombre = Conj_Registros.getString("nombre");
                Region r = new Region(id, nombre);
                regiones.add(r);
            }
        } catch (SQLException ex) {
            System.out.println("Error al recoger: " + ex.getMessage());
        }
        return regiones;
    }

    /**
     * Elimina una region
     */
    public static void removeRegion(int id) {
        try {
            String sentencia = "DELETE FROM regiones WHERE id=" + id;
            ConexionEstatica.Sentencia_SQL.executeUpdate(sentencia);
            sentencia = "UPDATE informes SET region=0 WHERE region=" + id;
            ConexionEstatica.Sentencia_SQL.executeUpdate(sentencia);
        } catch (SQLException ex) {
            System.out.println("Error al eliminar: " + ex.getMessage());
        }
    }

    /**
     * Inserta una nueva region
     *
     * @param nombre
     */
    public static void addRegion(String nombre) {
        String sentencia = "INSERT INTO regiones VALUES(id, '" + nombre + "')";
        try {
            ConexionEstatica.Sentencia_SQL.executeUpdate(sentencia);
        } catch (SQLException ex) {
            System.out.println("Error: " + ex.getMessage());
        }
    }
    
    public static void actualizarRegion(int id, String nombre) {
        try {
            String sentencia = "UPDATE regiones SET nombre='" + nombre + "' WHERE id=" + id;
            ConexionEstatica.Sentencia_SQL.executeUpdate(sentencia);
        } catch (SQLException ex) {
            System.out.println("Error: " + ex.getMessage());
        }
    }

}
