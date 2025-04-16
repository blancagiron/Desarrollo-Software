import 'base.dart';

class EmailFormatFilter extends Filter {
  @override
  String? execute(Map<String, String> request) {
    String email = request['email'] ?? '';
    if (email.indexOf('@') != email.lastIndexOf('@')) {
      return "El correo debe contener exactamente un carácter @";
    }
    String username = email.split('@')[0];
    if (username.isEmpty) {
      return "El correo debe contener texto antes del carácter @";
    }
    return null;
  }
}

class EmailDomainFilter extends Filter {
  @override
  String? execute(Map<String, String> request) {
    String email = request['email'] ?? '';
    String domain = email.split('@')[1].toLowerCase();

    final domainRegex = RegExp(r'^[a-z0-9.-]+\.[a-z]{2,10}$');

    if (domainRegex.hasMatch(domain)) {
      return "El dominio del correo debe tener un formato válido (ej: gmail.com, outlook.co.es, yahoo.es)";
    }
    return null;
  }
}
