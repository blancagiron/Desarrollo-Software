from .base import Filter

class PasswordLengthFilter(Filter):
    def execute(self, request):
        password = request.get('password', '')
        if len(password) < 8:
            return "La contraseña debe tener al menos 8 caracteres"
        return None

class PasswordNumberFilter(Filter):
    def execute(self, request):
        password = request.get('password', '')
        if not any(char.isdigit() for char in password):
            return "La contraseña debe contener al menos un número"
        return None

class PasswordSpecialCharFilter(Filter):
    def execute(self, request):
        password = request.get('password', '')
        special_chars = "!@#$%^&*()_+-=[]{}|;:,.<>?/~`"
        if not any(char in special_chars for char in password):
            return "La contraseña debe contener al menos un carácter especial"
        return None