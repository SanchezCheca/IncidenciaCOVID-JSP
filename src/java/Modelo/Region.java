package Modelo;

/**
 *
 * @author daniel
 */
public class Region {

    //--------------------ATRIBUTOS
    private int id;
    private String nombre;

    //--------------------CONSTRUCTOR
    public Region(int id, String nombre) {
        this.id = id;
        this.nombre = nombre;
    }

    //--------------------GET
    public int getId() {
        return id;
    }

    public String getNombre() {
        return nombre;
    }

}
