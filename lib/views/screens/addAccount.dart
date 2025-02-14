import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moni/models/clases/cuenta.dart';
import 'package:moni/controllers/cuenta_controller.dart';

class AddAccountPage extends StatefulWidget {
  final String userId;

  const AddAccountPage({Key? key, required this.userId}) : super(key: key);

  @override
  _AddAccountPageState createState() => _AddAccountPageState();
}

class _AddAccountPageState extends State<AddAccountPage> {
  final _formKey = GlobalKey<FormState>();
  String _nombre = '';
  String _tipo = 'Ahorro';
  double _saldo = 0.0;

  @override
  Widget build(BuildContext context) {
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
                    Cuenta nuevaCuenta = Cuenta(
                      id: '',
                      nombre: _nombre,
                      tipo: _tipo,
                      saldo: _saldo,
                      fechaCreacion: DateTime.now(),
                    );

                    await Provider.of<CuentaController>(context, listen: false)
                        .agregarCuenta(widget.userId, nuevaCuenta);

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
