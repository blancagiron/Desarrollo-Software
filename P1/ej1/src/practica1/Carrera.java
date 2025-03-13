package practica1;

import java.util.ArrayList;

/**
 *
 * @author Karim
 * @author Blanca
 * @author Pablo
 */
public abstract class Carrera {
    
    private ArrayList<Bicicleta> bicicletas;
    private int duracion = 60;
    
    Carrera(){
        this.bicicletas = new ArrayList<>();
    }
    
    public void addBicicleta(Bicicleta bicicleta){
        bicicletas.add(bicicleta);
    }
    
    public ArrayList<Bicicleta> getBicicletas(){
        return bicicletas;
    }
    
    public abstract void correr();
    
}
