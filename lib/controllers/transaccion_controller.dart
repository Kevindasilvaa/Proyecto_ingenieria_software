import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moni/models/clases/transaccion.dart';

class TransaccionesController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Transaccion>> obtenerTransaccionesUsuario() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? _user = _auth.currentUser; // Obtiene el usuario actual (puede ser nulo)

    if (_user == null) { // Verifica si el usuario es nulo
      return []; // Retorna una lista vacía si no hay usuario
    }

    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('transaction')
          .where('user_id', isEqualTo: _user.uid) // Usa _user.uid
          .get();

      List<Transaccion> transacciones = [];
      for (var doc in querySnapshot.docs) {
        transacciones.add(Transaccion.fromMap(doc.data() as Map<String, dynamic>, doc.id));
      }
      return transacciones;
    } catch (e) {
      print('Error al obtener transacciones: $e');
      return [];
    }
  }

  Future<void> agregarTransaccion(Transaccion transaccion) async {
    try {
      await _firestore.collection('transaction').add(transaccion.toMap());
    } catch (e) {
      print('Error al agregar transacción: $e');
    }
  }
}