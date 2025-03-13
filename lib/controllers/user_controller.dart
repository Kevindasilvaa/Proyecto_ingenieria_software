import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:moni/models/dbHelper/firebase_service.dart';
import 'package:moni/models/clases/Usuario.dart';
import 'package:flutter/material.dart';

class UserController with ChangeNotifier {
  // Cambié esto a "with ChangeNotifier"
  final FirebaseService _firebaseService = FirebaseService();

  // Aquí se guarda el usuario actual
  Usuario? _usuario;

  // Getter para acceder al usuario
  Usuario? get usuario => _usuario;

  bool _isListening = false; // Flag para evitar registro repetido

  // Escuchar cambios en el estado de autenticación y actualizar la variable usuario
  void startAuthListener(BuildContext context) {
    if (_isListening) return; // No registrar el listener si ya está registrado
    _isListening = true; // Marcar que el listener está activo

    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    // El listener de los cambios de estado de autenticación
    _firebaseAuth.authStateChanges().listen((User? firebaseUser) async {
      if (firebaseUser == null) {
        // El usuario ha cerrado sesión
        print("El usuario cerró sesión");
        _usuario = null;
      } else {
        // El usuario ha iniciado sesión
        print("El usuario inició sesión");
        final user = await getUserByEmail(
            firebaseUser.email!); // Traer datos adicionales del usuario
        _usuario = user;
      }

      // Notificar a los listeners para actualizar la UI
      notifyListeners();
    });
  }

  // Setter para actualizar el usuario
  set usuario(Usuario? nuevoUsuario) {
    _usuario = nuevoUsuario;
    notifyListeners(); // Notifica a los listeners (ejemplo: UI) que el usuario ha cambiado
  }

  // Crea un usuario en FirebaseAuthentification y lo almacena en Firestore, siempre y cuando las credenciales sean validas
  Future<Usuario?> createUser(String email, String password) async {
    try {
      Usuario? user =
          await _firebaseService.createUserAuthentification(email, password);
      if (user != null) {
        await _firebaseService.saveUserInFirestore(user);
        _usuario = user;
        notifyListeners(); // Notifica que el usuario ha iniciado sesion
        return user;
      } else {
        return null;
      }
    } catch (e) {
      print('Error en UserController al crear usuario: $e');
      rethrow;
    }
  }

  // Método para obtener un usuario por email de Firestore
  Future<Usuario?> getUserByEmail(String email) async {
    try {
      // Llamar al método del servicio de firebase para obtener el usuario
      Usuario? user = await _firebaseService.getUserByEmail(email);
      return user; // Retornar el usuario encontrado
    } catch (e) {
      print('Error en UserController al obtener usuario por email: $e');
      rethrow;
    }
  }

  // Iniciar sesión usando el servicio de autenticación de firebase
  Future<void> signIn(String email, String password) async {
    try {
      // Usar el servicio para autenticar con Firebase
      User? firebaseUser =
          await _firebaseService.signInWithEmailPassword(email, password);

      if (firebaseUser != null) {
        // Aquí creas el usuario para tu aplicación a partir de los datos de Firebase
        final user = await getUserByEmail(
            firebaseUser.email!); // Traer datos adicionales del usuario
        _usuario = user;
        notifyListeners(); // Notifica que el usuario ha sido actualizado
      }
    } catch (e) {
      print('Error al iniciar sesión: $e');
      rethrow;
    }
  }

  // Cerrar sesión
  Future<void> logOut() async {
    try {
      await _firebaseService.signOut();
      _usuario = null;
      notifyListeners(); // Notifica que el usuario ha cerrado sesión
    } catch (e) {
      print('Error al cerrar sesión: $e');
      rethrow;
    }
  }

  // En user_controller.dart
  Future<void> actualizarUsuarioEnFirestore(Usuario usuario) async {
    try {
      await FirebaseFirestore.instance
          .collection('users') // Reemplaza 'users' con tu colección
          .doc(usuario.id)
          .update(usuario.toMap()); // Usa el método toMap de tu clase Usuario
    } catch (e) {
      print('Error al actualizar usuario en Firestore: $e');
      rethrow; // Re-lanza el error para que se pueda manejar en la UI
    }
  }

  // Este metodo funciona tanto para Iniciar sesion como para crear una cuenta
  Future<void> signInWithGoogle() async {
    try {
      // 1. Iniciar sesión con Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // 2. Obtener las credenciales de autenticación de Google
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // 3. Crear una credencial de Firebase con las credenciales de Google
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // 4. Autenticarse con Firebase usando la credencial
      final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      // 5. Obtener el usuario de Firebase
      User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        // 6. Verificar si el usuario ya existe en Firestore
        final userDoc = await FirebaseFirestore.instance
            .collection('users') // Reemplaza 'users' con tu colección
            .doc(firebaseUser.uid)
            .get();

        if (!userDoc.exists) {
          // 7. Si el usuario es nuevo, crearlo en Firestore
          final newUser = Usuario(
            id: firebaseUser.uid,
            email: firebaseUser?.email ?? '',
            name: firebaseUser.displayName ?? '',
          );
          await FirebaseFirestore.instance
              .collection('users')
              .doc(newUser.id)
              .set(newUser.toMap());

          _usuario = newUser; // Actualiza _usuario con el nuevo usuario
        } else {
          // 8. Si el usuario ya existe, obtener sus datos de Firestore
          final user = await getUserByEmail(firebaseUser.email!);
          _usuario = user; // Actualiza _usuario con el usuario existente
        }

        notifyListeners(); // Notifica que el usuario ha sido actualizado
      }
    } catch (e) {
      print('Error al iniciar sesión con Google: $e');
      rethrow; // Re-lanza el error para que se pueda manejar en la UI
    }
  }

  Future<void> updateMonthlyExpenseBudget(double newBudget) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(usuario!.id)
        .update({'monthlyExpenseBudget': newBudget});

    // Creamos una nueva instancia del usuario con el presupuesto actualizado
    usuario = Usuario(
      id: usuario!.id,
      email: usuario!.email,
      name: usuario!.name,
      gender: usuario!.gender,
      birthdate: usuario!.birthdate,
      country: usuario!.country,
      phone_number: usuario!.phone_number,
      monthlyIncomeBudget: usuario!.monthlyIncomeBudget,
      monthlyExpenseBudget: newBudget,
    );
    notifyListeners();
  }
}
