package practica1;

/**
 *
 * @author Karim
 * @author Blanca
 * @author Pablo
 */
public class BicicletaCarretera extends Bicicleta {

    public BicicletaCarretera(int id) {
        super(id);
        this.tipo = Tipo.CARRETERA;
    }

    @Override
    public String getTipo() {
        return this.tipo.toString();
    }
        
}
