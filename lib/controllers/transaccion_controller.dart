import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moni/controllers/cuenta_controller.dart';
import 'package:moni/models/clases/cuenta.dart';
import 'package:moni/models/clases/transaccion.dart';

class TransaccionesController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Transaccion>> obtenerTransaccionesUsuarioStream() {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? _user = _auth.currentUser;

    if (_user == null) {
      return Stream.empty(); // Retorna un stream vacío si no hay usuario
    }

    return _firestore
        .collection('transaction')
        .where('user_id', isEqualTo: _user.uid)
        .snapshots() // Escucha los cambios en tiempo real
        .map((snapshot) {
      List<Transaccion> transacciones = [];
      for (var doc in snapshot.docs) {
        transacciones.add(Transaccion.fromMap(doc.data() as Map<String, dynamic>, doc.id));
      }
      return transacciones;
    });
  }

    Stream<List<Transaccion>> obtenerTransaccionesDeUnDia(DateTime fecha) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? _user = _auth.currentUser;

    if (_user == null) {
      return Stream.empty();
    }

      // Obtener el inicio del día (00:00:00)
      DateTime fechaInicio = DateTime(fecha.year, fecha.month, fecha.day);

      // Obtener el final del día (23:59:59) - Usamos el día siguiente y luego restamos 1 milisegundo.
      DateTime fechaFin = DateTime(fecha.year, fecha.month, fecha.day + 1).subtract(Duration(milliseconds: 1));

      return _firestore
          .collection('transaction')
          .where('user_id', isEqualTo: _user.uid)
          .where('fecha', isGreaterThanOrEqualTo: fechaInicio) // Filtra desde el inicio del día
          .where('fecha', isLessThan: fechaFin) // Filtra hasta el final del día
          .snapshots()
            .map((snapshot) {
      List<Transaccion> transacciones = [];
      for (var doc in snapshot.docs) {
        transacciones.add(Transaccion.fromMap(doc.data() as Map<String, dynamic>, doc.id));
      }
      return transacciones;
    });
  }
  

  Future<void> agregarTransaccion(Transaccion transaccion) async {
    try {
      await _firestore.collection('transaction').add(transaccion.toMap());
    } catch (e) {
      print('Error al agregar transacción: $e');
    }
  }

  Future<void> modificarTransaccion(Transaccion updatedTransaccion, Transaccion oldTransaccion) async {
    if(updatedTransaccion.monto != oldTransaccion.monto || updatedTransaccion.ingreso != oldTransaccion.ingreso) {
      final CuentaController _cuentaController = CuentaController();

      // Consultar la cuenta correspondiente a la transacción
      final cuentaQuerySnapshot = await _firestore
          .collection('accounts')
          .where('idCuenta', isEqualTo: updatedTransaccion.cuenta_id) // Buscar el documento de la cuenta
          .limit(1)  // Limitar a un solo documento
          .get();

      if (cuentaQuerySnapshot.docs.isEmpty) {
        print('No se encuentra la cuenta con el idCuenta proporcionado.');
        return;
      }

      // Obtener la cuenta actual de la base de datos
      final cuentaDoc = cuentaQuerySnapshot.docs.first;
      Map<String, dynamic> cuentaData = cuentaDoc.data() as Map<String, dynamic>;
      final cuenta = Cuenta.fromMap(cuentaData);

      // Determinar si la nueva transacción es un ingreso o un egreso
      bool esIngresoNuevo = updatedTransaccion.ingreso ?? false;
      bool esIngresoViejo = oldTransaccion.ingreso ?? false;

      // Primero, eliminamos el saldo de la transacción anterior:
      double saldoTemporal = cuenta.saldo;

      // Si la transacción anterior era un ingreso, restamos su monto del saldo
      saldoTemporal = esIngresoViejo ? saldoTemporal - oldTransaccion.monto : saldoTemporal + oldTransaccion.monto;

      // Ahora, agregamos el monto de la nueva transacción
      saldoTemporal = esIngresoNuevo ? saldoTemporal + updatedTransaccion.monto : saldoTemporal - updatedTransaccion.monto;

      // Crear la cuenta modificada con el nuevo saldo
      final cuentaModificada = Cuenta(
        idCuenta: cuenta.idCuenta, // Mantener el mismo idCuenta
        nombre: cuenta.nombre,
        saldo: saldoTemporal, // Asignar el nuevo saldo calculado
        tipo: cuenta.tipo,
        userEmail: cuenta.userEmail,
        fechaCreacion: cuenta.fechaCreacion,
        tipoMoneda: cuenta.tipoMoneda,
      );

      // Actualizar la cuenta en Firestore con el nuevo saldo
      await _cuentaController.modificarCuenta(cuentaModificada);

      // Finalmente, actualizar la transacción en Firestore
      try {
        await _firestore
            .collection('transaction')
            .doc(updatedTransaccion.id) // Usar el ID de la transacción para actualizarla
            .update(updatedTransaccion.toMap()); // Actualizar con los nuevos datos
      } catch (e) {
        print('Error al modificar transacción: $e');
      }
    } else {
      // Si no hay cambios en el monto o tipo de transacción, solo actualizamos la transacción
      try {
        await _firestore
            .collection('transaction')
            .doc(updatedTransaccion.id) // Usar el ID de la transacción
            .update(updatedTransaccion.toMap()); // Actualizar con el mapa de datos de la transacción
      } catch (e) {
        print('Error al modificar transacción: $e');
      }
    }
  }


   Future<void> eliminarTransaccion(Transaccion transaccion) async {
    final CuentaController _cuentaController = CuentaController();
    try {

      // Realizar una consulta en la colección 'accounts' para obtener el documento que tenga el idCuenta
      final cuentaQuerySnapshot = await _firestore
          .collection('accounts')
          .where('idCuenta', isEqualTo: transaccion.cuenta_id)  // Buscar el documento donde idCuenta coincide
          .limit(1)  // Limitar a un solo documento
          .get();

      if (cuentaQuerySnapshot.docs.isEmpty) {
        print('No se encuentra la cuenta con el idCuenta proporcionado.');
        return;
      }

      // Obtener el primer documento de la consulta
      final cuentaDoc = cuentaQuerySnapshot.docs.first;

      // Convertir los datos de la cuenta en un mapa
      Map<String, dynamic> cuentaData = cuentaDoc.data() as Map<String, dynamic>;

      // Crear la cuenta con los datos obtenidos y el idCuenta ya disponible
      final cuenta = Cuenta.fromMap(cuentaData);

      // Obtener el monto de la transacción eliminada
      double montoTransaccion = (transaccion.monto as num).toDouble();

      // Determinar si la transacción es un ingreso o un egreso
      bool esIngreso = transaccion.ingreso ?? false; // Asumimos que 'esIngreso' es un campo booleano

      // Calcular el nuevo saldo
      double nuevoSaldo = esIngreso
          ? cuenta.saldo - montoTransaccion  // Si es ingreso, restamos el monto
          : cuenta.saldo + montoTransaccion; // Si es egreso, sumamos el monto

      // Crear una copia de la cuenta con el nuevo saldo
      final cuentaModificada = Cuenta(
        idCuenta: cuenta.idCuenta, // Se mantiene el idCuenta original
        nombre: cuenta.nombre,
        saldo: nuevoSaldo,
        tipo: cuenta.tipo,
        userEmail: cuenta.userEmail,
        fechaCreacion: cuenta.fechaCreacion,
        tipoMoneda: cuenta.tipoMoneda,
      );

      // Modificar la cuenta en Firestore
      await _cuentaController.modificarCuenta(cuentaModificada);

      // Ahora podemos eliminar la transacción de Firestore
      await _firestore.collection('transaction').doc(transaccion.id).delete();

    } catch (e) {
      print('Error al eliminar transacción: $e');
    }
  }

  
}