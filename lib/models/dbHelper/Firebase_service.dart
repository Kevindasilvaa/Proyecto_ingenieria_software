import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moni/models/clases/Usuario.dart'; // Importa la clase User
import 'package:moni/models/clases/cuenta.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

//Almacena el usuario en Firestore
  Future<void> saveUserInFirestore(Usuario user) async {
    // Recibe User
    try {
      Map<String, dynamic> userData = user.toMap();

      await _firestore.collection('users').doc(user.id).set(userData);
      print('Usuario creado exitosamente');
    } catch (e) {
      print('Error al crear usuario: $e');
      rethrow;
    }
  }

  Future<Usuario?> getUserByEmail(String email) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot snapshot = querySnapshot.docs.first;
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        return Usuario(
          id: snapshot.id,
          name: data['name'],
          email: data['email'],
          gender: data['gender'],
          birthdate: data['birthdate'] != null
              ? (data['birthdate'] as Timestamp).toDate()
              : null,
          country: data['country'],
          phone_number: data['phone_number'],
        );
      } else {
        return null;
      }
    } catch (e) {
      print('Error al buscar usuario por email: $e');
      rethrow;
    }
  }

  // Método para iniciar sesión
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('Error en el inicio de sesión: ${e.message}');
      return null;
    }
  }

  // Método de cierre de sesión
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Método para crear una cuenta en Firebase Authentification
  Future<Usuario?> createUserAuthentification(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Crear el usuario
      Usuario newUser = Usuario(
        id: userCredential.user!.uid,
        name: null,
        email: email,
        gender: null,
        birthdate: null,
        country: null,
        phone_number: null,
      );
      return newUser;
    } on FirebaseAuthException catch (e) {
      print('Error en la creación de cuenta: ${e.message}');
      return null;
    }
  }

//  AGREGAR UNA CUENTA A FIRESTORE
  Future<void> agregarCuenta(String userId, Cuenta cuenta) async {
    try {
      await _firestore
          .collection('accounts') // Colección principal de cuentas
          .doc(userId) // Documento del usuario
          .collection('user_accounts') // Subcolección de cuentas del usuario
          .add(cuenta.toMap()); // Agregar cuenta
    } catch (e) {
      print('Error al agregar cuenta: $e');
      rethrow;
    }
  }

  //OBTENER LAS CUENTAS DE UN USUARIO
  Future<List<Cuenta>> obtenerCuentas(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('accounts')
          .doc(userId)
          .collection('user_accounts')
          .get();

      return snapshot.docs
          .map((doc) =>
              Cuenta.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error al obtener cuentas: $e');
      rethrow;
    }
  }
}
