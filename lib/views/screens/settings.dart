import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Función para cerrar sesión
  Future<void> _logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushNamed(context, '/'); // Redirige a la página de login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuraciones'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Sección para opciones generales
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Editar perfil'),
              onTap: () {
                // Aquí puedes agregar la navegación a una pantalla de edición de perfil
                //Navigator.pushNamed(context, '/editProfile');
              },
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.security),
              title: Text('Cambiar contraseña'),
              onTap: () {
                // Aquí puedes agregar la navegación a una pantalla de cambio de contraseña
                //Navigator.pushNamed(context, '/changePassword');
              },
            ),
            Divider(),

            // Sección para preferencias de la aplicación
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notificaciones'),
              onTap: () {
                // Aquí puedes agregar la navegación a una pantalla de preferencias de notificación
                //Navigator.pushNamed(context, '/notificationPreferences');
              },
            ),
            Divider(),

            // Cerrar sesión
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Cerrar sesión'),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
    );
  }
}
