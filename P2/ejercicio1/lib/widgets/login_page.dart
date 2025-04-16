import 'package:flutter/material.dart';

import 'input.dart';
import 'package:ejercicio1/filters/filter_manager.dart';
import 'package:ejercicio1/filters/email_filters.dart';
import 'package:ejercicio1/filters/password_filters.dart';
import 'package:ejercicio1/services/authetication_service.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FilterManager filterManager = FilterManager(AuthenticationService());

  LoginPage({super.key}) {
    filterManager.addFilter(EmailFormatFilter());
    filterManager.addFilter(EmailDomainFilter());
    filterManager.addFilter(PasswordLengthFilter());
    filterManager.addFilter(PasswordNumberFilter());
    filterManager.addFilter(PasswordSpecialCharFilter());
    filterManager.addFilter(PasswordUpperCaseFilter());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Input(
              labelText: 'Email',
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            Input(
              labelText: 'Password',
              controller: passwordController,
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final email = emailController.text;
                final password = passwordController.text;

                // Procesar email y contraseña a través de los filtros
                final request = {
                  'email' : email,
                  'password' : password
                };
                final result = filterManager.processRequest(request);

                showDialog(
                  context: context,
                  builder: (context) {
                  return AlertDialog(
                    title: const Text('Resultado de la validación'),
                    content: result['success'] == true
                      ? Text(result['message'] as String)
                      : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ...result['errors'].map((error) => Text(error)).toList(),
                        ],
                      ),
                    actions: [
                    TextButton(
                      onPressed: () {
                      Navigator.of(context).pop();
                      },
                      child: const Text('OK'),
                    ),
                    ],
                  );
                  },
                );

                
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
