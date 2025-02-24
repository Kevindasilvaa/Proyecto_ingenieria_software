// import 'package:flutter/material.dart';
// import 'package:moni/controllers/category_controller.dart';
// import 'package:moni/controllers/transaccion_controller.dart';
// import 'package:moni/models/clases/category.dart';
// import 'package:moni/models/clases/transaccion.dart';
// import 'package:intl/intl.dart';

// class RecentTransactionsView extends StatelessWidget {
//   final TransaccionesController _controller = TransaccionesController();
//   final CategoryController categoryController = CategoryController();

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<List<Transaccion>>(
//       stream: _controller.obtenerTransaccionesUsuarioStream(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         } else if (snapshot.data == null || snapshot.data!.isEmpty) {
//           return const Center(child: Text('No hay transacciones'));
//         } else {
//           final transacciones = snapshot.data!;

//           transacciones.sort((a, b) => b.fecha.compareTo(a.fecha));
//           final ultimasTransacciones = transacciones.take(3).toList();

//           return ListView.builder(
//             itemCount: ultimasTransacciones.length,
//             itemBuilder: (context, index) {
//               final transaccion = ultimasTransacciones[index];

//               return Card(
//                 margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 shadowColor: Colors.grey.withOpacity(0.4),
//                 color: transaccion.ingreso ? Colors.green.shade100 : Colors.red.shade100, // Cambiar el color de la tarjeta según el tipo de transacción
//                 child: ListTile(
//                   contentPadding: const EdgeInsets.all(16.0),
//                   title: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween, // Alineamos el título y los íconos
//                     children: [
//                       // Título de la transacción
//                       Text(
//                         transaccion.nombre,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       // Íconos de editar y eliminar
//                       Row(
//                         children: [
//                           IconButton(
//                             icon: const Icon(Icons.edit),
//                             color: Colors.orange, // Color para el ícono de editar
//                             onPressed: () {
//                               // Acción para modificar
//                             },
//                           ),
//                           IconButton(
//                             icon: const Icon(Icons.delete),
//                             color: Colors.red, // Color para el ícono de eliminar
//                             onPressed: () {
//                               // Acción para eliminar
//                             },
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   subtitle: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween, // Divide espacio entre la izquierda y derecha
//                     children: [
//                       // Columna a la izquierda (Información de categoría y fecha)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           FutureBuilder<Category?>(
//                             future: categoryController.getCategoryById(transaccion.categoria_id),
//                             builder: (context, categorySnapshot) {
//                               if (categorySnapshot.connectionState == ConnectionState.waiting) {
//                                 return const CircularProgressIndicator();
//                               } else if (categorySnapshot.hasError) {
//                                 return Text('Error al cargar categoría: ${categorySnapshot.error}');
//                               } else if (!categorySnapshot.hasData || categorySnapshot.data == null) {
//                                 return const Text('Categoría no encontrada');
//                               } else {
//                                 final category = categorySnapshot.data!;
//                                 return Text(
//                                   'Categoría: ${category.name}',
//                                   style: TextStyle(color: Colors.black54, fontSize: 14),
//                                 );
//                               }
//                             },
//                           ),
//                           const SizedBox(height: 6),
//                           Text(
//                             'Fecha: ${DateFormat.yMd().format(transaccion.fecha)}',
//                             style: const TextStyle(color: Colors.black54, fontSize: 14),
//                           ),
//                         ],
//                       ),

//                       // Columna a la derecha (Monto)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.end, // Alineamos todo a la derecha
//                         children: [
//                           const SizedBox(height: 8), // Espacio entre los íconos y el monto
//                           // Monto debajo de los iconos, alineado a la derecha
//                           Text(
//                             '\$${transaccion.monto}',
//                             style: TextStyle(
//                               fontSize: 18,
//                               color: transaccion.ingreso ? Colors.green : Colors.red,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         }
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:moni/controllers/category_controller.dart';
import 'package:moni/controllers/transaccion_controller.dart';
import 'package:moni/models/clases/category.dart';
import 'package:moni/models/clases/transaccion.dart';
import 'package:intl/intl.dart';

class RecentTransactionsView extends StatelessWidget {
  final TransaccionesController _controller = TransaccionesController();
  final CategoryController categoryController = CategoryController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Transaccion>>(
      stream: _controller.obtenerTransaccionesUsuarioStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.data == null || snapshot.data!.isEmpty) {
          return const Center(child: Text('No hay transacciones'));
        } else {
          final transacciones = snapshot.data!;

          transacciones.sort((a, b) => b.fecha.compareTo(a.fecha));
          final ultimasTransacciones = transacciones.take(3).toList();

          return ListView.builder(
            itemCount: ultimasTransacciones.length,
            itemBuilder: (context, index) {
              final transaccion = ultimasTransacciones[index];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0), // Reducir el margen
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16), // Radio más pequeño
                ),
                shadowColor: Colors.grey.withOpacity(0.3), // Menos sombra
                color: transaccion.ingreso ? Colors.green.shade100 : Colors.red.shade100, // Cambiar el color de la tarjeta según el tipo de transacción
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0), // Reducir el padding
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Alineamos el título y los íconos
                    children: [
                      // Título de la transacción
                      Text(
                        transaccion.nombre,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Íconos de editar y eliminar
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            color: Colors.orange, // Color para el ícono de editar
                            onPressed: () {
                              // Acción para modificar
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            color: Colors.red, // Color para el ícono de eliminar
                            onPressed: () {
                              // Acción para eliminar
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Divide espacio entre la izquierda y derecha
                    children: [
                      // Columna a la izquierda (Información de categoría y fecha)
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
                                  style: TextStyle(color: Colors.black54, fontSize: 14),
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 4), // Reducir el espacio entre elementos
                          Text(
                            'Fecha: ${DateFormat.yMd().format(transaccion.fecha)}',
                            style: const TextStyle(color: Colors.black54, fontSize: 14),
                          ),
                        ],
                      ),

                      // Columna a la derecha (Monto)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end, // Alineamos todo a la derecha
                        children: [
                          const SizedBox(height: 6), // Reducir el espacio entre los íconos y el monto
                          // Monto debajo de los iconos, alineado a la derecha
                          Text(
                            '${transaccion.ingreso ? '+' : '-'}\$${transaccion.monto}', // Agregar el signo + o -
                            style: TextStyle(
                              fontSize: 16, // Mantener el tamaño de letra igual
                              color: transaccion.ingreso ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
