package practica1;

import java.util.Scanner;

/**
 *
 * @author Karim
 * @author Blanca
 * @author Pablo
 */
public class ej1 {

    public static void main(String[] args) {
        System.out.println("Elige el número de bicicletas inicial:");
        Scanner s = new Scanner(System.in);
        int bicis = s.nextInt();
        
        FactoriaCarretera fc = new FactoriaCarretera();
        FactoriaMontana fm = new FactoriaMontana();
        
        fc.crearCarrera(bicis).correr();
        fm.crearCarrera(bicis).correr();
    }
}
