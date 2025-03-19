import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moni/models/clases/cuenta.dart';
import 'package:moni/controllers/cuenta_controller.dart';
import 'package:moni/controllers/user_controller.dart';

class AddAccountPage extends StatefulWidget {
  @override
  _AddAccountPageState createState() => _AddAccountPageState();
}

class _AddAccountPageState extends State<AddAccountPage> {
  final _formKey = GlobalKey<FormState>();
  String _nombre = '';
  String _tipo = 'Ahorro';
  double _saldo = 0.0;
  String _tipoMoneda = 'USD';
  IconData? _selectedIcon; // Nuevo campo para el ícono seleccionado

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);
    final userEmail = userController.usuario?.email;

    if (userEmail == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Cuenta'),
        backgroundColor: Colors.grey[200],
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: _inputDecoration('Nombre de la cuenta'),
                onChanged: (value) => _nombre = value,
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese un nombre' : null,
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: _inputDecoration('Tipo de cuenta'),
                value: _tipo,
                onChanged: (value) => setState(() => _tipo = value!),
                items: ['Ahorro', 'Corriente', 'Inversión']
                    .map((tipo) =>
                        DropdownMenuItem(value: tipo, child: Text(tipo)))
                    .toList(),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: _inputDecoration('Tipo de moneda'),
                value: _tipoMoneda,
                onChanged: (value) => setState(() => _tipoMoneda = value!),
                items: ['BS', 'USD', 'EUR', 'MXN']
                    .map((moneda) =>
                        DropdownMenuItem(value: moneda, child: Text(moneda)))
                    .toList(),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: _inputDecoration('Saldo inicial'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  setState(() {
                    _saldo = double.tryParse(value) ?? 0.0;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Ingrese un saldo';
                  if (double.tryParse(value) == null)
                    return 'Ingrese un número válido';
                  return null;
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<IconData>(
                decoration: _inputDecoration('Seleccionar ícono'),
                value: _selectedIcon,
                onChanged: (value) => setState(() => _selectedIcon = value),
                items: [
                  DropdownMenuItem(
                    value: Icons.account_balance,
                    child: Row(
                      children: [
                        Icon(Icons.account_balance, color: Colors.blue),
                        SizedBox(width: 10),
                        Text('Banco'),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: Icons.wallet,
                    child: Row(
                      children: [
                        Icon(Icons.wallet, color: Colors.green),
                        SizedBox(width: 10),
                        Text('Billetera'),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: Icons.credit_card,
                    child: Row(
                      children: [
                        Icon(Icons.credit_card, color: Colors.purple),
                        SizedBox(width: 10),
                        Text('Tarjeta'),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: const Color.fromARGB(255, 131, 132, 135),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Cuenta nuevaCuenta = Cuenta(
                        nombre: _nombre,
                        tipo: _tipo,
                        saldo: _saldo,
                        fechaCreacion: DateTime.now(),
                        userEmail: userEmail,
                        tipoMoneda: _tipoMoneda,
                        icono: _selectedIcon, // Asignar el ícono seleccionado
                      );

                      await Provider.of<CuentaController>(context,
                              listen: false)
                          .agregarCuenta(nuevaCuenta);

                      Navigator.pop(context);
                    }
                  },
                  child: Text('GUARDAR',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
