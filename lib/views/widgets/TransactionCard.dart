import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moni/controllers/category_controller.dart';
import 'package:moni/controllers/transaccion_controller.dart';
import 'package:moni/models/clases/category.dart';
import 'package:moni/models/clases/transaccion.dart';
import 'package:intl/intl.dart';
import 'package:moni/views/widgets/CustomDropdown.dart';
import 'package:moni/views/widgets/DatePickerField.dart';

class TransactionCard extends StatelessWidget {
  final Transaccion transaccion;
  final TransaccionesController _controller = TransaccionesController();
  final CategoryController categoryController = CategoryController();

  TransactionCard({
    Key? key,
    required this.transaccion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Configuración del formateo numérico
    final numberFormat = NumberFormat('#,##0.00', 'es_ES');

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9), // Fondo similar al diseño proporcionado
        borderRadius: BorderRadius.circular(8), // Bordes redondeados
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 124, 124, 124).withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // Sombra con desplazamiento
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // Acción al presionar la tarjeta (se puede dejar vacío si no se necesita)
        },
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Título de la transacción
              Text(
                transaccion.nombre,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87, // Color de texto principal
                ),
              ),
              // Íconos de editar y eliminar
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    color: Colors.orange,
                    onPressed: () {
                      _showEditTransactionDialog(
                          context, transaccion); // Llamamos al showDialog
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _showDeleteDialog(context);
                    },
                  ),
                ],
              ),
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Información de categoría y fecha
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<Category?>(
                    future: categoryController
                        .getCategoryById(transaccion.categoria_id),
                    builder: (context, categorySnapshot) {
                      if (categorySnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (categorySnapshot.hasError) {
                        return Text(
                            'Error al cargar categoría: ${categorySnapshot.error}');
                      } else if (!categorySnapshot.hasData ||
                          categorySnapshot.data == null) {
                        return const Text('Categoría no encontrada');
                      } else {
                        final category = categorySnapshot.data!;
                        return Text(
                          'Categoría: ${category.name}',
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 14),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 0),
                  Text(
                    'Fecha: ${DateFormat.yMd().format(transaccion.fecha)}',
                    style: const TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                ],
              ),
              // Monto de la transacción con formato adecuado
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(height: 6),
                  Text(
                    '${transaccion.ingreso ? '+' : '-'}${numberFormat.format(transaccion.monto)}',
                    style: TextStyle(
                      fontSize: 18,
                      color: transaccion.ingreso ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool _isLoading = false;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF2E4A5A), // Fondo azul
              title: const Center(
                child: Text(
                  "Confirmar eliminación",
                  style: TextStyle(
                    color: Colors.white, // Texto blanco
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              content: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : const Text(
                      "¿Seguro que desea eliminar esta transacción?",
                      style: TextStyle(color: Colors.white), // Texto blanco
                    ),
              actions: <Widget>[
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Colors.transparent), // Botón transparente
                  ),
                  child: const Text(
                    "Cancelar",
                    style: TextStyle(color: Colors.white), // Texto blanco
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        const Color(0xFFF44336)), // Fondo rojo
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8.0), // Bordes redondeados
                      ),
                    ),
                  ),
                  child: const Text(
                    "Eliminar",
                    style: TextStyle(
                        color: Colors.white), // Texto negro para contraste
                  ),
                  onPressed: _isLoading
                      ? null
                      : () async {
                          setState(() {
                            _isLoading = true;
                          });
                          try {
                            await _controller.eliminarTransaccion(transaccion);
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Transacción eliminada')));
                          } catch (error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Error al eliminar')));
                          } finally {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditTransactionDialog(
      BuildContext context, Transaccion transaction) {
    final _formKey = GlobalKey<FormState>();
    final _nombreController = TextEditingController(text: transaction.nombre);
    final _montoController =
        TextEditingController(text: transaction.monto.toString());
    final _descripcionController =
        TextEditingController(text: transaction.descripcion);
    final _fechaController = TextEditingController(
        text: transaction.fecha != null
            ? DateFormat.yMd().format(transaction.fecha!)
            : 'No disponible');
    final _tipoController =
        TextEditingController(text: transaction.ingreso ? 'Ingreso' : 'Gasto');
    DateTime? _fechaSeleccionada = transaction.fecha;
    bool _isLoading = false;
    final _controller = TransaccionesController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF2E4A5A), // Fondo azul
              title: const Center(
                child: Text(
                  'Editar Transacción',
                  style: TextStyle(
                    color: Colors.white, // Texto blanco
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              content: SizedBox(
                width:
                    MediaQuery.of(context).size.width * 0.9, // Ancho ajustado
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nombre
                        Material(
                          elevation: 4.0,
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white, // Fondo blanco para contraste
                          child: TextFormField(
                            controller: _nombreController,
                            decoration: const InputDecoration(
                              prefixIcon:
                                  Icon(Icons.receipt, color: Colors.black),
                              labelText: 'Nombre',
                              labelStyle: TextStyle(color: Colors.black),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(16.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Monto
                        Material(
                          elevation: 4.0,
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white, // Fondo blanco para contraste
                          child: TextFormField(
                            controller: _montoController,
                            decoration: const InputDecoration(
                              prefixIcon:
                                  Icon(Icons.money, color: Colors.black),
                              labelText: 'Monto',
                              labelStyle: TextStyle(color: Colors.black),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(16.0),
                            ),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^[0-9\.]+$')),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Descripción
                        Material(
                          elevation: 4.0,
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white, // Fondo blanco para contraste
                          child: TextFormField(
                            controller: _descripcionController,
                            decoration: const InputDecoration(
                              prefixIcon:
                                  Icon(Icons.description, color: Colors.black),
                              labelText: 'Descripción',
                              labelStyle: TextStyle(color: Colors.black),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(16.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Fecha
                        DatePickerField(
                          controller: _fechaController,
                          labelText: 'Fecha de transacción',
                          labelStyle: const TextStyle(
                              color: Colors
                                  .black), // Texto negro para mejor contraste
                          backgroundColor: Colors.white, // Fondo blanco
                          initialDate: _fechaSeleccionada ?? DateTime.now(),
                          onChanged: (selectedDate) {
                            setState(() {
                              _fechaSeleccionada = selectedDate;
                              _fechaController.text =
                                  DateFormat.yMd().format(selectedDate);
                            });
                          },
                        ),

                        const SizedBox(height: 16),
                        // Tipo
                        CustomDropdown(
                          controller: _tipoController,
                          labelText: 'Tipo de transacción',
                          labelStyle: const TextStyle(
                              color: Colors.black), // Texto blanco
                          backgroundColor: Colors.white,
                          icon: Icons.monetization_on,
                          items: ['Ingreso', 'Gasto'],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.white), // Texto blanco
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        const Color(0xFF5DA6A7)), // Fondo verde
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8.0), // Bordes redondeados
                      ),
                    ),
                  ),
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                            });

                            final updatedTransaction = Transaccion(
                              id: transaction.id,
                              nombre: _nombreController.text,
                              categoria_id: transaction.categoria_id,
                              cuenta_id: transaction.cuenta_id,
                              user_id: transaction.user_id,
                              monto: double.parse(_montoController.text),
                              descripcion: _descripcionController.text,
                              fecha: _fechaSeleccionada ?? DateTime.now(),
                              ingreso: _tipoController.text == 'Ingreso',
                            );

                            try {
                              await _controller.modificarTransaccion(
                                  updatedTransaction, transaction);
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Transacción actualizada.')));
                            } catch (error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Error al actualizar.')));
                            } finally {
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          }
                        },
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Guardar',
                          style: TextStyle(color: Colors.white), // Texto blanco
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
