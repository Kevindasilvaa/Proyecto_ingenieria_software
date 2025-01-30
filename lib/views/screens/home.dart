import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        // El usuario ha cerrado sesión o no ha iniciado sesión
        Navigator.pushNamed(context, '/'); // Navega a la página de login
        print('User is currently signed out!');
      } else {
        // El usuario ha iniciado sesión
        print('User is signed in!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Aplicación'),
        // Botón en la esquina superior izquierda
        leading: PopupMenuButton<String>(
          icon: Icon(Icons.menu), // El ícono de menú
          onSelected: (String value) {
            if (value == 'logout') {
              _logout(); // Realiza logout
            } else {
              Navigator.pushNamed(context, value); // Navega a la ruta seleccionada
            }
          },
          itemBuilder: (BuildContext context) => [
            PopupMenuItem<String>(
              value: '/home', // La ruta a la que redirigir
              child: Row(
                children: [
                  Icon(Icons.home),
                  SizedBox(width: 10),
                  Text('Home'),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: '/profile', // La ruta a la que redirigir
              child: Row(
                children: [
                  Icon(Icons.person),
                  SizedBox(width: 10),
                  Text('Profile'),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: '/settings', // La ruta a la que redirigir
              child: Row(
                children: [
                  Icon(Icons.settings),
                  SizedBox(width: 10),
                  Text('Settings'),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'logout', // Este valor indica que es logout, no una ruta
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('¡Bienvenido a tu aplicación!'),
          ],
        ),
      ),
    );
  }

  // Función de logout
  Future<void> _logout() async {
    await _auth.signOut();
    Navigator.pushNamed(context, '/'); // Redirige a la página de login
  }
}
