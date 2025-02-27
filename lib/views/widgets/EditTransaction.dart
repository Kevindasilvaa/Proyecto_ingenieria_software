import 'package:flutter/material.dart';
import 'package:moni/models/clases/transaccion.dart';
import 'package:moni/controllers/transaccion_controller.dart';
import 'package:intl/intl.dart';

class EditTransaction extends StatefulWidget {
  final Transaccion transaction;

  EditTransaction({required this.transaction});

  @override
  _EditTransactionPageState createState() => _EditTransactionPageState();
}

class _EditTransactionPageState extends State<EditTransaction> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _montoController = TextEditingController();
  final _descripcionController = TextEditingController();
  DateTime? _fechaSeleccionada;
  bool _esIngreso = false; // Para el switch de Ingreso/Gasto

  final _controller = TransaccionesController();

  @override
  void initState() {
    super.initState();
    _nombreController.text = widget.transaction.nombre;
    _montoController.text = widget.transaction.monto.toString();
    _descripcionController.text = widget.transaction.descripcion;
    _fechaSeleccionada = widget.transaction.fecha;
    _esIngreso = widget.transaction.ingreso;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Transacción'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView( // Usamos ListView para evitar desbordamiento
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese un nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _montoController,
                decoration: InputDecoration(labelText: 'Monto'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese un monto';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Ingrese un número válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(labelText: 'Descripción'),
              ),
              Row(
                children: [
                  Text('Fecha:'),
                  SizedBox(width: 10),
                  TextButton(
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _fechaSeleccionada ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != _fechaSeleccionada)
                        setState(() {
                          _fechaSeleccionada = picked;
                        });
                    },
                    child: Text(
                      _fechaSeleccionada != null
                          ? DateFormat('yyyy-MM-dd').format(_fechaSeleccionada!)
                          : 'Seleccionar fecha',
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('Tipo:'),
                  SizedBox(width: 10),
                  Switch(
                    value: _esIngreso,
                    onChanged: (value) {
                      setState(() {
                        _esIngreso = value;
                      });
                    },
                  ),
                  Text(_esIngreso ? 'Ingreso' : 'Gasto'),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  Transaccion updatedTransaction = Transaccion(
                    id: widget.transaction.id,
                    nombre: _nombreController.text,
                    categoria_id: widget.transaction.categoria_id,
                    cuenta_id: widget.transaction.cuenta_id,
                    user_id: widget.transaction.user_id,
                    monto: double.parse(_montoController.text),
                    descripcion: _descripcionController.text,
                    fecha: _fechaSeleccionada!,
                    ingreso: _esIngreso,
                  );

                  try {
                    await _controller.modificarTransaccion(updatedTransaction, widget.transaction);
                    Navigator.pop(context, true);
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Transacción Actualizada')));
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error al actualizar')));
                    print('Error updating transaction: $e');
                  }
                }
              },
              child: Text('Guardar Cambios'),
            ),
            ],
          ),
        ),
      ),
    );
  }
}