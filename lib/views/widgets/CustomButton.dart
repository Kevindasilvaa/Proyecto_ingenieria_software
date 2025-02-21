import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final double width; // Ancho del botón

  CustomButton({required this.onPressed, required this.text, this.width = double.infinity});

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isHovered = false; // Estado para saber si el botón está siendo sobrevolado

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width, // Ancho del botón
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            _isHovered = true; // Cambia el estado cuando el mouse entra
          });
        },
        onExit: (_) {
          setState(() {
            _isHovered = false; // Cambia el estado cuando el mouse sale
          });
        },
        child: ElevatedButton(
          onPressed: widget.onPressed,
          child: Text(
            widget.text,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: _isHovered ? Colors.grey[500] : Colors.grey[600], // Cambio de color al estar sobre el botón
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 4,
            shadowColor: Colors.grey.withOpacity(0.3),
          ),
        ),
      ),
    );
  }
}