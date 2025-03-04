import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:moni/controllers/user_controller.dart';
import 'package:moni/models/clases/Usuario.dart';
import 'package:moni/views/widgets/CustomButton.dart';
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
    // Validación del número de teléfono
    if (_phoneController.text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: El número debe tener al menos 10 dígitos')));
    } else {
      // Solo se continúa si el número de teléfono es válido (más de 10 dígitos)
      final userController = Provider.of<UserController>(context, listen: false);
      final updatedUser = Usuario(
        id: userController.usuario!.id,
        email: userController.usuario!.email,
        name: _nameController.text,
        gender: _genderController.text,
        birthdate: DateTime.tryParse(_birthdateController.text) ?? DateTime.now(),
        country: _countryController.text,
        phone_number: _phoneController.text,
        monthlyIncomeBudget: double.tryParse(_incomeBudgetController.text),
        monthlyExpenseBudget: double.tryParse(_expenseBudgetController.text),
      );

      try {
        // Intentamos actualizar el perfil en la base de datos
        await userController.actualizarUsuarioEnFirestore(updatedUser);
        userController.usuario = updatedUser;
        // Si todo va bien, mostramos un mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Perfil actualizado')));
      } catch (e) {
        // Si ocurre un error, mostramos un mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al actualizar el perfil: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            CircleAvatar(
              radius: 50,
              child: Icon(Icons.person, size: 50),
            ),
            Center(
              child: Text(
                userController.usuario!.email,
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 12),
            Material(
              elevation: 4.0,
              borderRadius: BorderRadius.circular(10.0),
              color: const Color.fromARGB(217, 217, 217, 217),
              child: TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: 'Nombre',
                  labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16.0),
                ),
              ),
            ),
            SizedBox(height: 16),
            CustomDropdown(
              controller: _genderController,
              labelText: 'Género',
              icon: Icons.accessibility,
              items: ['Masculino', 'Femenino', 'Otro', 'No disponible'],
            ),
            SizedBox(height: 16),
            DatePickerField(
              controller: _birthdateController,
              labelText: 'Fecha de nacimiento',
              initialDate: userController.usuario?.birthdate,
              onChanged: (selectedDate) {},
            ),
            SizedBox(height: 16),
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
            ),
            SizedBox(height: 16),
            CustomPhoneField(
              controller: _phoneController,
              labelText: 'Número de teléfono',
              hintText: 'Ejemplo: 4241305112',
            ),
            SizedBox(height: 16),
            Material(
              elevation: 4.0,
              borderRadius: BorderRadius.circular(10.0),
              color: const Color.fromARGB(217, 217, 217, 217),
              child: TextFormField(
                controller: _incomeBudgetController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')), // Permitir solo números, punto y coma
                ],
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.arrow_upward),
                  labelText: 'Presupuesto de Ingreso Mensual',
                  labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16.0),
                ),
              ),
            ),
            SizedBox(height: 16),
            Material(
              elevation: 4.0,
              borderRadius: BorderRadius.circular(10.0),
              color: const Color.fromARGB(217, 217, 217, 217),
              child: TextFormField(
                controller: _expenseBudgetController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')), // Permitir solo números, punto y coma
                ],
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.arrow_downward),
                  labelText: 'Presupuesto de Gasto Mensual',
                  labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            CustomButton(
              onPressed: _updateProfile,
              text: 'Actualizar Perfil',
            ),
          ],
        ),
      ),
    );
  }
}