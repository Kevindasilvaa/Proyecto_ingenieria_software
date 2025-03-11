import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moni/models/clases/Usuario.dart'; // Importa la clase User
import 'package:moni/models/clases/cuenta.dart';
import 'dart:math';

import 'package:moni/models/clases/income_offers.dart';

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
          monthlyIncomeBudget: data['monthlyIncomeBudget']
              ?.toDouble(), // Obtener el presupuesto de ingreso mensual
          monthlyExpenseBudget: data['monthlyExpenseBudget']
              ?.toDouble(), // Obtener el presupuesto de gasto mensual
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

// AGREGAR UNA CUENTA A FIRESTORE
  Future<void> agregarCuenta(Cuenta cuenta) async {
    try {
      await _firestore
          .collection('accounts')
          .add(cuenta.toMap()); // Agregar cuenta
    } catch (e) {
      print('Error al agregar cuenta: $e');
      rethrow;
    }
  }

  // OBTENER LAS CUENTAS DE UN USUARIO
  Future<List<Cuenta>> obtenerCuentas(String userEmail) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('accounts')
          .where('userEmail', isEqualTo: userEmail) // Filtrar por email
          .get();

      return snapshot.docs
          .map((doc) => Cuenta.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error al obtener cuentas: $e');
      rethrow;
    }
  }

  // OBTENER LAS CUENTAS DE UN USUARIO (ESCUCHANDO CAMBIOS)
  Stream<List<Cuenta>> obtenerCuentasStream(String userEmail) {
    try {
      return _firestore
          .collection('accounts')
          .where('userEmail', isEqualTo: userEmail)
          .snapshots() // Usamos snapshots() para escuchar cambios
          .map((snapshot) => snapshot.docs
              .map((doc) => Cuenta.fromMap(doc.data() as Map<String, dynamic>))
              .toList());
    } catch (e) {
      print('Error al obtener cuentas: $e');
      return Stream.error(e); // Retornamos un Stream de error
    }
  }

  Future<void> modificarCuenta(Cuenta cuenta) async {
    try {
      // 1. Obtener la referencia a la colección de cuentas
      final accountsRef = _firestore.collection('accounts');

      // 2. Buscar el documento que tenga el atributo `idCuenta` que coincide con `cuenta.idCuenta`
      final querySnapshot = await accountsRef
          .where('idCuenta',
              isEqualTo: cuenta.idCuenta) // Filtro por el atributo idCuenta
          .get();

      if (querySnapshot.docs.isEmpty) {
        // Si no se encuentra ningún documento con el idCuenta proporcionado
        print(
            'No se encontró ninguna cuenta con el idCuenta: ${cuenta.idCuenta}');
        return; // Salir del método si no se encuentra el documento
      }

      // 3. Obtener el primer documento de la consulta (suponiendo que solo debería haber uno)
      final docRef = querySnapshot.docs.first.reference;

      // 4. Actualizar el documento con los datos de la cuenta
      await docRef.update(cuenta.toMap());

      print(
          'Cuenta modificada en Firestore: ${cuenta.idCuenta}'); // Mensaje de éxito
    } catch (e) {
      print('Error al modificar cuenta en Firestore: $e');
      rethrow; // Re-lanza el error para que se pueda manejar en el controlador
    }
  }

  // ELIMINAR UNA CUENTA DE FIRESTORE
  Future<void> eliminarCuenta(String idCuenta) async {
    try {
      // 1. Buscar el documento que tenga el atributo `idCuenta`
      QuerySnapshot querySnapshot = await _firestore
          .collection('accounts')
          .where('idCuenta', isEqualTo: idCuenta)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print('No se encontró ninguna cuenta con idCuenta: $idCuenta');
        return;
      }

      // 2. Obtener la referencia del primer documento encontrado y eliminarlo
      await querySnapshot.docs.first.reference.delete();

      print('Cuenta eliminada exitosamente');
    } catch (e) {
      print('Error al eliminar cuenta: $e');
      throw e;
    }
  }

  // OBTENER TODAS LAS OFERTAS DE INGRESO
  Future<List<IncomeOffers>> obtenerTodasIncomeOffers() async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection('income_offers').get();
      print('Documentos encontrados: ${snapshot.docs.length}');
      return snapshot.docs
          .map(
              (doc) => IncomeOffers.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error al obtener todas las ofertas de ingreso: $e');
      throw e;
    }
  }

  // OBTENER LAS OFERTAS DE INGRESO DE UN USUARIO
  Future<List<IncomeOffers>> obtenerIncomeOffersPorUsuario(
      String userEmail) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('income_offers')
          .where('email', isEqualTo: userEmail)
          .get();

      return snapshot.docs
          .map(
              (doc) => IncomeOffers.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error al obtener ofertas de ingreso: $e');
      rethrow;
    }
  }

  // AGREGAR UNA OFERTA DE INGRESO A FIRESTORE
  Future<void> agregarIncomeOffer(IncomeOffers incomeOffer) async {
    try {
      await _firestore.collection('income_offers').add(incomeOffer.toMap());
    } catch (e) {
      print('Error al agregar oferta de ingreso: $e');
      rethrow;
    }
  }

  // MODIFICAR UNA OFERTA DE INGRESO EN FIRESTORE
  Future<void> modificarIncomeOffer(IncomeOffers incomeOffer) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('income_offers')
          .where('id_oferta_de_trabajo',
              isEqualTo: incomeOffer.idOfertaDeTrabajo)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print(
            'No se encontró ninguna oferta de ingreso con id: ${incomeOffer.idOfertaDeTrabajo}');
        return;
      }

      await querySnapshot.docs.first.reference.update(incomeOffer.toMap());
      print(
          'Oferta de ingreso modificada en Firestore: ${incomeOffer.idOfertaDeTrabajo}');
    } catch (e) {
      print('Error al modificar oferta de ingreso en Firestore: $e');
      rethrow;
    }
  }

  // ELIMINAR UNA OFERTA DE INGRESO DE FIRESTORE
  Future<void> eliminarIncomeOffer(String idOferta) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('income_offers')
          .where('id_oferta_de_trabajo', isEqualTo: idOferta)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print('No se encontró ninguna oferta de ingreso con id: $idOferta');
        return;
      }

      await querySnapshot.docs.first.reference.delete();
      print('Oferta de ingreso eliminada exitosamente');
    } catch (e) {
      print('Error al eliminar oferta de ingreso: $e');
      rethrow;
    }
  }
}
