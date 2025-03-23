import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:moni/controllers/transaccion_controller.dart';
import 'package:moni/controllers/category_controller.dart';
import 'package:moni/controllers/cuenta_controller.dart';
import 'package:moni/models/clases/transaccion.dart';
import 'package:moni/models/clases/cuenta.dart';
import 'package:moni/models/clases/category.dart';

class AddTransactionDialog extends StatefulWidget {
  @override
  _AddTransactionDialogState createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  final _controller = TransaccionesController();
  final _formKey = GlobalKey<FormState>();
  final _descripcionController = TextEditingController();
  final _montoController = TextEditingController();
  final _nombreController = TextEditingController();

  String? _categoriaSeleccionada;
  String? _cuentaSeleccionada;
  DateTime? _fechaSeleccionada = DateTime.now();
  bool _ingreso = true;
  bool _isLoading = false;

  List<Category> _categorias = [];
  List<Cuenta> _cuentas = [];

  @override
  void initState() {
    super.initState();
    _cargarCategorias();
    _cargarCuentas();
  }

  Future<void> _cargarCuentas() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final cuentaController =
          Provider.of<CuentaController>(context, listen: false);
      await cuentaController.cargarCuentas(user.email!);
      setState(() {
        _cuentas = cuentaController.cuentas;
      });
    }
  }

  Future<void> _cargarCategorias() async {
    final categoryController =
        Provider.of<CategoryController>(context, listen: false);
    categoryController.categoriesStream().listen((categories) {
      setState(() {
        _categorias = categories;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Agregar Transacción'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Botones para cambiar entre ingreso y gasto
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _ingreso = true),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 150),
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                        color: _ingreso ? Colors.green.withOpacity(0.7) : null,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Ingreso',
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  GestureDetector(
                    onTap: () => setState(() => _ingreso = false),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 150),
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                        color: !_ingreso ? Colors.red.withOpacity(0.7) : null,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Gasto',
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              // Campo para monto
              TextFormField(
                controller: _montoController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: 'Monto'),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      double.tryParse(value) == null) {
                    return 'Por favor, ingresa un monto válido.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              // Campo para nombre
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa un nombre.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              // Dropdown para seleccionar cuenta
              DropdownButtonFormField<String>(
                value: _cuentaSeleccionada,
                onChanged: (newValue) => setState(() {
                  _cuentaSeleccionada = newValue;
                }),
                decoration: InputDecoration(labelText: 'Cuenta'),
                items: _cuentas.map((cuenta) {
                  return DropdownMenuItem(
                    value: cuenta.idCuenta,
                    child: Text(cuenta.nombre),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecciona una cuenta.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              // Dropdown para seleccionar categoría
              DropdownButtonFormField<String>(
                value: _categoriaSeleccionada,
                onChanged: (newValue) => setState(() {
                  _categoriaSeleccionada = newValue;
                }),
                decoration: InputDecoration(labelText: 'Categoría'),
                items: _categorias.map((categoria) {
                  return DropdownMenuItem(
                    value: categoria.id,
                    child: Text(categoria.name),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecciona una categoría.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              // Selector de fecha
              Row(
                children: [
                  Icon(Icons.calendar_today),
                  SizedBox(width: 10),
                  TextButton(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _fechaSeleccionada ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _fechaSeleccionada = pickedDate;
                        });
                      }
                    },
                    child: Text(
                      _fechaSeleccionada == null
                          ? 'Seleccionar fecha'
                          : DateFormat.yMd().format(_fechaSeleccionada!),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _isLoading
              ? null
              : () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _isLoading = true;
                    });

                    // Crear nueva transacción
                    final nuevaTransaccion = Transaccion(
                      id: '',
                      user_id: FirebaseAuth.instance.currentUser!.uid,
                      nombre: _nombreController.text.trim(),
                      categoria_id: _categoriaSeleccionada!,
                      descripcion: _descripcionController.text.trim(),
                      fecha: _fechaSeleccionada!,
                      ingreso: _ingreso,
                      monto: double.parse(_montoController.text.trim()),
                      cuenta_id: _cuentaSeleccionada!,
                    );

                    try {
                      // Obtener la cuenta seleccionada
                      final cuentaSeleccionada = _cuentas.firstWhere(
                          (cuenta) => cuenta.idCuenta == _cuentaSeleccionada);

                      // Calcular el nuevo saldo
                      double nuevoSaldo = _ingreso
                          ? cuentaSeleccionada.saldo +
                              double.parse(_montoController.text)
                          : cuentaSeleccionada.saldo -
                              double.parse(_montoController.text);

                      // Modificar cuenta con el nuevo saldo
                      final cuentaModificada = Cuenta(
                        idCuenta: cuentaSeleccionada.idCuenta,
                        nombre: cuentaSeleccionada.nombre,
                        saldo: nuevoSaldo,
                        userEmail: cuentaSeleccionada.userEmail,
                        fechaCreacion: cuentaSeleccionada.fechaCreacion,
                        tipo: cuentaSeleccionada.tipo,
                        tipoMoneda: cuentaSeleccionada.tipoMoneda,
                      );

                      // Actualizar cuenta en Firestore
                      await Provider.of<CuentaController>(context,
                              listen: false)
                          .modificarCuenta(cuentaModificada);

                      // Guardar transacción en Firestore
                      await _controller.agregarTransaccion(nuevaTransaccion);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Transacción agregada')),
                      );

                      Navigator.pop(context); // Cierra el diálogo
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Error al agregar la transacción: $e')),
                      );
                      print('Error al agregar: $e');
                    } finally {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  }
                },
          child: Text('Guardar'),
        ),
      ],
    );
  }
}
