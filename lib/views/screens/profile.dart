import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User _user;

  // Controladores para los campos de texto
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!; // Obtiene el usuario actual
    _nameController.text = _user.displayName ?? 'No disponible';
    _emailController.text = _user.email ?? 'No disponible';
  }

  // Función para actualizar el perfil del usuario
  Future<void> _updateProfile() async {
    try {
      await _user.updateProfile(displayName: _nameController.text);
      await _user.reload(); // Recarga el usuario después de la actualización
      setState(() {
        _user = _auth.currentUser!;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Perfil actualizado')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al actualizar el perfil')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Foto de perfil (si está disponible)
            _user.photoURL != null
                ? CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(_user.photoURL!),
                  )
                : CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.person, size: 50),
                  ),
            SizedBox(height: 20),
            // Nombre del usuario
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            SizedBox(height: 16),
            // Correo electrónico del usuario (solo visualización)
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Correo electrónico'),
              readOnly: true, // Solo lectura
            ),
            SizedBox(height: 32),
            // Botón para actualizar perfil
            ElevatedButton(
              onPressed: _updateProfile,
              child: Text('Actualizar Perfil'),
            ),
            SizedBox(height: 20),
            // Opción para cambiar la contraseña
            ListTile(
              leading: Icon(Icons.lock),
              title: Text('Cambiar contraseña'),
              onTap: () {
                //Navigator.pushNamed(context, '/changePassword');
              },
            ),
          ],
        ),
      ),
    );
  }
}
