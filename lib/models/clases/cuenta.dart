import 'dart:math';
import 'package:flutter/material.dart';

class Cuenta {
  final String nombre;
  final String tipo;
  final double saldo;
  final DateTime fechaCreacion;
  final String userEmail;
  final String tipoMoneda;
  late String idCuenta;
  final IconData? icono;

  Cuenta({
    required this.nombre,
    required this.tipo,
    required this.saldo,
    required this.fechaCreacion,
    required this.userEmail,
    required this.tipoMoneda,
    String? idCuenta, // Se hace opcional
    this.icono,
  }) {
    if (saldo < 0) {
      throw ArgumentError('El saldo no puede ser negativo.');
    }
    if (nombre.isEmpty) {
      throw ArgumentError('El nombre no puede estar vacío.');
    }
    this.idCuenta = idCuenta ?? generarIdCuenta(); // Si no se pasa, se genera
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'tipo': tipo,
      'saldo': saldo,
      'fechaCreacion': fechaCreacion.toIso8601String(),
      'userEmail': userEmail,
      'tipoMoneda': tipoMoneda,
      'idCuenta': idCuenta,
      'icono': icono?.codePoint, // Se guarda el codePoint del ícono
    };
  }

  factory Cuenta.fromMap(Map<String, dynamic> data) {
    return Cuenta(
      nombre: data['nombre'],
      tipo: data['tipo'],
      saldo: (data['saldo'] as num).toDouble(),
      fechaCreacion: DateTime.parse(data['fechaCreacion']),
      userEmail: data['userEmail'],
      tipoMoneda: data['tipoMoneda'],
      idCuenta: data['idCuenta'], // Se pasa el idCuenta directamente
      icono: data['icono'] != null
          ? IconData(data['icono'], fontFamily: 'MaterialIcons')
          : null,
    );
  }

  String generarIdCuenta() {
    const caracteres =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    return String.fromCharCodes(
      Iterable.generate(
          20, (_) => caracteres.codeUnitAt(random.nextInt(caracteres.length))),
    );
  }
}
