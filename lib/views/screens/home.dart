import 'package:flutter/material.dart';
import 'package:moni/controllers/user_controller.dart';
import 'package:moni/models/clases/Usuario.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Aquí accedemos al UserController
    final userController = Provider.of<UserController>(context);
    // Esto escuchara cambios en el estado de autenticación de Firebase directamente desde el user_controller
    userController.startAuthListener(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Aplicación'),
        leading: PopupMenuButton<String>(
          icon: Icon(Icons.menu),
          onSelected: (String value) {
            if (value == 'logout') {
              _logout();
            } else {
              Navigator.pushNamed(context, value);
            }
          },
          itemBuilder: (BuildContext context) => [
            PopupMenuItem<String>(
              value: '/home',
              child: Row(
                children: [
                  Icon(Icons.home),
                  SizedBox(width: 10),
                  Text('Home'),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: '/profile',
              child: Row(
                children: [
                  Icon(Icons.person),
                  SizedBox(width: 10),
                  Text('Profile'),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: '/settings',
              child: Row(
                children: [
                  Icon(Icons.settings),
                  SizedBox(width: 10),
                  Text('Settings'),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Icons.logout),
                  SizedBox(width: 10),
                  Text('Logout'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: userController.usuario != null
            ? Text('¡Bienvenido, ${userController.usuario?.name}!')
            : CircularProgressIndicator(), // Mientras se obtiene el usuario, mostramos un indicador
      ),
    );
  }

  // Función para cerrar sesion llamando al metodo de user_controller
  Future<void> _logout() async {
    final userController = Provider.of<UserController>(context, listen: false);
    await userController.logOut();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cierre de sesión exitoso.'),),);
    Navigator.pushNamed(context, '/'); // Redirige a la página de login
  }

  // Método asíncrono para obtener el usuario
  Future<void> _getUserData(String email) async {
    // Accede al UserController usando Provider
    final userController = Provider.of<UserController>(context, listen: false);

    // Llamar al método del UserController para obtener el usuario
    Usuario? fetchedUser = await userController.getUserByEmail(email);

    // Si se encontró el usuario, actualizar el estado del user_controller
    if (fetchedUser != null) {
      userController.usuario = fetchedUser;
      print('Usuario encontrado: ${userController.usuario?.email} ${userController.usuario?.name}');
    } else {
      print('No se encontró el usuario.');
    }
  }
}
