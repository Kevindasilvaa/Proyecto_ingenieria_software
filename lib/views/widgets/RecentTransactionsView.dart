import 'package:flutter/material.dart';
import 'package:moni/controllers/transaccion_controller.dart';
import 'package:moni/models/clases/transaccion.dart';
import 'package:intl/intl.dart';

//Este widget retorna las ultimas tres transacciones del usuario
class RecentTransactionsView extends StatelessWidget {
  final TransaccionesController _controller = TransaccionesController();

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
                  leading: Icon(Icons.monetization_on, color: transaccion.ingreso ? Colors.green : Colors.red), // Icono de ingreso/gasto
                  title: Text(transaccion.nombre),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Categoría: ${transaccion.categoria_id}'),
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