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
        
        CarreraCarretera cc = (CarreraCarretera)(fc.crearCarrera());
        CarreraMontana cm = (CarreraMontana)(fm.crearCarrera());
        
        for(int i = 0; i < bicis; i++){
            cc.addBicicleta(fc.crearBicicleta(i));
            cm.addBicicleta(fm.crearBicicleta(i));
        }
        
        Thread t1 = new Thread(cc);
        Thread t2 = new Thread(cm);
        
        t1.start();
        t2.start();

        try {
            t1.join();
            t2.join();
        } catch (InterruptedException e) {
            System.out.println("Error en la ejecución de los hilos");
        }
    }
}
