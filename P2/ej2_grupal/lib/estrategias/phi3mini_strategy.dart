import '../servicio/api_hugginface.dart';
import '../estrategia_llm.dart';

class Phi3miniStrategy implements EstrategiaLLM {
  @override
  Future<String> mandarMensaje(String mensaje) {
    return getRespuestaDesdeModelo(mensaje, 'microsoft/Phi-3-mini-4k-instruct');
  }

  @override
  String nombreModelo() => 'PHI3';
}
