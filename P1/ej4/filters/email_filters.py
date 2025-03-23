from .base import Filter

class EmailFormatFilter(Filter):
    def execute(self, request):
        email = request.get('email', '')
        if '@' not in email:
            return "El correo debe contener el carácter @"
        username = email.split('@')[0]
        if not username:
            return "El correo debe contener texto antes del carácter @"
        return None

class EmailDomainFilter(Filter):
    def execute(self, request):
        email = request.get('email', '')
        if '@' not in email:
            return "El correo debe contener el carácter @"
        domain = email.split('@')[1].lower()
        allowed_domains = ['gmail.com', 'hotmail.com']
        if domain not in allowed_domains:
            return f"El dominio del correo debe ser uno de los siguientes: {', '.join(allowed_domains)}"
        return None