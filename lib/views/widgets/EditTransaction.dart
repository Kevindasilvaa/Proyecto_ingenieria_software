// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:moni/models/clases/transaccion.dart';
// import 'package:moni/controllers/transaccion_controller.dart';
// import 'package:intl/intl.dart';
// import 'package:moni/views/widgets/CustomButton.dart';
// import 'package:moni/views/widgets/CustomDropdown.dart';
// import 'package:moni/views/widgets/DatePickerField.dart';

// class EditTransaction extends StatefulWidget {
//   final Transaccion transaction;

//   EditTransaction({required this.transaction});

//   @override
//   _EditTransactionPageState createState() => _EditTransactionPageState();
// }

// class _EditTransactionPageState extends State<EditTransaction> {
//   final _formKey = GlobalKey<FormState>();
//   final _nombreController = TextEditingController();
//   final _montoController = TextEditingController();
//   final _descripcionController = TextEditingController();
//   final _fechaController = TextEditingController();
//   final _tipoController = TextEditingController();
//   DateTime? _fechaSeleccionada;

//   final _controller = TransaccionesController();

//   @override
//   void initState() {
//     super.initState();
//     _nombreController.text = widget.transaction.nombre;
//     _montoController.text = widget.transaction.monto.toString();
//     _descripcionController.text = widget.transaction.descripcion;
//     _fechaSeleccionada = widget.transaction.fecha;
//     _fechaController.text = widget.transaction.fecha != null ? DateFormat.yMd().format(widget.transaction.fecha!) : 'No disponible';
//     _tipoController.text = widget.transaction.ingreso ? 'Ingreso' : 'Gasto';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Editar Transacción'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView( // Usamos ListView para evitar desbordamiento
//             children: [
//               // Nombre
//               Material(
//                 elevation: 4.0, // Adjust as needed
//                 borderRadius: BorderRadius.circular(10.0),
//                 color: const Color.fromARGB(217, 217, 217, 217), // Background color of the box
//                 child: TextFormField(
//                   controller: _nombreController,
//                   decoration: InputDecoration(
//                     prefixIcon: Icon(Icons.person),
//                     labelText: 'Nombre',
//                     labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
//                     border: InputBorder.none, // Remove the default border
//                     contentPadding: EdgeInsets.all(16.0),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 16),
             
//               // Monto
//               Material(
//                 elevation: 4.0, // Ajusta según sea necesario
//                 borderRadius: BorderRadius.circular(10.0),
//                 color: const Color.fromARGB(217, 217, 217, 217), // Color de fondo de la caja
//                 child: TextFormField(
//                   controller: _montoController,
//                   decoration: InputDecoration(
//                     prefixIcon: Icon(Icons.money),
//                     labelText: 'Monto',
//                     labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
//                     border: InputBorder.none, // Eliminar el borde por defecto
//                     contentPadding: EdgeInsets.all(16.0),
//                   ),
//                   keyboardType: TextInputType.numberWithOptions(decimal: true), // Permite números y decimales
//                   inputFormatters: [
//                     FilteringTextInputFormatter.allow(RegExp(r'^[0-9\.]+$')), // Solo permite números y puntos
//                   ],
//                 ),
//               ),
//               SizedBox(height: 16),
//               // Descripcion
//               Material(
//                 elevation: 4.0, // Adjust as needed
//                 borderRadius: BorderRadius.circular(10.0),
//                 color: const Color.fromARGB(217, 217, 217, 217), // Background color of the box
//                 child: TextFormField(
//                   controller: _descripcionController,
//                   decoration: InputDecoration(
//                     prefixIcon: Icon(Icons.flag),
//                     labelText: 'Descripción',
//                     labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
//                     border: InputBorder.none, // Remove the default border
//                     contentPadding: EdgeInsets.all(16.0),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 16),
//               // Fecha de transaccion
//               DatePickerField(
//                 controller: _fechaController,
//                 labelText: 'Fecha de transacción',
//                 initialDate: _fechaSeleccionada ?? DateTime.now(),
//                 onChanged: (selectedDate) {
//                   setState(() {
//                     _fechaSeleccionada = selectedDate;
//                     _fechaController.text = DateFormat.yMd().format(selectedDate);
//                   });
//                 },
//               ),
//               SizedBox(height: 16),
//               // Tipo de transaccion
//               CustomDropdown(
//               controller: _tipoController, 
//               labelText: 'Tipo de transaccion',
//               icon: Icons.monetization_on,
//               items: ['Ingreso', 
//                       'Gasto', 
//                     ],
//             ),
//               SizedBox(height: 20),
//               // Boton 
//               CustomButton(
//                         onPressed: () async {
//                 if (_formKey.currentState!.validate()) {
//                   Transaccion updatedTransaction = Transaccion(
//                     id: widget.transaction.id,
//                     nombre: _nombreController.text,
//                     categoria_id: widget.transaction.categoria_id,
//                     cuenta_id: widget.transaction.cuenta_id,
//                     user_id: widget.transaction.user_id,
//                     monto: double.parse(_montoController.text),
//                     descripcion: _descripcionController.text,
//                     fecha: DateTime.tryParse(_fechaController.text) ?? DateTime.now(),
//                     ingreso: _tipoController.text == 'Ingreso' ? true : false,
//                   );

