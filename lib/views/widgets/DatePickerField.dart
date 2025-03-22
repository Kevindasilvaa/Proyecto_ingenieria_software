import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final DateTime? initialDate;
  final TextStyle? labelStyle; // Personalización de texto del label
  final TextStyle? textStyle; // Personalización de texto de selección de fecha
  final Color? backgroundColor; // Personalización del fondo
  final ValueChanged<DateTime>? onChanged; // Callback al seleccionar una fecha

  DatePickerField({
    required this.controller,
    required this.labelText,
    this.initialDate,
    this.labelStyle,
    this.textStyle,
    this.backgroundColor,
    this.onChanged,
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
      _controller.text = 'No disponible'; // Texto predeterminado
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4.0, // Sombra para mejorar la estética
      borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
      color: widget.backgroundColor ?? Colors.white, // Fondo blanco
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 11.0), // Espaciado para el ícono
            child: Icon(Icons.calendar_today, color: widget.labelStyle?.color ?? Colors.black), // Ícono negro para contraste
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0), // Espaciado adecuado
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.labelText,
                    style: widget.labelStyle ?? const TextStyle(color: Colors.black, fontSize: 14), // Label en negro
                  ),
                  Text(
                    _controller.text.isEmpty || _controller.text == 'No disponible'
                        ? 'Seleccione Fecha'
                        : _controller.text,
                    style: widget.textStyle ?? const TextStyle(color: Colors.black, fontSize: 16), // Texto de fecha en negro
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
                  _controller.text = DateFormat('yyyy-MM-dd').format(picked);
                  if (widget.onChanged != null) {
                    widget.onChanged!(picked); // Callback
                  }
                });
              }
            },
            icon: const Icon(Icons.edit_calendar, color: Colors.black), // Ícono de edición negro
          ),
        ],
      ),
    );
  }
}
