import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Timestamp

class Transaccion {
  final String id;
  final String user_id; 
  final String nombre;
  final String categoria_id;
  final String cuenta_id;
  final String descripcion;
  final DateTime fecha; // Usamos DateTime
  final bool ingreso;
  final double monto;

  Transaccion({
    required this.id,
    required this.user_id,
    required this.nombre,
    required this.categoria_id,
    required this.cuenta_id,
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
      cuenta_id: data['cuenta_id'],
      categoria_id: data['categoria_id'],
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
      'cuenta_id': cuenta_id,
      'categoria_id': categoria_id,
      'descripcion': descripcion,
      'fecha': Timestamp.fromDate(fecha), // Convierte DateTime a Timestamp
      'ingreso': ingreso,
      'monto': monto,
    };
  }
}