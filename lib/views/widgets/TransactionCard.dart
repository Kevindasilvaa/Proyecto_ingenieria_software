import 'package:flutter/material.dart';
import 'package:moni/controllers/category_controller.dart';
import 'package:moni/controllers/transaccion_controller.dart';
import 'package:moni/models/clases/category.dart';
import 'package:moni/models/clases/transaccion.dart';
import 'package:intl/intl.dart';
import 'package:moni/views/widgets/EditTransaction.dart';

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
        borderRadius: BorderRadius.circular(6), // Bordes redondeados
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditTransaction(transaction: transaccion),
                        ),
                      );
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
                    future: categoryController.getCategoryById(transaccion.categoria_id),
                    builder: (context, categorySnapshot) {
                      if (categorySnapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (categorySnapshot.hasError) {
                        return Text('Error al cargar categoría: ${categorySnapshot.error}');
                      } else if (!categorySnapshot.hasData || categorySnapshot.data == null) {
                        return const Text('Categoría no encontrada');
                      } else {
                        final category = categorySnapshot.data!;
                        return Text(
                          'Categoría: ${category.name}',
                          style: const TextStyle(color: Colors.black54, fontSize: 14),
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
              title: const Text("Confirmar eliminación"),
              content: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : const Text("¿Seguro que desea eliminar esta transacción?"),
              actions: <Widget>[
                TextButton(
                  child: const Text("Cancelar"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text("Eliminar"),
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
                                const SnackBar(content: Text('Transacción eliminada')));
                          } catch (error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Error al eliminar')));
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
}

