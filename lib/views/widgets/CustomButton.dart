import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double width; // Ancho del botón

  CustomButton({required this.onPressed, required this.text, this.width = double.infinity});

  @override
  Widget build(BuildContext context) {
    return SizedBox( // Usamos SizedBox para controlar el ancho
      width: width, // Ancho del botón
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w700, // <-- Texto más grueso
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
          padding: EdgeInsets.symmetric(vertical: 16), // Padding vertical
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 4, // Elevación del botón
          shadowColor: Colors.grey.withOpacity(0.3), // Color de la sombra
        ),
      ),
    );
  }
}