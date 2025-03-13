package practica1;

/**
 *
 * @author Karim
 * @author Blanca
 * @author Pablo
 */
public class FactoriaCarretera implements FactoriaCarreraYBicicleta{

    @Override
    public Carrera crearCarrera(int numBicicletas) {
        return new CarreraCarretera(numBicicletas);
    }

    @Override
    public Bicicleta crearBicicleta(int id) {
        return new BicicletaCarretera(id);
    }
    
}
