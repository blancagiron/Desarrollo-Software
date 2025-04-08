import '../servicio/api_hugginface.dart';
import '../estrategia_llm.dart';

class Flant5Strategy implements EstrategiaLLM {
  @override
  Future<String> mandarMensaje(String mensaje) {
    return getRespuestaDesdeModelo(mensaje, 'google/flan-t5-large');
  }

  @override
  String nombreModelo() => 'FLAN';
}
