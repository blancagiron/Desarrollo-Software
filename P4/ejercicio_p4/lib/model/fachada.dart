import 'package:ejercicio_p4/model/envioFactory.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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

  void crearEnvio(String direccion, String tipo) async {
    List<Silla> lista_sillas = List.from(sillas);
    final envio = EnvioFactory.crearEnvio(tipo, _crearID(), lista_sillas, EstadoEnvio.pendiente, direccion);

    final response = await http.post(
      Uri.parse('http://localhost:3000/envios'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': envio.id,
        'tipo': tipo,
        'direccion': direccion,
        'estado': 'pendiente',
        'sillas': envio.sillasToJson(),
      }),
    );

    if (response.statusCode == 201) {
      envios.add(envio);
      sillas.clear();
    } else {
      throw Exception('Error al crear envío');
    }
  }

  Future<List<Envio>> getEnvios() async {
    final response = await http.get(Uri.parse(
        'http://localhost:3000/envios'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      envios = data.map<Envio>((envioJson) {
        List<Silla> sillas = (envioJson['sillas'] as List).map<Silla>((sillaJson) {
          final tipo = sillaJson['tipo'];
          final builder = _builderDesdeTipo(tipo);
          builder.crearNuevaSilla();
          builder.setRespaldo();
          builder.setPrecio();
          builder.setAcolchada();
          builder.setRuedas();
          Silla silla = builder.getSilla();
          return silla;
        }).toList();

        final estado = EstadoEnvio.values.firstWhere(
              (e) => e.name == envioJson['estado'],
          orElse: () => EstadoEnvio.pendiente,
        );

        final tipoEnvio = envioJson['tipo'];
        final id = envioJson['id'];
        final direccion = envioJson['direccion'];

        return EnvioFactory.crearEnvio(tipoEnvio, id, sillas, estado, direccion);
      }).toList();
      return envios;
    } else {
      throw Exception('Error al obtener envíos');
    }
  }

  void eliminarHistorial() async {
    List<Envio> historial = await getHistorial();

    for (Envio envio in historial) {
      final response = await http.delete(
        Uri.parse('http://localhost:3000/envios/${envio.id}'),
      );

      if (response.statusCode != 204) {
        throw Exception('Error al eliminar el envío con ID: ${envio.id}');
      }

      envios.removeWhere((e) => e.id == envio.id);
    }
  }

  Future<List<Envio>> getHistorial() async {
    await getEnvios();

    List<Envio> historial = envios.where((envio) {
      return envio.estado == EstadoEnvio.entregado;
    }).toList();

    return historial;
  }

  void realizarEnvio(String id) async {
    Envio envio = envios.firstWhere((envio) => envio.id == id);

    await http.patch(
      Uri.parse('http://localhost:3000/envios/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'estado': 'en_transito'}),
    );

    envio.realizarEnvio();

    await http.patch(
      Uri.parse('http://localhost:3000/envios/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'estado': 'entregado'}),
    );
  }

  String _crearID(){
    return "${CONTADOR_DE_ENVIOS++}";
  }

  SillaBuilder _builderDesdeTipo(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'gaming':
        return SillaGamingBuilder();
      case 'oficina':
        return SillaOficinaBuilder();
      case 'comedor':
        return SillaComedorBuilder();
      case 'infantil':
        return SillaInfantilBuilder();
      default:
        throw Exception('Tipo de silla desconocido: $tipo');
    }
  }
}