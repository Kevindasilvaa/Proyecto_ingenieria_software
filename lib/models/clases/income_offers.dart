import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class IncomeOffers {
  final String idOfertaDeTrabajo;
  final String email;
  final String titulo;
  final String descripcion;
  final double pago;
  final String estado;
  final String? phoneNumber;
  final String tipoMoneda;

  IncomeOffers({
    String? idOfertaDeTrabajo,
    required this.email,
    required this.titulo,
    required this.descripcion,
    required this.pago,
    required this.estado,
    this.phoneNumber,
    required this.tipoMoneda,
  }) : idOfertaDeTrabajo = idOfertaDeTrabajo ?? _generarIdOfertaDeTrabajo();

  Map<String, dynamic> toMap() {
    return {
      'id_oferta_de_trabajo': idOfertaDeTrabajo,
      'email': email,
      'titulo': titulo,
      'descripcion': descripcion,
      'pago': pago,
      'estado': estado,
      'phone_number': phoneNumber,
      'tipoMoneda': tipoMoneda,
    };
  }

  factory IncomeOffers.fromMap(Map<String, dynamic> map) {
    return IncomeOffers(
      idOfertaDeTrabajo: map['id_oferta_de_trabajo'],
      email: map['email'],
      titulo: map['titulo'],
      descripcion: map['descripcion'],
      pago: map['pago']?.toDouble() ?? 0.0,
      estado: map['estado'],
      phoneNumber: map['phone_number'],
      tipoMoneda: map['tipoMoneda'] ?? 'USD',
    );
  }

  factory IncomeOffers.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return IncomeOffers.fromMap(data);
  }

  static String _generarIdOfertaDeTrabajo() {
    const caracteres =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
          100, (_) => caracteres.codeUnitAt(random.nextInt(caracteres.length))),
    );
  }
}
