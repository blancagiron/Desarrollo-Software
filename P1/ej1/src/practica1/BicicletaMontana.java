package practica1;

/**
 *
 * @author Karim
 * @author Blanca
 * @author Pablo
 */
public class BicicletaMontana extends Bicicleta {

    public BicicletaMontana(int id) {
        super(id);
    }
    
    @Override
    public String getTipo() {
        return this.tipo.toString();
    }
    
}
