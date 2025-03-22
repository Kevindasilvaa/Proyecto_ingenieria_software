import 'package:flutter/material.dart';
import 'package:moni/controllers/user_controller.dart';
import 'package:provider/provider.dart';
import 'package:moni/views/widgets/CustomButton.dart';
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
  bool _isPasswordVisible = false;

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
              duration: Duration(seconds: 1),
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
        SnackBar(
          content: Text('Se inicio sesion exitosamente'),
          duration: Duration(seconds: 1),
          ),
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
    body: Stack(
      children: [
        // Fondo superior con azul oscuro y título
        Container(
          height: MediaQuery.of(context).size.height * 0.20,
          decoration: BoxDecoration(
            color: const Color(0xFF2E4A5A), // Fondo azul oscuro
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: const Center(
            child: Text(
              'Iniciar Sesión',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Texto blanco
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.15,
            decoration: BoxDecoration(
              color: const Color(0xFF2E4A5A), // Fondo azul oscuro
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Al iniciar sesión con una cuenta, aceptas los Términos de Servicio y la Política de Privacidad de MONI.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70, // Texto blanco translúcido
                  ),
                ),
              ),
            ),
          ),
        ),
        // Contenido principal centrado
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white, // Fondo blanco para el formulario
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26, // Sombra suave
                    offset: const Offset(0, 4),
                    blurRadius: 10.0,
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomTextField(
                      controller: _emailController,
                      labelText: 'Email',
                      hintText: 'Ingresa tu email',
                      prefixIcon: Icons.email,
                      suffixIcon: Icons.close,
                      keyboardType: TextInputType.emailAddress,
                      onSuffixIconTap: () {
                        _emailController.clear();
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, ingresa tu email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _passwordController,
                      labelText: 'Contraseña',
                      hintText: 'Ingresa tu contraseña',
                      prefixIcon: Icons.lock,
                      suffixIcon: _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      keyboardType: TextInputType.text,
                      obscureText: !_isPasswordVisible,
                      onSuffixIconTap: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, ingresa tu contraseña';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: const Text(
                        '¿No tienes una cuenta? ¡Crea una!',
                        style: TextStyle(
                          color: Color(0xFF5DA6A7), // Texto verde
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    CustomButton(
                      onPressed: signIn,
                      text: 'INICIAR SESIÓN',
                      backgroundColor: const Color(0xFF5DA6A7), // Fondo verde
                      textStyle: const TextStyle(
                        color: Colors.white, // Texto blanco
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Colors.grey[400], // Línea gris
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'O',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Colors.grey[400], // Línea gris
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    GoogleSignInButton(
                      onPressed: () {
                        signInWithGoogle();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
}