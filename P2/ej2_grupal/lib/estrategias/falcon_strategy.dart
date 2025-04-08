import '../servicio/api_hugginface.dart';
import '../estrategia_llm.dart';

class Falcon7bStrategy implements EstrategiaLLM {
  @override
  Future<String> mandarMensaje(String mensaje) {
    return getRespuestaDesdeModelo(mensaje, 'tiiuae/falcon-7b-instruct');
  }

  @override
  String nombreModelo() => 'Falcon';
}