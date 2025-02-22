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
  String _tipoMoneda = 'USD'; // Puedes ajustar las opciones de moneda

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);
    final userEmail = userController.usuario?.email;

    if (userEmail == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Agregar Cuenta')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Nombre de la cuenta
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre de la cuenta'),
                onChanged: (value) => _nombre = value,
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese un nombre' : null,
              ),

              // Tipo de cuenta
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Tipo de cuenta'),
                value: _tipo,
                onChanged: (value) => setState(() => _tipo = value!),
                items: ['Ahorro', 'Corriente', 'Inversión']
                    .map((tipo) =>
                        DropdownMenuItem(value: tipo, child: Text(tipo)))
                    .toList(),
              ),

              // Tipo de moneda
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Tipo de moneda'),
                value: _tipoMoneda,
                onChanged: (value) => setState(() => _tipoMoneda = value!),
                items: ['USD', 'EUR', 'MXN'] // Opciones de moneda
                    .map((moneda) =>
                        DropdownMenuItem(value: moneda, child: Text(moneda)))
                    .toList(),
              ),

              // Saldo inicial
              TextFormField(
                decoration: InputDecoration(labelText: 'Saldo inicial'),
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

              // Botón para guardar cuenta
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Crear la nueva cuenta con los nuevos atributos
                    Cuenta nuevaCuenta = Cuenta(
                      nombre: _nombre,
                      tipo: _tipo,
                      saldo: _saldo,
                      fechaCreacion: DateTime.now(),
                      userEmail: userEmail, // Usar el correo del usuario
                      tipoMoneda: _tipoMoneda, // El tipo de moneda seleccionado
                    );

                    // Agregar la cuenta utilizando el controlador
                    await Provider.of<CuentaController>(context, listen: false)
                        .agregarCuenta(nuevaCuenta);

                    Navigator.pop(context);
                  }
                },
                child: Text('Guardar Cuenta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
