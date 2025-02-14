import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomPhoneField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;

  CustomPhoneField({
    required this.controller,
    required this.labelText,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4.0,
      borderRadius: BorderRadius.circular(12.0),  // Hacemos el borde más redondeado
      color: const Color.fromARGB(217, 217, 217, 217), // Fondo gris claro
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Icon(Icons.phone, color: Colors.black), // Icono de teléfono
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
                  labelStyle: TextStyle(
                    color: Colors.black, // Color del texto del label
                    fontWeight: FontWeight.w500, // Peso de la fuente
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey, // Color del hintText
                    fontSize: 14, // Tamaño del hintText
                  ),
                  border: InputBorder.none, // Quitamos el borde predeterminado
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Solo permite números
                  LengthLimitingTextInputFormatter(10), // Limita el número a 10 dígitos
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ejemplo: 4241305112';
                  }
                  if (value.length < 10) {
                    return 'El número debe tener al menos 10 dígitos';
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
