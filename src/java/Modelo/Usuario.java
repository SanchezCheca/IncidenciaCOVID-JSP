package Modelo;

import java.util.ArrayList;

/**
 *
 * @author daniel
 */
public class Usuario {

    //--------------------ATRIBUTOS
    private int id;
    private String nombre;
    private String correo;
    private ArrayList rol;
    private int activo;

    //--------------------CONSTRUCTOR
    public Usuario(int id, String nombre, String correo, ArrayList rol, int activo) {
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
        return this.rol.contains(1);
    }
    
    /**
     * Devuelve true si contiene '0' entre sus roles
     * @return 
     */
    public boolean isAutor() {
        return this.rol.contains(0);
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

    public ArrayList getRol() {
        return rol;
    }

    public int getActivo() {
        return activo;
    }
    
}
