import 'package:flutter/material.dart';
import 'package:moni/models/dbHelper/firebase_service.dart';
import 'package:moni/models/clases/cuenta.dart';

class CuentaController with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  List<Cuenta> _cuentas = [];

  List<Cuenta> get cuentas => _cuentas;

  // Modificamos cargarCuentas para aceptar userEmail
  Future<void> cargarCuentas(String userEmail) async {
    _cuentas = await _firebaseService
        .obtenerCuentas(userEmail); // Cambié userId por userEmail
    notifyListeners();
  }

  // Modificamos agregarCuenta para aceptar un objeto Cuenta
  Future<void> agregarCuenta(Cuenta cuenta) async {
    await _firebaseService.agregarCuenta(
        cuenta); // Cambié para pasar el objeto cuenta directamente
    await cargarCuentas(cuenta
        .userEmail); // Usamos el email de la cuenta para recargar las cuentas
  }

  Future<void> modificarCuenta(Cuenta cuenta) async {
    try {
      await _firebaseService
          .modificarCuenta(cuenta); // Llama a la función en FirebaseService
      await cargarCuentas(
          cuenta.userEmail); // Recarga las cuentas para actualizar la lista
    } catch (e) {
      print('Error al modificar cuenta: $e');
      rethrow; // Re-lanza el error para que se pueda manejar en la UI
    }
  }

  // Nuevo método para calcular el balance total
  double calcularBalanceTotal() {
    double balanceTotal = 0;
    for (var cuenta in _cuentas) {
      balanceTotal += cuenta.saldo;
    }
    return balanceTotal;
  }

  // Método modificado para calcular el balance a partir de una lista de cuentas
  double calcularBalanceTotal2(List<Cuenta> cuentas) {
    double balanceTotal = 0;
    for (var cuenta in cuentas) {
      balanceTotal += cuenta.saldo;
    }
    return balanceTotal;
  }
  // Stream para escuchar los cambios en las cuentas y calcular el balance
  Stream<double> calcularBalanceTotalStream(String userEmail) {
    return _firebaseService.obtenerCuentasStream(userEmail).map((cuentas) {
      return calcularBalanceTotal2(cuentas);
    });
  }
  // Método para eliminar una cuenta
  Future<void> eliminarCuenta(String idCuenta, String userEmail) async {
    try {
      await _firebaseService.eliminarCuenta(idCuenta);
      print("Cuenta eliminada con éxito.");
      await cargarCuentas(userEmail); // Recarga la lista de cuentas
    } catch (e) {
      print("Error al eliminar cuenta: $e");
      throw e;
    }
  }
}
