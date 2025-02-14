// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:moni/models/clases/category.dart';

// class CategoryController with ChangeNotifier {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   // Método para agregar una categoría a Firestore
//   Future<void> addCategory(String name, String icon, Color color) async {
//     final user = _auth.currentUser;
//     if (user == null) return;

//     final categoryRef = _firestore
//         .collection('users')
//         .doc(user.uid)
//         .collection('categoria')
//         .doc();

//     final category = Category(
//       id: categoryRef.id,
//       name: name,
//       icon: icon,
//       color: color,
//     );

//     await categoryRef.set(category.toMap());
//   }

//   // Método para eliminar una categoría de Firestore
//   Future<void> deleteCategory(String id) async {
//     final user = _auth.currentUser;
//     if (user == null) return;

//     await _firestore
//         .collection('users')
//         .doc(user.uid)
//         .collection('categories')
//         .doc(id)
//         .delete();
//   }

//   // Método que devuelve un Stream para obtener categorías en tiempo real
//   Stream<List<Category>> categoriesStream() {
//     final user = _auth.currentUser;
//     if (user == null) {
//       return Stream.value([]);
//     }

//     return _firestore
//         .collection('users')
//         .doc(user.uid)
//         .collection('categoria')
//         .snapshots()
//         .map((snapshot) {
//       return snapshot.docs.map((doc) {
//         return Category.fromMap(doc.data(), doc.id);
//       }).toList();
//     });
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moni/models/clases/category.dart';

class CategoryController with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addCategory(String name, String icon, Color color) async {
  try {
    print("Intentando agregar categoría...");
    final user = _auth.currentUser;
    if (user == null) {
      print("No se encontró el usuario autenticado.");
      return;
    }

    final categoryRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('categorias') // Mantén la consistencia en el nombre
        .doc();

    final category = Category(
      id: categoryRef.id,
      name: name,
      icon: icon,
      color: color,
      user_email: user.email ?? 'all_users@domain.com', // Email por defecto
    );

    // Intentar agregar la categoría
    await _firestore.collection('categorias').add(category.toMap());
    print("Categoría agregada correctamente.");
  } catch (e) {
    print("Error al agregar categoría: $e");
  }
}


  // // Método para eliminar una categoría de Firestore
  // Future<void> deleteCategory(String id) async {
  //   final user = _auth.currentUser;
  //   if (user == null) return;

  //   await _firestore
  //       .collection('users')
  //       .doc(user.uid)
  //       .collection('categorias') // Aseguramos que el nombre sea el mismo que en el resto del código
  //       .doc(id)
  //       .delete();
  // }
  // Método para eliminar una categoría de Firestore
  Future<void> deleteCategory(String id) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print("No se encontró el usuario autenticado.");
        return;
      }

      // Eliminamos la categoría de la colección principal "categorias"
      await _firestore
          .collection('categorias') // Aquí accedemos a la colección principal "categorias"
          .doc(id) // Usamos el id de la categoría a eliminar
          .delete();

      print("Categoría eliminada correctamente.");
    } catch (e) {
      print("Error al eliminar la categoría: $e");
    }
  }


  // // Método que devuelve un Stream para obtener categorías en tiempo real
  Stream<List<Category>> categoriesStream() {
  final user = _auth.currentUser;
  if (user == null) {
    return Stream.empty(); // Retorna un stream vacío si no hay usuario
  }

  // Stream para categorías del usuario actual
  final userCategoriesStream = _firestore
      .collection('categorias')
      .where('user_email', isEqualTo: user.email)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      return Category.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  });

  // Stream para categorías de "all_users@domain.com"
  final allUsersCategoriesStream = _firestore
      .collection('categorias')
      .where('user_email', isEqualTo: 'all_users@domain.com')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      return Category.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  });

  // Combina ambos streams
  return Stream<List<Category>>.multi((controller) {
    final userCategories = <Category>[];
    final allUsersCategories = <Category>[];

    // Escucha el stream de categorías del usuario
    final userStreamSub = userCategoriesStream.listen((categories) {
      userCategories.clear();
      userCategories.addAll(categories);
      controller.add([...userCategories, ...allUsersCategories]);  // Emitir la lista combinada
    });

    // Escucha el stream de categorías de "all_users@domain.com"
    final allUsersStreamSub = allUsersCategoriesStream.listen((categories) {
      allUsersCategories.clear();
      allUsersCategories.addAll(categories);
      controller.add([...userCategories, ...allUsersCategories]);  // Emitir la lista combinada
    });

    // Limpiar los streams cuando el Stream se cierre
    controller.onCancel = () {
      userStreamSub.cancel();
      allUsersStreamSub.cancel();
    };
  });
}
Future<Category?> getCategoryById(String id) async {
  final user = _auth.currentUser;
  if (user == null) return null;

  try {
    final doc = await _firestore
        .collection('categorias') // Aquí accedemos a la colección "categorias"
        .doc(id)
        .get();

    if (!doc.exists) return null;

    return Category.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  } catch (e) {
    print("Error al obtener la categoría: $e");
    return null;
  }
}


}
