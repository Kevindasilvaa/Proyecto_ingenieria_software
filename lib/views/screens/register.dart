import 'package:flutter/material.dart';
import 'package:moni/controllers/user_controller.dart';
import 'package:moni/models/clases/Usuario.dart';
import 'package:moni/views/widgets/CustomButton.dart';
import 'package:moni/views/widgets/CustomTextField.dart';
import 'package:moni/views/widgets/GoogleSignInButton.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final UserController _userController = UserController();
  bool _isPasswordVisible = false;

  Future<void> createAccount() async {
    if (_formKey.currentState!.validate()) {
      try {
        Usuario? newUser = await _userController.createUser(
            _emailController.text, _passwordController.text);

        if (newUser != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Cuenta creada exitosamente."),
              duration: Duration(seconds: 1),
              ),
          );
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error al crear la cuenta.")),
          );
        }
      } catch (e) {
        print("Error general al crear usuario: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error general al crear usuario: $e")),
        );
      }
    }
  }

  Future<void> createAccountWithGoogle() async {
    try {
      final userController = Provider.of<UserController>(context, listen: false);
      await userController.signInWithGoogle();

      if (userController.usuario != null) {
        Navigator.pushReplacementNamed(context, '/home');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Se inicio sesion exitosamente'),
            duration: Duration(seconds: 1),
            ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Ocurrio un error.")),
        );
      }
    } catch (e) {
      print('Error en signInWithGoogle en RegisterPage: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear cuenta con Google')),
      );
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        // Fondo superior con azul oscuro, título y flecha
        Container(
          height: MediaQuery.of(context).size.height * 0.20,
          decoration: BoxDecoration(
            color: const Color(0xFF2E4A5A), // Fondo azul oscuro
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Stack(
            children: [
              // Flecha en la parte superior izquierda
              Positioned(
                top: 30,
                left: 16,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white), // Flecha blanca
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/');
                  },
                ),
              ),
              // Título centrado
              const Center(
                child: Text(
                  'Crear Cuenta',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Texto blanco
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.15,
            decoration: const BoxDecoration(
              color: Color(0xFF2E4A5A), // Fondo azul oscuro
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Al crear una cuenta, aceptas los Términos de Servicio y la Política de Privacidad de MONI.',
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
                    const SizedBox(height: 20),
                    CustomButton(
                      onPressed: createAccount,
                      text: 'CREAR CUENTA',
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
                            color: Colors.grey[400], // Línea gris clara
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
                            color: Colors.grey[400], // Línea gris clara
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    GoogleSignInButton(
                      onPressed: createAccountWithGoogle,
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