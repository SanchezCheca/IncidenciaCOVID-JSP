package Modelo;

/**
 *
 * @author daniel
 */
public class Usuario {

    //--------------------ATRIBUTOS
    private int id;
    private String nombre;
    private String correo;
    private int[] rol;
    private int activo;

    //--------------------CONSTRUCTOR
    public Usuario(int id, String nombre, String correo, int[] rol, int activo) {
        this.id = id;
        this.nombre = nombre;
        this.correo = correo;
        this.rol = rol;
        this.activo = activo;
    }

    //--------------------FUNCIONES
    /**
     * Devuelve true si contiene '1' entre sus roles
     */
    public boolean isAdmin() {
        boolean resultado = false;
        for (int i = 0; i < this.rol.length; i++) {
            if (this.rol[i] == 1) {
                resultado = true;
            }
        }
        return resultado;
    }
    
    /**
     * Devuelve true si contiene '0' entre sus roles
     * @return 
     */
    public boolean isAutor() {
        boolean resultado = false;
        for (int i = 0; i < this.rol.length; i++) {
            if (this.rol[i] == 0) {
                resultado = true;
            }
        }
        return resultado;
    }

    //--------------------GET

    public int getId() {
        return id;
    }

    public String getNombre() {
        return nombre;
    }

    public String getCorreo() {
        return correo;
    }

    public int[] getRol() {
        return rol;
    }

    public int getActivo() {
        return activo;
    }
    
}
