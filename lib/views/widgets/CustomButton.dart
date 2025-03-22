import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final double width; // Ancho del botón
  final Color? backgroundColor; // Nuevo parámetro para el color de fondo
  final TextStyle? textStyle; // Nuevo parámetro para personalizar el estilo del texto
  final Color? hoverColor; // Nuevo parámetro para el color de fondo al estar sobrevolado

  CustomButton({
    required this.onPressed,
    required this.text,
    this.width = double.infinity,
    this.backgroundColor,
    this.textStyle,
    this.hoverColor,
  });

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
            style: widget.textStyle ??
                const TextStyle(
                  color: Colors.black, // Texto predeterminado negro
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: _isHovered
                ? widget.hoverColor ?? Colors.grey[500] // Fondo configurado al estar sobrevolado
                : widget.backgroundColor ?? Colors.grey[600], // Fondo predeterminado
            padding: const EdgeInsets.symmetric(vertical: 16),
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
