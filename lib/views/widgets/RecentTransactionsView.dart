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

          // Ordena las transacciones por fecha de forma descendente (las más recientes primero)
          transacciones.sort((a, b) => b.fecha.compareTo(a.fecha));

          // Toma solo las últimas 3 transacciones
          final ultimasTransacciones = transacciones.take(3).toList();

          return ListView.builder(
            itemCount: ultimasTransacciones.length,
            itemBuilder: (context, index) {
              final transaccion = ultimasTransacciones[index];
              
              return Card( // Envuelve cada transacción en una Card
                margin: const EdgeInsets.symmetric(vertical: 8.0), // Márgenes para separar las tarjetas
                child: ListTile(
                  leading: Icon(
                    Icons.monetization_on,
                    color: transaccion.ingreso ? Colors.green : Colors.red
                  ), // Icono de ingreso/gasto
                  title: Text(transaccion.nombre),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Aquí usamos un FutureBuilder para obtener el nombre de la categoría
                      FutureBuilder<Category?>(
                        future: categoryController.getCategoryById(transaccion.categoria_id),
                        builder: (context, categorySnapshot) {
                          if (categorySnapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator(); // Símbolo de carga
                          } else if (categorySnapshot.hasError) {
                            return Text('Error al cargar categoría: ${categorySnapshot.error}');
                          } else if (!categorySnapshot.hasData || categorySnapshot.data == null) {
                            return const Text('Categoría no encontrada');
                          } else {
                            final category = categorySnapshot.data!;
                            return Text('Categoria: ${category.name}');
                          }
                        },
                      ),
                      Text('Monto: ${transaccion.monto}'),
                      Text('Fecha: ${DateFormat.yMd().format(transaccion.fecha)}'),
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

