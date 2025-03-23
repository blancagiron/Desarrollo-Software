from filters.email_filters import EmailFormatFilter, EmailDomainFilter
from filters.password_filters import (
    PasswordLengthFilter, 
    PasswordNumberFilter, 
    PasswordSpecialCharFilter
)
from filters.filter_manager import FilterManager
from services.authentication_service import AuthenticationService

def main():
    auth_service = AuthenticationService()
    filter_manager = FilterManager(auth_service)
    
    filter_manager.add_filter(EmailFormatFilter())
    filter_manager.add_filter(EmailDomainFilter())
    filter_manager.add_filter(PasswordLengthFilter())
    filter_manager.add_filter(PasswordNumberFilter())
    filter_manager.add_filter(PasswordSpecialCharFilter())
    
    print("=== Sistema de Autenticación ===")
    
    while True:
        email = input("Correo electrónico: ")
        password = input("Contraseña: ")
        
        request = {'email': email, 'password': password}
        result = filter_manager.process_request(request)
        
        if result['success']:
            print(f"\n✅ {result['message']}")
            break
        else:
            print("\n❌ La validación ha fallado:")
            for error in result['errors']:
                print(f"  - {error}")
            print("\nPor favor, inténtelo de nuevo.\n")

if __name__ == "__main__":
    main()