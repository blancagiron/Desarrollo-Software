# Práctica 3

## Descripción General
Este proyecto implementa un sistema bancario básico desarrollado con Flutter/Dart. La aplicación permite registrar usuarios, crear cuentas bancarias, realizar operaciones (depósitos, retiros y transferencias) y mantener un registro de todas las transacciones realizadas.

### Objetivos

- Implementar un sistema siguiendo un diagrama de clases UML 
- Crear pruebas unitarias para validar el correcto funcionamiento 
- Aprender sobre pruebas de unidad y componentes en Flutter/Dart 
- Entender el funcionamiento de tests y grupos en Flutter/Dart

## Interfaz de Usuario

- LoginScreen: Pantalla de inicio de sesión para ingresar al sistema. 
- AccountsScreen: Muestra todas las cuentas del usuario. 
- AccountDetailScreen: Muestra detalles de una cuenta y su historial de transacciones.

## Funcionalidades

- Gestión de Usuarios: Registro e inicio de sesión de usuarios. 
- Gestión de Cuentas: Creación y visualización de cuentas bancarias.

## Pruebas Unitarias
El proyecto incluye un conjunto de pruebas unitarias organizadas en tres grupos:
### Grupo Account (3 tests)

- El balance inicial de una cuenta debe ser cero 
- No se permite depositar cantidades negativas o cero 
- No se permite retirar cantidades negativas o cero

### Grupo Transaction (3 tests)

- DepositTransaction.apply aumenta el saldo correctamente
- WithdrawalTransaction.apply lanza Exception cuando hay fondos insuficientes
- TransferTransaction.apply mueve fondos entre cuentas correctamente

### Grupo BankService (6 tests)

- La lista inicial de cuentas está vacía 
- deposit aumenta el saldo de la cuenta 
- withdrawal lanza Exception cuando el saldo es insuficiente 
- transfer mueve fondos correctamente 
- transfer lanza Exception cuando los fondos son insuficientes 
- createID genera identificadores únicos para las transacciones

## Cómo Ejecutar el Proyecto

1. Asegúrate de tener Flutter y Dart instalados en tu sistema. 
2. Clona este repositorio. 
3. Ejecuta flutter pub get para instalar las dependencias. 
4. Ejecuta flutter run para iniciar la aplicación.

## Cómo Ejecutar las Pruebas
Para ejecutar las pruebas unitarias, utiliza el siguiente comando:
```
flutter test
```

## Consideraciones y Limitaciones

- La aplicación gestiona los datos en memoria, por lo que se pierden al cerrar la aplicación.
- La seguridad se limita a la validación básica de operaciones.
- No se implementa autenticación real, solo se utiliza un nombre de usuario.

## Equipo de Desarrollo

- Karim Said Lupiañez 
- Pablo Tamayo López 
- Blanca Girón Ricoy


