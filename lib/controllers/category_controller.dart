import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moni/models/clases/category.dart';

class CategoryController with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Método para agregar una categoría a Firestore
  Future<void> addCategory(String name, String icon, Color color) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final categoryRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('categoria')
        .doc();

    final category = Category(
      id: categoryRef.id,
      name: name,
      icon: icon,
      color: color,
    );

    await categoryRef.set(category.toMap());
  }

  // Método para eliminar una categoría de Firestore
  Future<void> deleteCategory(String id) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('categories')
        .doc(id)
        .delete();
  }

  // Método que devuelve un Stream para obtener categorías en tiempo real
  Stream<List<Category>> categoriesStream() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('categoria')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Category.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }
}
