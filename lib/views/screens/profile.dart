import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:moni/controllers/user_controller.dart';
import 'package:moni/models/clases/Usuario.dart';
import 'package:moni/views/widgets/CustomButton.dart';
import 'package:moni/views/widgets/CustomDrawer.dart';
import 'package:moni/views/widgets/CustomDropdown.dart';
import 'package:moni/views/widgets/CustomTextField.dart';
import 'package:moni/views/widgets/CustomePhoneField.dart';
import 'package:moni/views/widgets/DatePickerField.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _incomeBudgetController = TextEditingController();
  final TextEditingController _expenseBudgetController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final userController = Provider.of<UserController>(context, listen: false);
    final user = userController.usuario;

    if (user != null) {
      _nameController.text = user.name ?? 'No disponible';
      _emailController.text = user.email ?? 'No disponible';
      _genderController.text = user.gender ?? 'No disponible';
      _birthdateController.text = user.birthdate != null
          ? DateFormat.yMd().format(user.birthdate!)
          : 'No disponible';
      _countryController.text = user.country ?? 'Dejar campo vacio';
      _phoneController.text = user.phone_number ?? 'No disponible';
      _incomeBudgetController.text = user.monthlyIncomeBudget?.toString() ?? '';
      _expenseBudgetController.text = user.monthlyExpenseBudget?.toString() ?? '';
    }
  }

  Future<void> _updateProfile() async {
    if (_phoneController.text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Error: El número debe tener al menos 10 dígitos')));
    } else {
      final userController = Provider.of<UserController>(context, listen: false);
      final updatedUser = Usuario(
        id: userController.usuario!.id,
        email: userController.usuario!.email,
        name: _nameController.text,
        gender: _genderController.text,
        birthdate:
            DateTime.tryParse(_birthdateController.text) ?? DateTime.now(),
        country: _countryController.text,
        phone_number: _phoneController.text,
        monthlyIncomeBudget: double.tryParse(_incomeBudgetController.text),
        monthlyExpenseBudget: double.tryParse(_expenseBudgetController.text),
      );

      try {
        await userController.actualizarUsuarioEnFirestore(updatedUser);
        userController.usuario = updatedUser;
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Perfil actualizado')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Error al actualizar el perfil')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E4A5A), // Fondo azul oscuro
        title: const Text(
          'Perfil',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white), // Texto blanco
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF5DA6A7), // Fondo verde del avatar
              child: Icon(Icons.person, size: 50, color: Colors.white), // Ícono blanco
            ),
            Center(
              child: Text(
                userController.usuario!.email,
                style: const TextStyle(fontSize: 16, color: Colors.black), // Texto blanco
              ),
            ),
            const SizedBox(height: 12),
            Material(
              elevation: 4.0,
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white, // Fondo blanco
              child: TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person, color: Colors.black), // Ícono negro
                  labelText: 'Nombre',
                  labelStyle: TextStyle(color: Colors.black), // Texto negro
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            CustomDropdown(
              controller: _genderController,
              labelText: 'Género',
              icon: Icons.accessibility,
              items: ['Masculino', 'Femenino', 'Otro', 'No disponible'],
              backgroundColor: Colors.white, // Fondo blanco
              labelStyle: const TextStyle(color: Colors.black), // Texto negro
            ),
            const SizedBox(height: 16),
            DatePickerField(
              controller: _birthdateController,
              labelText: 'Fecha de nacimiento',
              initialDate: userController.usuario?.birthdate,
              backgroundColor: Colors.white, // Fondo blanco
              labelStyle: const TextStyle(color: Colors.black), // Texto negro
              onChanged: (selectedDate) {},
            ),
            const SizedBox(height: 16),
            CustomDropdown(
              controller: _countryController,
              labelText: 'Nacionalidad',
              icon: Icons.flag,
              items: [
                'Dejar campo vacio',
                'Argentina',
                'Brasil',
                'Chile',
                'México',
                'Colombia',
                'Perú',
                'España',
                'Francia',
                'Estados Unidos',
                'Canadá',
                'Alemania',
                'Italia',
                'Reino Unido',
                'Australia',
                'India',
                'Japón',
                'Venezuela'
              ],
              backgroundColor: Colors.white, // Fondo blanco
              labelStyle: const TextStyle(color: Colors.black), // Texto negro
            ),
            const SizedBox(height: 16),
            CustomPhoneField(
              controller: _phoneController,
              labelText: 'Número de teléfono',
              hintText: 'Ejemplo: 4241305112',
              backgroundColor: Colors.white, // Fondo blanco
              labelStyle: const TextStyle(color: Colors.black), // Texto negro
            ),
            const SizedBox(height: 16),
            Material(
              elevation: 4.0,
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white, // Fondo blanco
              child: TextFormField(
                controller: _incomeBudgetController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')), // Permitir solo números
                ],
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.arrow_upward, color: Colors.black), // Ícono negro
                  labelText: 'Presupuesto de Ingreso Mensual',
                  labelStyle: TextStyle(color: Colors.black), // Texto negro
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Material(
              elevation: 4.0,
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white, // Fondo blanco
              child: TextFormField(
                controller: _expenseBudgetController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')), // Permitir solo números
                ],
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.arrow_downward, color: Colors.black), // Ícono negro
                  labelText: 'Presupuesto de Gasto Mensual',
                  labelStyle: TextStyle(color: Colors.black), // Texto negro
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              onPressed: _updateProfile,
              text: 'Actualizar Perfil',
              backgroundColor: const Color(0xFF5DA6A7), 
              textStyle: const TextStyle(color: Colors.white), // Texto blanco
            ),
          ],
        ),
      ),
    );
  }
}
