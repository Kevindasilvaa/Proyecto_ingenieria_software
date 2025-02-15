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

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.2), // Fondo con transparencia
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            spreadRadius: 2,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 20,
                child: Icon(
                  Icons.add,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Agregar Cuenta',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.add, color: Colors.blue),
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
          ),
        ],
      ),
    );
  }
}
