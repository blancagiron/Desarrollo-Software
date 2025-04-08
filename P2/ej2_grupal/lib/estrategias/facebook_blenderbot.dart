import '../servicio/api_hugginface.dart';
import '../estrategia_llm.dart';

class FacebookBlenderbotStrategy implements EstrategiaLLM {
  @override
  Future<String> mandarMensaje(String mensaje) {
    return getRespuestaDesdeModelo(mensaje, 'facebook/blenderbot-400M-distill');
  }

  @override
  String nombreModelo() => 'FBB';
}
