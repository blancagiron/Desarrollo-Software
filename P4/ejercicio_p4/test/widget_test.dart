// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:ejercicio_p4/model/envio.dart';
import 'package:ejercicio_p4/model/silla.dart';
import 'package:ejercicio_p4/model/sillaBuilder.dart';
import 'package:ejercicio_p4/model/fachada.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  group('Envio Tests', () {
    test('getCostoTotal con EnvioNormal', () {
      var silla1 = Silla(true, true, true, 150);
      var silla2 = Silla(true, false, true, 100);
      var sillas = [silla1, silla2];
      var envio = EnvioNormal('1', sillas, EstadoEnvio.pendiente, 'Dirección 123');

      expect(envio.getCostoTotal(), 150 + 100 + 10);  // Total = 150 + 100 + COSTE_ENVIO_NORMAL
    });

    test('getCostoTotal con EnvioExpress', () {
      var silla1 = Silla(true, true, true, 150);
      var silla2 = Silla(true, false, true, 100);
      var sillas = [silla1, silla2];
      var envio = EnvioExpress('1', sillas, EstadoEnvio.pendiente, 'Dirección 123');

      expect(envio.getCostoTotal(), 150 + 100 + 25);  // Total = 150 + 100 + COSTE_ENVIO_EXPRESS
    });

    test('realizarEnvio cambia el estado correctamente', () async {
      var silla1 = Silla(true, true, true, 150);
      var silla2 = Silla(true, false, true, 100);
      var sillas = [silla1, silla2];
      var envio = EnvioNormal('1', sillas, EstadoEnvio.pendiente, 'Dirección 123');

      envio.realizarEnvio();
      await Future.delayed(Duration(seconds: 20));
      expect(envio.getEstado(), EstadoEnvio.entregado);  // Debería estar entregado después de realizar el envío
    });
  });

  group('SillaBuilder Tests', () {
    test('SillaGamingBuilder crea una silla gaming correctamente', () {
      // Crear un builder para una silla gaming
      final builder = SillaGamingBuilder();

      builder.crearNuevaSilla();
      builder.setRespaldo();
      builder.setPrecio();
      builder.setAcolchada();
      builder.setRuedas();

      final silla = builder.getSilla();

      expect(silla.tipo, 'gaming');
      expect(silla.respaldo, true);
      expect(silla.ruedas, true);
      expect(silla.acolchada, true);
      expect(silla.precio, 299.99);
    });

    test('SillaOficinaBuilder crea una silla de oficina correctamente', () {
      // Crear un builder para una silla de oficina
      final builder = SillaOficinaBuilder();

      builder.crearNuevaSilla();
      builder.setRespaldo();
      builder.setPrecio();
      builder.setAcolchada();
      builder.setRuedas();

      final silla = builder.getSilla();

      expect(silla.tipo, 'oficina');
      expect(silla.respaldo, true);
      expect(silla.ruedas, true);
      expect(silla.acolchada, false);
      expect(silla.precio, 199.99);
    });

    test('SillaComedorBuilder crea una silla de comedor correctamente', () {
      final builder = SillaComedorBuilder();

      builder.crearNuevaSilla();
      builder.setRespaldo();
      builder.setPrecio();
      builder.setAcolchada();
      builder.setRuedas();

      final silla = builder.getSilla();

      expect(silla.tipo, 'comedor');
      expect(silla.respaldo, true);
      expect(silla.ruedas, false);
      expect(silla.acolchada, false);
      expect(silla.precio, 89.99);
    });

    test('SillaInfantilBuilder crea una silla infantil correctamente', () {
      final builder = SillaInfantilBuilder();

      // Construir la silla
      builder.crearNuevaSilla();
      builder.setRespaldo();
      builder.setPrecio();
      builder.setAcolchada();
      builder.setRuedas();

      final silla = builder.getSilla();

      expect(silla.tipo, 'infantil');
      expect(silla.respaldo, true);
      expect(silla.ruedas, false);
      expect(silla.acolchada, true);
      expect(silla.precio, 49.99);
    });
  });

  group('Fachada Tests', () {
    late Fachada fachada;

    setUp(() {
      fachada = Fachada();
    });

    test('crearEnvio agrega un envío correctamente', () async {
      // Crear sillas para el envío
      var silla1 = Silla(true, true, true, 150);
      var silla2 = Silla(true, false, true, 100);
      fachada.sillas = [silla1, silla2];

      fachada.crearEnvio('Dirección 123', 'normal');

      expect(fachada.envios.length, 1);
      expect(fachada.sillas.isEmpty, true);
      var envio = fachada.envios[0];
      expect(envio.direccion, 'Dirección 123');
      expect(envio.estado, EstadoEnvio.pendiente);

      final response = await http.get(Uri.parse('http://localhost:3000/envios'));
      expect(response.statusCode, 200);

      final List<dynamic> data = jsonDecode(response.body);
      expect(data.isNotEmpty, true);
      expect(data[0]['direccion'], 'Dirección 123');
    });

    test('getEnvios devuelve los envíos correctamente', () async {
      var silla1 = Silla(true, true, true, 150);
      var silla2 = Silla(true, false, true, 100);
      fachada.sillas = [silla1, silla2];

      fachada.crearEnvio('Dirección 123', 'normal');

      var envios = await fachada.getEnvios();
      expect(envios.length, 1);
      expect(envios[0].direccion, 'Dirección 123');

      final response = await http.get(Uri.parse('http://localhost:3000/envios'));
      expect(response.statusCode, 200);
      final List<dynamic> data = jsonDecode(response.body);
      expect(data.isNotEmpty, true);
      expect(data[0]['direccion'], 'Dirección 123');
    });

    test('eliminarHistorial elimina los envíos entregados', () async {
      var silla1 = Silla(true, true, true, 150);
      var silla2 = Silla(true, false, true, 100);
      fachada.sillas = [silla1, silla2];

      fachada.crearEnvio('Dirección 123', 'normal');
      var envio2 = EnvioNormal('2', [silla1], EstadoEnvio.entregado, 'Dirección 456');
      fachada.envios.add(envio2);

      fachada.eliminarHistorial();
      expect(fachada.envios.length, 1);
      expect(fachada.envios[0].estado, EstadoEnvio.pendiente);

      final response = await http.get(Uri.parse('http://localhost:3000/envios'));
      expect(response.statusCode, 200);
      final List<dynamic> data = jsonDecode(response.body);
      expect(data.length, 1);
      expect(data[0]['estado'], 'pendiente');
    });

    test('realizarEnvio cambia el estado del envío a en_transito y entregado', () async {
      var silla1 = Silla(true, true, true, 150);
      var silla2 = Silla(true, false, true, 100);
      fachada.sillas = [silla1, silla2];

      fachada.crearEnvio('Dirección 123', 'normal');
      var envio = fachada.envios[0];

      fachada.realizarEnvio(envio.id);
      expect(envio.getEstado(), EstadoEnvio.entregado);

      final response = await http.get(Uri.parse('http://localhost:3000/envios'));
      expect(response.statusCode, 200);
      final List<dynamic> data = jsonDecode(response.body);
      expect(data[0]['estado'], 'entregado');
    });

    test('getHistorial devuelve solo los envíos entregados', () async {
      var silla1 = Silla(true, true, true, 150);
      var silla2 = Silla(true, false, true, 100);
      fachada.sillas = [silla1, silla2];

      fachada.crearEnvio('Dirección 123', 'normal');
      var envio2 = EnvioNormal('2', [silla1], EstadoEnvio.entregado, 'Dirección 456');
      fachada.envios.add(envio2);

      var historial = await fachada.getHistorial();

      expect(historial.length, 1);
      expect(historial[0].estado, EstadoEnvio.entregado);

      final response = await http.get(Uri.parse('http://localhost:3000/envios'));
      expect(response.statusCode, 200);
      final List<dynamic> data = jsonDecode(response.body);
      expect(data.where((envio) => envio['estado'] == 'entregado').length, 1);
    });
  });
}
