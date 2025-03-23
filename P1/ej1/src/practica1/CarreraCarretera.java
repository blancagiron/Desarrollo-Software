package practica1;

import java.util.ArrayList;
import java.util.Random;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Karim
 * @author Blanca
 * @author Pablo
 */
public class CarreraCarretera extends Carrera{
    
    private final double porcentajeRetirada = 0.1;
    
    @Override
    protected void retirarBicicletas(){
        Random rand = new Random();
        ArrayList<Bicicleta> bicicletas = getBicicletas();
        int num_descartar = (int) (bicicletas.size() * porcentajeRetirada);
        
        while (num_descartar != 0){
           int siguiente = rand.nextInt(bicicletas.size());
           bicicletas.remove(siguiente);
           num_descartar--;
        }
    }

    @Override
    public void run() {
        System.out.println("Se inicia la carrera de carretera\n");
        retirarBicicletas();
        try {
            Thread.sleep(DURACION*1000);
        } catch (InterruptedException ex) {
            System.out.println("Error mientras dura la carrera");
        }
        System.out.println("La carrera de carretera ha terminado con " + getBicicletas().size() + " bicicletas\n");
    }
    
}
