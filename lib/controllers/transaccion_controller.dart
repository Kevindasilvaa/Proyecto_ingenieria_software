import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

    Future<void> modificarTransaccion(Transaccion transaccion) async {
    try {
      await _firestore
          .collection('transaction')
          .doc(transaccion.id) // Usa el ID de la transacción
          .update(transaccion.toMap()); // Actualiza con el mapa
    } catch (e) {
      print('Error al modificar transacción: $e');
    }
  }

   Future<void> eliminarTransaccion(String transaccionId) async {
    try {
      await _firestore.collection('transaction').doc(transaccionId).delete();
    } catch (e) {
      print('Error al eliminar transacción: $e');
    }
  }

  
}