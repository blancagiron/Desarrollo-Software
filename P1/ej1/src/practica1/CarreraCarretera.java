package practica1;

import java.util.ArrayList;
import java.util.Random;

/**
 *
 * @author Karim
 * @author Blanca
 * @author Pablo
 */
public class CarreraCarretera extends Carrera {
    
    private double porcentajeRetirada = 0.1;
    
    CarreraCarretera(int numBicicletas){
        super();
        FactoriaCarretera factoria = new FactoriaCarretera();
        
        for (int i = 0; i < numBicicletas; i++){
            addBicicleta(factoria.crearBicicleta(i));
        }
    }

    @Override
    public void correr() {
        System.out.println("Se inicia la carrera de carretera\n");
        retirarBicicletas();
        System.out.println("La carrera de carretera ha terminado\n");
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
