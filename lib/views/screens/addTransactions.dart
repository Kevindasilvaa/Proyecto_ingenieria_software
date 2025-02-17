import 'package:flutter/material.dart';
import 'package:moni/views/widgets/NavBar.dart'; // Importa tu widget NavBar
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moni/models/clases/transaccion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moni/controllers/transaccion_controller.dart';
import 'package:moni/models/clases/category.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:moni/controllers/category_controller.dart';
import 'package:moni/controllers/cuenta_controller.dart';
import 'package:moni/models/clases/cuenta.dart'; // Importa el modelo Cuenta

class AddTransactionsPage extends StatefulWidget {
  @override
  _AddTransactionsPageState createState() => _AddTransactionsPageState();
}

class _AddTransactionsPageState extends State<AddTransactionsPage> {
  final _controller = TransaccionesController();
  bool _ingreso = true;
  final _formKey = GlobalKey<FormState>();

  final _descripcionController = TextEditingController();
  final _montoController = TextEditingController();
  String? _categoriaSeleccionada;
  String? _cuentaSeleccionada;
  DateTime? _fechaSeleccionada;
  final _nombreController = TextEditingController();

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar transacción'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 219, 219, 219),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 230,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 219, 219, 219),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(45),
                      bottomRight: Radius.circular(45),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _ingreso = true;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 150),
                                  padding: EdgeInsets.only(
                                      left: 15, right: 15, top: 2, bottom: 2),
                                  decoration: BoxDecoration(
                                    color: _ingreso
                                        ? Colors.green.withOpacity(0.7)
                                        : null,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Ingreso',
                                    style: TextStyle(
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _ingreso = false;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 150),
                                  padding: EdgeInsets.only(
                                      left: 15, right: 15, top: 2, bottom: 2),
                                  decoration: BoxDecoration(
                                    color: !_ingreso
                                        ? Colors.red.withOpacity(0.7)
                                        : null,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Gasto',
                                    style: TextStyle(
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            "Monto",
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(!_ingreso ? " -" : "+",
                              style: TextStyle(fontSize: 35)),
                          Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: SizedBox(
                              width: 120,
                              child: TextFormField(
                                controller: _montoController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  alignLabelWithHint: true,
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: const Color.fromARGB(
                                            255, 191, 191, 191)),
                                  ),
                                ),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.w500,
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      double.tryParse(value) == null) {
                                    return "Ingrese un número válido";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Material(
                              elevation: 4.0,
                              borderRadius: BorderRadius.circular(10.0),
                              color: const Color.fromARGB(217, 217, 217, 217),
                              child: TextFormField(
                                controller: _nombreController,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person),
                                  labelText: 'Name',
                                  labelStyle: TextStyle(
                                      color:
                                          const Color.fromARGB(255, 0, 0, 0)),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(16.0),
                                ),
                              ),
                            ),
                            SizedBox(height: 15.0),
                             Material(
                          elevation: 4.0,
                          borderRadius: BorderRadius.circular(10.0),
                          color: const Color.fromARGB(217, 217, 217, 217),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Cuenta', // Cambiado a "Cuenta"
                              labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(16.0),
                              prefixIcon: Icon(Icons.account_balance), // Icono de cuenta
                            ),
                            value: _cuentaSeleccionada,
                            onChanged: (String? newValue) {
                              setState(() {
                                _cuentaSeleccionada = newValue;
                              });
                            },
                            items: _cuentas.map<DropdownMenuItem<String>>((Cuenta cuenta) { // Mapea las cuentas
                              return DropdownMenuItem<String>(
                                value: cuenta.idCuenta, // Usa el ID de la cuenta como valor
                                child: Text(cuenta.nombre), // Muestra el nombre de la cuenta
                              );
                            }).toList(),
                            validator: (value) {
                              if (value == null) {
                                return 'Select an account';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 15.0),
                             Material(
                              elevation: 4.0,
                              borderRadius: BorderRadius.circular(10.0),
                              color: const Color.fromARGB(217, 217, 217, 217),
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: 'Categoria',
                                  labelStyle: TextStyle(
                                      color:
                                          const Color.fromARGB(255, 0, 0, 0)),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(16.0),
                                  prefixIcon: Icon(Icons.category),
                                ),
                                value: _categoriaSeleccionada,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _categoriaSeleccionada = newValue;
                                  });
                                },
                                items: _categorias.map<DropdownMenuItem<String>>(
                                    (Category categoria) {
                                  return DropdownMenuItem<String>(
                                    value: categoria.id, // Usa el ID de la categoría
                                    child: Text(categoria.name), // Muestra el nombre
                                  );
                                }).toList(),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Select a category';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: 15.0),
                            Material(
                              elevation: 4.0,
                              borderRadius: BorderRadius.circular(10.0),
                              color: const Color.fromARGB(217, 217, 217, 217),
                              child: TextFormField(
                                controller: _descripcionController,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.flag),
                                  labelText: 'Descripcion',
                                  labelStyle: TextStyle(
                                      color:
                                          const Color.fromARGB(255, 0, 0, 0)),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(16.0),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Ingrese la descripción';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: 15.0),
                            Material(
                              elevation: 4.0,
                              borderRadius: BorderRadius.circular(10.0),
                              color: const Color.fromARGB(217, 217, 217, 217),
                              child: Row(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(left: 16.0),
                                    child: Icon(Icons.calendar_today),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0,
                                          right: 16.0,
                                          top: 16.0,
                                          bottom: 16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Fecha',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            _fechaSeleccionada == null
                                                ? 'Select Date'
                                                : DateFormat.yMd()
                                                    .format(_fechaSeleccionada!),
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      final DateTime? picked =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2101),
                                      );
                                      if (picked != null &&
                                          picked != _fechaSeleccionada)
                                        setState(() {
                                          _fechaSeleccionada = picked;
                                        });
                                    },
                                    icon: Icon(Icons.edit_calendar),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 15.0),
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  final nuevaTransaccion = Transaccion(
                                    id: '',
                                    user_id: FirebaseAuth
                                        .instance.currentUser!.uid,
                                    nombre: _nombreController.text,
                                    categoria_id: _categoriaSeleccionada!,
                                    descripcion: _descripcionController.text,
                                    fecha: _fechaSeleccionada!,
                                    ingreso: _ingreso,
                                    monto:double.parse(_montoController.text),
                                    cuenta_id: _cuentaSeleccionada!,
                                  );

                                  try {
                                    await _controller
                                        .agregarTransaccion(nuevaTransaccion);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('Transacción agregada')),
                                    );

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
                                          content: Text(
                                              'Error al agregar transacción: $e')),
                                    );
                                    print('Error adding transaction: $e');
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 100, 100, 100),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 24.0),
                              ),
                              child: const Text(
                                'AGREGAR',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 18.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}