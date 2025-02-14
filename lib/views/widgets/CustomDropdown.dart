import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final TextEditingController controller; // Controller para el Dropdown
  final String labelText;
  final IconData icon;
  final List<String> items;
  final ValueChanged<String?>? onChanged; // onChanged es opcional

  CustomDropdown({
    required this.controller,
    required this.labelText,
    required this.icon,
    required this.items,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4.0,
      borderRadius: BorderRadius.circular(10.0),
      color: const Color.fromARGB(217, 217, 217, 217),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.black),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16.0),
          prefixIcon: Icon(icon),
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
            child: Text(value),
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