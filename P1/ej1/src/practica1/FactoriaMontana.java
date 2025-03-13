package practica1;

/**
 *
 * @author Karim
 * @author Blanca
 * @author Pablo
 */
public class FactoriaMontana implements FactoriaCarreraYBicicleta{

    @Override
    public Carrera crearCarrera(int numBicicletas) {
        return new CarreraMontana(numBicicletas);
    }

    @Override
    public Bicicleta crearBicicleta(int id) {
        return new BicicletaMontana(id);
    }
    
}
