package Modelo;

/**
 *
 * @author daniel
 */
public class Informe {

    //--------------------ATRIBUTOS
    private int id;
    private String semana;
    private String region;
    private int nInfectados;
    private int nFallecidos;
    private int nAltas;
    private int idAutor;
    private String nombreAutor;

    //--------------------CONSTRUCTOR
    public Informe(int id, String semana, String region, int nInfectados, int nFallecidos, int nAltas, int idAutor) {
        this.id = id;
        this.semana = semana;
        this.region = region;
        this.nInfectados = nInfectados;
        this.nFallecidos = nFallecidos;
        this.nAltas = nAltas;
        this.idAutor = idAutor;
    }

    //--------------------SET
    public void setNombreAutor(String nombreAutor) {
        this.nombreAutor = nombreAutor;
    }

    //--------------------GET
    public int getId() {
        return id;
    }

    public String getSemana() {
        return semana;
    }

    public String getRegion() {
        return region;
    }

    public int getnInfectados() {
        return nInfectados;
    }

    public int getnFallecidos() {
        return nFallecidos;
    }

    public int getnAltas() {
        return nAltas;
    }

    public int getIdAutor() {
        return idAutor;
    }

    public Informe(String nombreAutor) {
        this.nombreAutor = nombreAutor;
    }

}
