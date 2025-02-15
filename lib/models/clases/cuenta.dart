import 'dart:math';

class Cuenta {
  final String nombre;
  final String tipo;
  final double saldo;
  final DateTime fechaCreacion;
  final String userEmail;
  final String tipoMoneda;
  late String idCuenta;

  Cuenta({
    required this.nombre,
    required this.tipo,
    required this.saldo,
    required this.fechaCreacion,
    required this.userEmail,
    required this.tipoMoneda, 
    idCuenta,
  }) {
    generarIdCuenta(); // Generar el ID al crear la cuenta
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
      idCuenta: data['idCuenta'],
    );
  }

  void generarIdCuenta() {
    const caracteres = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    idCuenta = String.fromCharCodes(
      Iterable.generate(50, (_) => caracteres.codeUnitAt(random.nextInt(caracteres.length))),
    );
  }
}
