import 'dart:convert';
import 'dart:math';
import '../constantes.dart';
import 'package:http/http.dart' as http;

// con Future -> función asíncrona que envía POST al endpoint del modelo en HF

Future<String> getRespuestaDesdeModelo(String mensaje, String modeloId) async {

  final Uri url = Uri.parse('https://api-inference.huggingface.co/models/$modeloId');

  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer $huggingFaceToken',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({'inputs': mensaje}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    // Si el modelo devuelve una lista con 'generated_text'
    if (data is List && data.isNotEmpty && data[0]['generated_text'] != null) {
      return data[0]['generated_text'];
    }

    // Si el modelo devuelve un solo objeto con 'generated_text'
    if (data is Map && data['generated_text'] != null) {
      return data['generated_text'];
    }

    return 'Respuesta recibida pero no reconocida: $data';
  } else {
    return 'Error: ${response.statusCode} - ${response.body}';
  }
}