package Modelo;

import Auxiliar.Constantes;
import java.sql.SQLException;
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
     * Devuelve un objeto Usuario si existe, null si no
     *
     * @param correo
     * @return
     */
    public static Usuario existeUsuario(String correo) {
        Usuario existe = null;
        try {
            String sentencia = "SELECT * FROM usuarios WHERE correo = '" + correo + "'";
            ConexionEstatica.Conj_Registros = ConexionEstatica.Sentencia_SQL.executeQuery(sentencia);
            if (ConexionEstatica.Conj_Registros.next())//Si devuelve true es que existe.
            {
                int id = Conj_Registros.getInt("id");
                String nombre = Conj_Registros.getString("nombre");
                int activo = Conj_Registros.getInt("activo");
                String sexo = Conj_Registros.getString("sexo");
                int edad = Conj_Registros.getInt("edad");
                String foto_perfil = Conj_Registros.getString("foto_perfil");
                int rol = 1;
                existe = new Usuario(id, correo, nombre, activo, sexo, edad, foto_perfil, rol);
            }
        } catch (SQLException ex) {
            System.out.println("Error en el acceso a la BD.");
        }
        return existe;//Si devolvemos null el usuario no existe.
    }

}
