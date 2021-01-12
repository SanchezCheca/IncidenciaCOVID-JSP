package Modelo;

import Auxiliar.Constantes;
import java.sql.SQLException;
import java.util.ArrayList;
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
                ArrayList roles = ConexionEstatica.getRoles(id);
                
                Usuario u = new Usuario(id, nombre, correo, roles, activo);
                usuarios.add(u);
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
                roles.add(Conj_Registros.getInt("idRol"));
            }
        } catch (SQLException ex) {
            System.out.println("Error: " + ex.getMessage());
        }
        return roles;
    }

}
