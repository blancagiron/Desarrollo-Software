import 'silla.dart';

enum EstadoEnvio {
  pendiente,
  enTransito,
  entregado
}

abstract class Envio {
  String id;
  List<Silla> sillas;
  EstadoEnvio estado;
  String direccion;

  Envio(this.id, this.sillas, this.estado, this.direccion);

  void listarSillas();
  double getCostoTotal();
  void realizarEnvio();
  String getTipo();
  EstadoEnvio getEstado();

  Map<String, String> sillasToJson() {
    return sillas.asMap().map((index, silla) {
      return MapEntry(index.toString(), silla.toString());
    });
  }
}

class EnvioNormal extends Envio {
  static const int COSTE_ENVIO_NORMAL = 10;

  EnvioNormal(String id, List<Silla> sillas, EstadoEnvio estado, String direccion)
      : super(id, sillas, estado, direccion);

  @override
  void listarSillas() {
    print("Listando sillas para envío normal:");
    for (var silla in sillas) {
      print("- ${silla.toString()}");
    }
  }

  @override
  double getCostoTotal() {
    double costoSillas = sillas.fold(0, (sum, silla) => sum + silla.getPrecio());
    return costoSillas + COSTE_ENVIO_NORMAL;
  }

  @override
  void realizarEnvio() async {
    estado = EstadoEnvio.enTransito;
    print("Enviando por método normal a: $direccion");
    await Future.delayed(Duration(seconds: 20));
    estado = EstadoEnvio.entregado;
    print("El envío ha sido entregado");
  }

  @override
  String getTipo() => "Normal";

  @override
  EstadoEnvio getEstado() => estado;
}

class EnvioExpress extends Envio {
  static const int COSTE_ENVIO_EXPRESS = 25;

  EnvioExpress(String id, List<Silla> sillas, EstadoEnvio estado, String direccion)
      : super(id, sillas, estado, direccion);

  @override
  void listarSillas() {
    print("Listando sillas para envío express:");
    for (var silla in sillas) {
      print("- ${silla.toString()}");
    }
  }

  @override
  double getCostoTotal() {
    double costoSillas = sillas.fold(0, (sum, silla) => sum + silla.getPrecio());
    return costoSillas + COSTE_ENVIO_EXPRESS;
  }

  @override
  void realizarEnvio() async{
    estado = EstadoEnvio.enTransito;
    print("Enviando por método express a: $direccion");
    await Future.delayed(Duration(seconds: 10));
    estado = EstadoEnvio.entregado;
    print("El envío ha sido entregado");
  }

  @override
  String getTipo() => "Express";

  @override
  EstadoEnvio getEstado() => estado;
}