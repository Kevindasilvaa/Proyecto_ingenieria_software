import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool obscureText;
  final VoidCallback? onSuffixIconTap;

  CustomTextField({
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.obscureText = false,
    this.onSuffixIconTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding( // Padding aplicado al widget padre
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200],
        ),
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(
              color: Colors.grey,
            ),
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey,
            ),
            prefixIcon: prefixIcon != null ? Icon(
              prefixIcon,
              color: Colors.grey,
            ) : null, // Condicional para mostrar el icono
            suffixIcon: suffixIcon != null
                ? IconButton(
                    onPressed: onSuffixIconTap,
                    icon: Icon(
                      suffixIcon,
                      color: Colors.grey,
                    ),
                  )
                : null,
            border: InputBorder.none,
          ),
          validator: validator,
        ),
      ),
    );
  }
}