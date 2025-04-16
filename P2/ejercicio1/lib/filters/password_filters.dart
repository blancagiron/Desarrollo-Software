import 'base.dart';

class PasswordLengthFilter extends Filter {
  @override
  String? execute(Map<String, String> request) {
    String password = request['password'] ?? '';
    if (password.length < 8) {
      return "La contraseña debe tener al menos 8 caracteres";
    }
    return null;
  }
}

class PasswordNumberFilter extends Filter {
  @override
  String? execute(Map<String, String> request) {
    String password = request['password'] ?? '';
    if (!password.contains(RegExp(r'\d'))) {
      return "La contraseña debe contener al menos un número";
    }
    return null;
  }
}

class PasswordSpecialCharFilter extends Filter {
  @override
  String? execute(Map<String, String> request) {
    String password = request['password'] ?? '';
    String specialChars = "!@#\$%^&*()_+-=[]{}|;:,.<>?/~`";
    if (!password.contains(RegExp('[${RegExp.escape(specialChars)}]'))) {
      return "La contraseña debe contener al menos un carácter especial";
    }
    return null;
  }
}

class PasswordUpperCaseFilter extends Filter {
  @override
  String? execute(Map<String, String> request) {
    String password = request['password'] ?? '';
    if (!password.contains(RegExp(r'[A-Z]'))){
      return "La contraseña debe contener al menos una letra en mayúsculas";
    }
    return null;
  }
  
}