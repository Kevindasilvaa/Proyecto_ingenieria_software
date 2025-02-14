class Cuenta {
  final String id;
  final String nombre;
  final String tipo;
  final double saldo;
  final DateTime fechaCreacion;

  Cuenta({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.saldo,
    required this.fechaCreacion,
  });

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'tipo': tipo,
      'saldo': saldo,
      'fechaCreacion': fechaCreacion.toIso8601String(),
    };
  }

  factory Cuenta.fromMap(String id, Map<String, dynamic> data) {
    return Cuenta(
      id: id,
      nombre: data['nombre'],
      tipo: data['tipo'],
      saldo: (data['saldo'] as num).toDouble(),
      fechaCreacion: DateTime.parse(data['fechaCreacion']),
    );
  }
}
