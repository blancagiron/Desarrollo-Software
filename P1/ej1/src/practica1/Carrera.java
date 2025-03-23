package practica1;

import java.util.ArrayList;

/**
 *
 * @author Karim
 * @author Blanca
 * @author Pablo
 */
public abstract class Carrera implements Runnable{
    
    private ArrayList<Bicicleta> bicicletas;
    public static final int DURACION = 60;
    
    Carrera(){
        this.bicicletas = new ArrayList<>();
    }
    
    public void addBicicleta(Bicicleta bicicleta){
        bicicletas.add(bicicleta);
    }
    
    public ArrayList<Bicicleta> getBicicletas(){
        return bicicletas;
    }
    
    protected abstract void retirarBicicletas();
    
}
