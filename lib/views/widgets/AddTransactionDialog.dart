import 'package:flutter/material.dart';
import 'package:moni/views/widgets/CustomButton.dart';
import 'package:moni/views/widgets/DatePickerField.dart';
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
  final TextEditingController _fechaController = TextEditingController();

  return AlertDialog(
    backgroundColor: const Color(0xFF2E4A5A), // Fondo azul oscuro
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    title: const Center(
      child: Text(
        'Agregar Transacción',
        style: TextStyle(
          color: Colors.white, // Texto blanco
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    content: SizedBox(
      width: MediaQuery.of(context).size.width * 0.9, // Ancho ajustado
      child: SingleChildScrollView(
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
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                        color: _ingreso ? Colors.green.withOpacity(0.7) : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Ingreso',
                        style: TextStyle(fontSize: 22, color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () => setState(() => _ingreso = false),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                        color: !_ingreso ? Colors.red.withOpacity(0.7) : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Gasto',
                        style: TextStyle(fontSize: 22, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              // Campo para monto
              Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
                child: TextFormField(
                  controller: _montoController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Monto',
                    labelStyle: TextStyle(color: Colors.black),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.money, color: Colors.black),
                    contentPadding: EdgeInsets.all(16.0),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || double.tryParse(value) == null) {
                      return 'Por favor, ingresa un monto válido.';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 15),
              // Campo para nombre
              Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
                child: TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                    labelStyle: TextStyle(color: Colors.black),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.receipt, color: Colors.black),
                    contentPadding: EdgeInsets.all(16.0),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa un nombre.';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 15),
              // Dropdown para seleccionar cuenta
              Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
                child: DropdownButtonFormField<String>(
                  value: _cuentaSeleccionada,
                  onChanged: (newValue) => setState(() {
                    _cuentaSeleccionada = newValue!;
                  }),
                  decoration: const InputDecoration(
                    labelText: 'Cuenta',
                    labelStyle: TextStyle(color: Colors.black),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16.0),
                    prefixIcon: Icon(Icons.account_balance, color: Colors.black),
                  ),
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
              ),
              const SizedBox(height: 15),
              // Dropdown para seleccionar categoría
              Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
                child: DropdownButtonFormField<String>(
                  value: _categoriaSeleccionada,
                  onChanged: (newValue) => setState(() {
                    _categoriaSeleccionada = newValue!;
                  }),
                  decoration: const InputDecoration(
                    labelText: 'Categoría',
                    labelStyle: TextStyle(color: Colors.black),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16.0),
                    prefixIcon: Icon(Icons.category, color: Colors.black),
                  ),
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
              ),
              const SizedBox(height: 15),
              // Input para seleccionar la fecha
              DatePickerField(
                controller: _fechaController, // Controlador para gestionar la fecha
                labelText: 'Fecha de transacción', // Etiqueta del campo
                labelStyle: const TextStyle(color: Colors.black), // Texto en color negro
                backgroundColor: Colors.white, // Fondo blanco del campo
                initialDate: _fechaSeleccionada ?? DateTime.now(), // Fecha inicial
                onChanged: (selectedDate) {
                  setState(() {
                    _fechaSeleccionada = selectedDate; // Actualiza la fecha seleccionada
                    _fechaController.text = DateFormat.yMd().format(selectedDate); // Formatea la fecha seleccionada
                  });
                },
              ),
              ],
          ),
        ),
      ),
    ),
    actions: [
  TextButton(
    onPressed: () => Navigator.pop(context),
    child: const Text(
      'Cancelar',
      style: TextStyle(color: Colors.white), // Texto blanco
    ),
  ),
  // Aquí añadimos la columna para el botón o la barra de carga
  Column(
    mainAxisSize: MainAxisSize.min, // Asegura que no ocupe más espacio del necesario
    children: [
      _isLoading
          ? const CircularProgressIndicator() // Muestra la barra de carga
          : ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(const Color(0xFF5DA6A7)), // Fondo verde
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Bordes redondeados
                    ),
                  ),
                ),
              onPressed: () async {
                setState(() {
                  _isLoading = true; // Muestra el indicador de carga
                });

                // Verifica si el monto está vacío o no es válido
                if (_montoController.text.isEmpty ||
                    double.tryParse(_montoController.text) == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor ingresa un monto válido.'),
                    ),
                  );
                  setState(() {
                    _isLoading = false; // Ocultar el indicador si el monto no es válido
                  });
                  return;
                }

                if (_formKey.currentState!.validate()) {
                  final nuevaTransaccion = Transaccion(
                    id: '',
                    user_id: FirebaseAuth.instance.currentUser!.uid,
                    nombre: _nombreController.text,
                    categoria_id: _categoriaSeleccionada!,
                    descripcion: _descripcionController.text,
                    fecha: _fechaSeleccionada!,
                    ingreso: _ingreso,
                    monto: double.parse(_montoController.text),
                    cuenta_id: _cuentaSeleccionada!,
                  );

                  try {
                    // Obtener la cuenta seleccionada
                    final cuentaSeleccionada = _cuentas.firstWhere(
                      (cuenta) => cuenta.idCuenta == _cuentaSeleccionada,
                    );

                    // Calcular el nuevo saldo
                    double nuevoSaldo = _ingreso
                        ? cuentaSeleccionada.saldo +
                            double.parse(_montoController.text)
                        : cuentaSeleccionada.saldo -
                            double.parse(_montoController.text);

                    // Crear una copia de la cuenta con el nuevo saldo
                    final cuentaModificada = Cuenta(
                      idCuenta: cuentaSeleccionada.idCuenta,
                      nombre: cuentaSeleccionada.nombre,
                      saldo: nuevoSaldo,
                      userEmail: cuentaSeleccionada.userEmail,
                      fechaCreacion: cuentaSeleccionada.fechaCreacion,
                      tipo: cuentaSeleccionada.tipo,
                      tipoMoneda: cuentaSeleccionada.tipoMoneda,
                    );

                    // Modificar la cuenta en Firestore
                    await Provider.of<CuentaController>(context, listen: false)
                        .modificarCuenta(cuentaModificada);

                    // Agregar la transacción
                    await _controller.agregarTransaccion(nuevaTransaccion);

                    // Mostrar un mensaje de éxito
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Transacción agregada')),
                    );

                    // Navegar al home y reiniciar el formulario
                    Navigator.pushReplacementNamed(context, '/home');
                    _formKey.currentState!.reset();
                    setState(() {
                      _fechaSeleccionada = null;
                      _categoriaSeleccionada = null;
                      _cuentaSeleccionada = null;
                      _montoController.clear();
                      _nombreController.clear();
                      _descripcionController.clear();
                    });
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error al agregar transacción: $e'),
                      ),
                    );
                  } finally {
                    setState(() {
                      _isLoading = false; // Ocultar el indicador de carga
                    });
                  }
                } else {
                  setState(() {
                    _isLoading = false; // Ocultar el indicador de carga si la validación falla
                  });
                }
              },
              child: const Text(
                'Agregar',
                style: TextStyle(color: Colors.white), // Texto blanco
              ),
            ),
    ],
  ),
],

  );
}
}