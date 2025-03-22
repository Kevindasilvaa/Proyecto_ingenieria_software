import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final TextEditingController controller; // Controller para el Dropdown
  final String labelText;
  final IconData icon;
  final List<String> items;
  final ValueChanged<String?>? onChanged; // onChanged es opcional
  final TextStyle? labelStyle; // Nuevo parámetro para personalizar el estilo de texto
  final Color? backgroundColor; // Nuevo parámetro para el color de fondo

  CustomDropdown({
    required this.controller,
    required this.labelText,
    required this.icon,
    required this.items,
    this.onChanged,
    this.labelStyle, // Inicializamos el estilo como opcional
    this.backgroundColor, // Inicializamos el color de fondo como opcional
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4.0,
      borderRadius: BorderRadius.circular(10.0),
      color: backgroundColor ?? Colors.white, // Fondo blanco aplicado por defecto
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: labelStyle ?? const TextStyle(color: Colors.black), // Aplicamos estilo de texto negro
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16.0),
          prefixIcon: Icon(icon, color: labelStyle?.color ?? Colors.black), // Ícono ajustado al estilo de texto
        ),
        value: controller.text.isNotEmpty ? controller.text : null, // Usamos el valor del controlador
        onChanged: (newValue) {
          controller.text = newValue ?? ''; // Actualizamos el controlador
          if (onChanged != null) {
            onChanged!(newValue); // Llamamos a la función onChanged si está definida
          }
        },
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: labelStyle ?? const TextStyle(color: Colors.black), // Aplicamos estilo de texto negro a las opciones
            ),
          );
        }).toList(),
        validator: (value) {
          if (value == null || value.isEmpty || value == 'No disponible') {
            return 'Seleccione una opción';
          }
          return null;
        },
      ),
    );
  }
}

