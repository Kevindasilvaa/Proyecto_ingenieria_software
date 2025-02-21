import 'package:flutter/material.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GoogleSignInButton({required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white, // Fondo blanco
        foregroundColor: Colors.black, // Texto negro
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24), // Ajusta el padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Bordes redondeados
        ),
        elevation: 2, // Sombra suave
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/google_logo_2.png', // Ruta al logo de Google
            height: 32,
            width: 32,
          ),
          const SizedBox(width: 8), // Espacio entre el logo y el texto
          const Text(
            'Continua con Google',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}