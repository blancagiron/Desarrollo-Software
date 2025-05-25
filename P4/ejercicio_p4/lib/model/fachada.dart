import 'package:ejercicio_p4/model/envioFactory.dart';

import 'silla.dart';
import 'sillaBuilder.dart';
import 'envio.dart';

class Fachada {
  List<Silla> sillas = [];
  List<Envio> envios = [];
  SillaBuilder? builder;
  static int CONTADOR_DE_ENVIOS = 0;

  void setBuilder(SillaBuilder sillaBuilder) {
    builder = sillaBuilder;
  }

  void buildSilla() {
    if (builder != null) {
      builder!.crearNuevaSilla();
      builder!.setRespaldo();
      builder!.setPrecio();
      builder!.setAcolchada();
      builder!.setRuedas();
    }
  }

  Silla? getSilla() {
    if (builder is SillaGamingBuilder) {
      return (builder as SillaGamingBuilder).getSilla();
    } else if (builder is SillaOficinaBuilder) {
      return (builder as SillaOficinaBuilder).getSilla();
    } else if (builder is SillaComedorBuilder) {
      return (builder as SillaComedorBuilder).getSilla();
    } else if (builder is SillaInfantilBuilder) {
      return (builder as SillaInfantilBuilder).getSilla();
    }
    return null;
  }

  void crearEnvio(String direccion, String tipo) {
    Envio envio = EnvioFactory.crearEnvio(tipo, _crearID(), sillas, EstadoEnvio.pendiente, direccion);
    // operacion a la API
    envios.add(envio);
    sillas.clear();
  }

  void getEnvios(){
    // operacion a la API
  }

  void eliminarHistorial() {
    // operación a la API
  }

  List<Envio> getHistorial() {
    // operación a la API
    return <Envio>[];
  }

  void realizarEnvio(String id) {
    // cambiar estado en API
    Envio envio = envios.firstWhere((envio) => envio.id == id);
    envio.realizarEnvio();
    // cambiar estado en API
  }

  String _crearID(){
    return "Envio_${CONTADOR_DE_ENVIOS++}";
  }
}