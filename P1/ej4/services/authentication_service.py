class AuthenticationService:
    def process(self, request):
        return {
            'success': True,
            'message': f"Autenticación exitosa para el usuario {request.get('email')}"
        }