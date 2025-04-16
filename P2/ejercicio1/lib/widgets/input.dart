import 'package:flutter/material.dart';

class Input extends StatelessWidget {
    final String labelText;
    final TextEditingController controller;
    final TextInputType keyboardType;
    final bool obscureText;

    const Input({
        super.key,
        required this.labelText,
        required this.controller,
        this.keyboardType = TextInputType.text,
        this.obscureText = false,
    });

    @override
    Widget build(BuildContext context) {
        return TextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            decoration: InputDecoration(
                labelText: labelText,
                border: OutlineInputBorder(),
            ),
        );
    }
}