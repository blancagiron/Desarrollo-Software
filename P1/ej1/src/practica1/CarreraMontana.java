package practica1;

import java.util.ArrayList;
import java.util.Random;

/**
 *
 * @author Karim
 * @author Blanca
 * @author Pablo
 */
public class CarreraMontana extends Carrera {
    
    private double porcentajeRetirada = 0.2;

    public CarreraMontana(int numBicicletas) {
        super();
        FactoriaMontana factoria = new FactoriaMontana();
        
        for (int i = 0; i < numBicicletas; i++){
            addBicicleta(factoria.crearBicicleta(i));
        }
    }
    
    @Override
    public void correr() {
        System.out.println("Se inicia la carrera de montaña\n");
        retirarBicicletas();
        System.out.println("La carrera de montaña ha terminado\n");
    }
    
    private void retirarBicicletas(){
        Random rand = new Random();
        ArrayList<Bicicleta> bicicletas = getBicicletas();
        int num_descartar = (int) (bicicletas.size() * porcentajeRetirada);
        System.out.println("Se van a eliminar " + Integer.toString(num_descartar) + " bicicletas");
        
        while (num_descartar != 0){
           int siguiente = rand.nextInt(bicicletas.size());
           bicicletas.remove(siguiente);
           num_descartar--;
        } 
    }
    
}
