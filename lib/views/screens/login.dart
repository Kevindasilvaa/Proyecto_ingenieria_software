import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:moni/controllers/user_controller.dart';
import 'package:moni/models/clases/Usuario.dart';
import 'package:moni/views/widgets/CustomButton.dart';
import 'package:provider/provider.dart';
import 'package:moni/views/widgets/CustomTextField.dart';
import 'package:moni/views/widgets/GoogleSignInButton.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false; // funciona para saber el estado del icono del input password

  Future<void> signIn() async {
    if (_formKey.currentState!.validate()) {
      // Accede al UserController usando Provider
        final userController = Provider.of<UserController>(context, listen: false);

        // Autenticación con Firebase directamente en el user_controller
        await userController.signIn(_emailController.text, _passwordController.text);

        if (userController.usuario != null) {
          // Navegar a la pantalla principal
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Inicio de sesión exitoso.'),
            ),
          );
          Navigator.pushReplacementNamed(context, '/home');
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No se pudo iniciar sesión. Por favor, revisa tus credenciales e intenta nuevamente.'),
              duration: Duration(seconds: 3),
            ),
          );
        }    
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final userController = Provider.of<UserController>(context, listen: false);
      await userController.signInWithGoogle();

      if (userController.usuario != null) {
        // Navegar a la siguiente pantalla
        Navigator.pushReplacementNamed(context, '/home');
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Se inicio sesion exitosamente')),
      );
      } else {
        // Mostrar mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Ocurrio un error.")),
        );
      }
    } catch (e) {
      print('Error en signInWithGoogle en LoginPage: $e');
      // Mostrar un mensaje de error genérico en la UI
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al iniciar sesión con Google')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Iniciar Sesión'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Input Email
              CustomTextField(
                controller: _emailController,
                labelText: 'Email',
                hintText: 'Ingresa tu email',
                prefixIcon: Icons.email,
                suffixIcon: Icons.close,
                keyboardType: TextInputType.emailAddress,
                onSuffixIconTap: () {
                  _emailController.clear(); // Limpia el contenido del email
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa tu email';
                  }
                  return null;
                },
              ),
              // Input Password
              CustomTextField(
                controller: _passwordController,
                labelText: 'Contraseña',
                hintText: 'Ingresa tu contraseña',
                prefixIcon: Icons.lock, // Ícono de candado para la contraseña
                suffixIcon: _isPasswordVisible ? Icons.visibility : Icons.visibility_off, // Alterna entre visibilidad y ocultación
                keyboardType: TextInputType.text,
                obscureText: !_isPasswordVisible, // Alterna la visibilidad de la contraseña
                onSuffixIconTap: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible; // Cambia el estado de visibilidad
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa tu contraseña';
                  }
                  return null;
                },
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register'); // Navega a la página de creación de cuenta
                },
                child: Text(
                  '¿No tienes una cuenta? ¡Crea una!',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
              CustomButton(
                onPressed: signIn,
                text: 'INICIAR SESIÓN',
              ),
              SizedBox(height: 20), // 20 píxeles de espacio vertical
              GoogleSignInButton(
                onPressed: () {
                  signInWithGoogle();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
