import 'package:flutter/material.dart';
import 'package:moni/models/dbHelper/firebase_service.dart';
import 'package:moni/models/clases/cuenta.dart';

class CuentaController with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  List<Cuenta> _cuentas = [];

  List<Cuenta> get cuentas => _cuentas;

  Future<void> cargarCuentas(String userId) async {
    _cuentas = await _firebaseService.obtenerCuentas(userId);
    notifyListeners();
  }

  Future<void> agregarCuenta(String userId, Cuenta cuenta) async {
    await _firebaseService.agregarCuenta(userId, cuenta);
    await cargarCuentas(userId);
  }
}
