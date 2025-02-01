import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:cloud_firestore/cloud_firestore.dart'; //PARTE DE UNA PRUEBA DEL FUNCIONAMIENTO DE FIRESTORE, PUEDE SERVIR COMO GUIA

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> signIn() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        // Navegar a la siguiente pantalla si el inicio de sesión es exitoso
        Navigator.pushReplacementNamed(context, '/home'); // Reemplaza '/home' con la ruta de tu pantalla principal
      } on FirebaseAuthException catch (e) {
        // Manejar errores de autenticación
        print(e.message);
        // Mostrar un mensaje de error al usuario
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al iniciar sesión: ${e.message}'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iniciar Sesión'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Correo electrónico'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingresa tu correo electrónico';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Contraseña'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingresa tu contraseña';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: signIn,
                child: Text('Iniciar Sesión'),
              ),
              //EL BOTON DE ABAJO ES PARTE DE UNA PRUEBA DEL FUNCIONAMIENTO DE FIRESTORE, PUEDE SERVIR COMO GUIA
              // ElevatedButton(
              //   onPressed: addUser,
              //   child: Text('Crear Usuario'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

//LA FUNCION DE ABAJO ES PARTE DE UNA PRUEBA DEL FUNCIONAMIENTO DE FIRESTORE, PUEDE SERVIR COMO GUIA
// Future<void> addUser() async {
//   // Obtén una referencia a la colección 'users'
//   CollectionReference users = FirebaseFirestore.instance.collection('users');

//   // Agrega un nuevo documento con un nombre y correo
//   await users.add({
//     'name': 'John Doe',  // Campo 'name'
//     'email': 'john.doe@example.com',  // Campo 'email'
//   }).then((value) => print("User Added"))
//     .catchError((error) => print("Failed to add user: $error"));
// }