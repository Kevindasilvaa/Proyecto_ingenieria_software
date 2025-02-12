import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Timestamp

class Transaccion {
  final String id;
  final String user_id; // Cambiado a userId para consistencia
  final String nombre;
  final String categoria;
  final String descripcion;
  final DateTime fecha; // Usamos DateTime
  final bool ingreso;
  final double monto;

  Transaccion({
    required this.id,
    required this.user_id,
    required this.nombre,
    required this.categoria,
    required this.descripcion,
    required this.fecha,
    required this.ingreso,
    required this.monto,
  });

  factory Transaccion.fromMap(Map<String, dynamic> data, String id) {
    return Transaccion(
      id: id,
      user_id: data['user_id'],
      nombre: data['nombre'],
      categoria: data['categoria'],
      descripcion: data['descripcion'],
      fecha: (data['fecha'] as Timestamp).toDate(), // Convierte Timestamp a DateTime
      ingreso: data['ingreso'],
      monto: (data['monto'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': user_id,
      'nombre': nombre,
      'categoria': categoria,
      'descripcion': descripcion,
      'fecha': Timestamp.fromDate(fecha), // Convierte DateTime a Timestamp
      'ingreso': ingreso,
      'monto': monto,
    };
  }
}