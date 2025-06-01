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

  Future<void> crearEnvio(String direccion, String tipo) async {
    List<Silla> lista_sillas = List.from(sillas);
    final envio = EnvioFactory.crearEnvio(tipo, _crearID(), lista_sillas, EstadoEnvio.pendiente, direccion);

    final response = await http.post(
      Uri.parse('http://localhost:3000/envios'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'envio': {
          'id': int.parse(id),
          'tipo': tipo,
          'direccion': direccion,
          'estado': 'pendiente',
          'sillas': envio.sillasToJson()
        }
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
    final response = await http.get(Uri.parse('http://localhost:3000/envios'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      envios = data.map<Envio>((envioJson) {

        // Procesar sillas - Rails envía un objeto, no una lista
        List<Silla> sillas = [];
        if (envioJson['sillas'] != null) {
          final sillasData = envioJson['sillas'] as Map<String, dynamic>;
          sillas = sillasData.entries.map<Silla>((entry) {
            if (entry.value == "" || entry.value == null) {
              return Silla(true, true, true, 100);
            }

            final sillaJson = entry.value;
            final tipo = sillaJson['tipo'] ?? 'basica';
            final builder = _builderDesdeTipo(tipo);
            builder.crearNuevaSilla();
            builder.setRespaldo();
            builder.setPrecio();
            builder.setAcolchada();
            builder.setRuedas();
            return builder.getSilla();
          }).toList();
        }

        // Procesar estado - Rails envía strings ("pendiente", "en_transito", "entregado")
        final estadoString = envioJson['estado'] as String;
        EstadoEnvio estado;
        switch (estadoString) {
          case 'pendiente':
            estado = EstadoEnvio.pendiente;
            break;
          case 'en_transito':
            estado = EstadoEnvio.enTransito; // Ajusta según tu enum
            break;
          case 'entregado':
            estado = EstadoEnvio.entregado;
            break;
          default:
            estado = EstadoEnvio.pendiente;
        }

        // Procesar tipo - Rails envía strings ("normal", "express")
        final tipoEnvio = envioJson['tipo'] as String;
        final id = envioJson['id'].toString();
        final direccion = envioJson['direccion'];

        return EnvioFactory.crearEnvio(tipoEnvio, id, sillas, estado, direccion);
      }).toList();

      return envios;
    } else {
      throw Exception('Error al obtener envíos: ${response.statusCode}');
    }
  }

  Future<void> eliminarHistorial() async {
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

  Future<void> realizarEnvio(String id) async {
    Envio envio = envios.firstWhere((envio) => envio.id == id);

    await http.patch(
      Uri.parse('http://localhost:3000/envios/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'estado': 'en_transito'}),
    );

    await envio.realizarEnvio();

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
