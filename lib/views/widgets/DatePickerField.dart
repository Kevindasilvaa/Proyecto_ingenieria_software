import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Este es un input de fecha que puede utilizarse en cualquier pagina
class DatePickerField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final DateTime? initialDate;

  DatePickerField({
    required this.controller,
    required this.labelText,
    this.initialDate, required Null Function(dynamic selectedDate) onChanged,
  });

  @override
  _DatePickerFieldState createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  late TextEditingController _controller;
  late DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _selectedDate = widget.initialDate;
    if (_selectedDate != null) {
      _controller.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    } else {
      _controller.text = 'No disponible';  // O cualquier texto predeterminado
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4.0,
      borderRadius: BorderRadius.circular(10.0),
      color: const Color.fromARGB(217, 217, 217, 217),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0), // Padding solo a la izquierda para el icono
            child: Icon(Icons.calendar_today), // Icono a la izquierda
          ),
          Expanded( // Para que el texto y el botón se distribuyan correctamente
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 16.0), // Padding para el texto
              child: Column( // Para el label y el texto en vertical
                crossAxisAlignment: CrossAxisAlignment.start, // Alinea el texto a la izquierda
                children: [
                  Text(
                    widget.labelText, // Label
                    style: TextStyle(
                      color: Colors.black, // Color del label
                    ),
                  ),
                  Text(
                    _controller.text.isEmpty || _controller.text == 'No disponible'
                        ? 'Select Date'
                        : _controller.text,
                    style: TextStyle(
                      color: Colors.black, // Color del texto
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (picked != null) {
                setState(() {
                  _selectedDate = picked;
                  // Actualizamos el controlador inmediatamente cuando el usuario selecciona la fecha
                  _controller.text = DateFormat('yyyy-MM-dd').format(picked);
                });
              }
            },
            icon: Icon(Icons.edit_calendar), 
          ),
        ],
      ),
    );
  }
}