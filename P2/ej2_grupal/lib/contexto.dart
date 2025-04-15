import 'estrategia_llm.dart';

// Contexto delega el trabajo a la estrategia activa
class Contexto{
   late EstrategiaLLM estrategia;
   Contexto(this.estrategia);

   void setStrategy(EstrategiaLLM e){
      estrategia = e;
   }

   Future<String> delegarTrabajo(String mensaje) { //Recibe mensaje-> pasa el mensaje a la estrategia que esté activa (llama a método mandarMensaje
      return estrategia.mandarMensaje(mensaje);  // devuelve la respuesta del modelo
   }
}