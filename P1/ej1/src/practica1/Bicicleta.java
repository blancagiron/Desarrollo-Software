package practica1;

/**
 *
 * @author Karim
 * @author Blanca
 * @author Pablo
 */
public abstract class Bicicleta {
    
    private int id;
    
    Bicicleta(int id){
        this.id = id;
    }
      
    public int getId(){
        return this.id;
    }
    
    public String ride() {
        return "Bicicleta " + Integer.toString(this.id) + " en carrera";
    }
    
}
