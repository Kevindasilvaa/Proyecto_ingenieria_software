import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomPhoneField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final Color? backgroundColor; // Nuevo parámetro para el fondo
  final TextStyle? labelStyle; // Nuevo parámetro para personalizar el estilo del label
  final TextStyle? hintStyle; // Nuevo parámetro para personalizar el estilo del hint
  final Color? iconColor; // Nuevo parámetro para el color del ícono

  CustomPhoneField({
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.backgroundColor,
    this.labelStyle,
    this.hintStyle,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4.0,
      borderRadius: BorderRadius.circular(12.0), // Bordes redondeados
      color: backgroundColor ?? const Color.fromARGB(217, 217, 217, 217), // Fondo configurable
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Icon(Icons.phone,
                color: iconColor ?? Colors.black), // Color configurable para el ícono
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                controller: controller,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: labelText,
                  hintText: hintText,
                  labelStyle: labelStyle ??
                      const TextStyle(
                        color: Colors.black, // Color predeterminado del label
                        fontWeight: FontWeight.w500, // Peso predeterminado del label
                      ),
                  hintStyle: hintStyle ??
                      const TextStyle(
                        color: Colors.grey, // Color predeterminado del hint
                        fontSize: 14, // Tamaño del texto del hint
                      ),
                  border: InputBorder.none, // Quitamos el borde predeterminado
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Solo permite números
                  LengthLimitingTextInputFormatter(10), // Limita el número a 10 dígitos
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ejemplo: 4241305112'; // Mensaje predeterminado
                  }
                  if (value.length < 10) {
                    return 'El número debe tener al menos 10 dígitos'; // Mensaje de error
                  }
                  return null; // No hay errores
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
