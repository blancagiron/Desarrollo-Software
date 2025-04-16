class AuthenticationService {
  Map<String, dynamic> process(Map<String, String> request){
    return {
      'success' : true,
      'message': 'Autenticación exitosa para el usuario ${request['email']}'
    };
  }
}