//                   try {
//                     await _controller.modificarTransaccion(updatedTransaction, widget.transaction);
//                     Navigator.pop(context, true);
//                     ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('Transacción Actualizada')));
//                   } catch (e) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('Error al actualizar')));
//                     print('Error updating transaction: $e');
//                   }
//                 }
//               },
//                   text: 'Guardar Cambios',
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moni/models/clases/transaccion.dart';
import 'package:moni/controllers/transaccion_controller.dart';
import 'package:intl/intl.dart';
import 'package:moni/views/widgets/CustomButton.dart';
import 'package:moni/views/widgets/CustomDropdown.dart';
import 'package:moni/views/widgets/DatePickerField.dart';

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
  final _fechaController = TextEditingController();
  final _tipoController = TextEditingController();
  DateTime? _fechaSeleccionada;
  bool _isLoading = false; // Add loading state

  final _controller = TransaccionesController();

  @override
  void initState() {
    super.initState();
    _nombreController.text = widget.transaction.nombre;
    _montoController.text = widget.transaction.monto.toString();
    _descripcionController.text = widget.transaction.descripcion;
    _fechaSeleccionada = widget.transaction.fecha;
    _fechaController.text = widget.transaction.fecha != null ? DateFormat.yMd().format(widget.transaction.fecha!) : 'No disponible';
    _tipoController.text = widget.transaction.ingreso ? 'Ingreso' : 'Gasto';
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
          child: ListView(
            children: [
              // Nombre
              Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(10.0),
                color: const Color.fromARGB(217, 217, 217, 217),
                child: TextFormField(
                  controller: _nombreController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.receipt),
                    labelText: 'Nombre',
                    labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16.0),
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Monto
              Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(10.0),
                color: const Color.fromARGB(217, 217, 217, 217),
                child: TextFormField(
                  controller: _montoController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.money),
                    labelText: 'Monto',
                    labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16.0),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^[0-9\.]+$')),
                  ],
                ),
              ),
              SizedBox(height: 16),
              // Descripcion
              Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(10.0),
                color: const Color.fromARGB(217, 217, 217, 217),
                child: TextFormField(
                  controller: _descripcionController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.description),
                    labelText: 'Descripción',
                    labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16.0),
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Fecha de transaccion
              DatePickerField(
                controller: _fechaController,
                labelText: 'Fecha de transacción',
                initialDate: _fechaSeleccionada ?? DateTime.now(),
                onChanged: (selectedDate) {
                  setState(() {
                    _fechaSeleccionada = selectedDate;
                    _fechaController.text = DateFormat.yMd().format(selectedDate);
                  });
                },
              ),
              SizedBox(height: 16),
              // Tipo de transaccion
              CustomDropdown(
                controller: _tipoController,
                labelText: 'Tipo de transaccion',
                icon: Icons.monetization_on,
                items: ['Ingreso', 'Gasto'],
              ),
              SizedBox(height: 20),
              // Boton
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : CustomButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });
                          Transaccion updatedTransaction = Transaccion(
                            id: widget.transaction.id,
                            nombre: _nombreController.text,
                            categoria_id: widget.transaction.categoria_id,
                            cuenta_id: widget.transaction.cuenta_id,
                            user_id: widget.transaction.user_id,
                            monto: double.parse(_montoController.text),
                            descripcion: _descripcionController.text,
                            fecha: DateTime.tryParse(_fechaController.text) ?? DateTime.now(),
                            ingreso: _tipoController.text == 'Ingreso' ? true : false,
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
                          } finally {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        }
                      },
                      text: 'Guardar Cambios',
                    ),
            ],
          ),
        ),
      ),
    );
  }
}