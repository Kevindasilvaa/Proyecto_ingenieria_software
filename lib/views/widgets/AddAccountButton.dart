import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moni/controllers/user_controller.dart'; // Asegúrate de importar el controlador

class AddAccountButton extends StatelessWidget {
  final VoidCallback onAdd;

  const AddAccountButton({
    required this.onAdd,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Accedemos al controlador UserController para obtener el email
    final userController = Provider.of<UserController>(context);
    final userEmail = userController.usuario?.email; // Aquí accedemos al email

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16), // Mismo padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor:
              const Color.fromARGB(255, 131, 132, 135), // Mismo color
        ),
        onPressed: () {
          if (userEmail?.isNotEmpty ?? false) {
            onAdd();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Inicia sesión para agregar cuentas'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        child: Text(
          'AGREGAR CUENTA',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
