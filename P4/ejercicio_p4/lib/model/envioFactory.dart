import 'envio.dart';
import 'silla.dart';

class EnvioFactory {
  static Envio crearEnvio(String tipo, String id, List<Silla> sillas,
      EstadoEnvio estado, String direccion) {
    switch (tipo.toLowerCase()) {
      case 'normal':
        return EnvioNormal(id, sillas, estado, direccion);
      case 'express':
        return EnvioExpress(id, sillas, estado, direccion);
      default:
        throw ArgumentError('Tipo de envío no válido: $tipo');
    }
  }
}