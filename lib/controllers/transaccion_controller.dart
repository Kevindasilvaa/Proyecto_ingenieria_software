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

  Future<void> agregarTransaccion(Transaccion transaccion) async {
    try {
      await _firestore.collection('transaction').add(transaccion.toMap());
    } catch (e) {
      print('Error al agregar transacción: $e');
    }
  }
}