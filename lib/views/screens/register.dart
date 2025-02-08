import 'package:flutter/material.dart';
import 'package:moni/controllers/user_controller.dart'; // Importa el controlador
import 'package:moni/models/clases/Usuario.dart'; // Importa la clase User
import 'package:moni/views/widgets/CustomButton.dart';
import 'package:moni/views/widgets/CustomTextField.dart';

class RegisterPage extends StatefulWidget { // Renombra la clase a RegisterPage
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> { // Renombra el estado
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final UserController _userController = UserController(); // Instancia del controlador
  bool _isPasswordVisible = false; // funciona para saber el estado del icono del input password

  Future<void> createAccount() async {
  if (_formKey.currentState!.validate()) {
    try {
      Usuario? newUser = await _userController.createUser(_emailController.text, _passwordController.text);

      if(newUser != null){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Cuenta creada exitosamente.")),);
        Navigator.pushReplacementNamed(context, '/home');
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error al crear la cuenta.")),);
      }
    } catch (e) {
      print("Error general al crear usuario: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error general al crear usuario: $e")),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Cuenta'), // Cambia el título
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
              CustomButton(
                onPressed: createAccount,
                text: 'CREAR CUENTA',
              ),
            ],
          ),
        ),
      ),
    );
  }
}