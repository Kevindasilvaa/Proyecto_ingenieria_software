import 'package:firebase_auth/firebase_auth.dart';
import 'package:moni/models/dbHelper/firebase_service.dart';
import 'package:moni/models/clases/Usuario.dart';
import 'package:flutter/material.dart';

class UserController with ChangeNotifier {  // Cambié esto a "with ChangeNotifier"
  final FirebaseService _firebaseService = FirebaseService();

  // Aquí se guarda el usuario actual
  Usuario? _usuario;

  // Getter para acceder al usuario
  Usuario? get usuario => _usuario;

  bool _isListening = false; // Flag para evitar registro repetido

  // Escuchar cambios en el estado de autenticación y actualizar la variable usuario
  void startAuthListener(BuildContext context) {
    if (_isListening) return;  // No registrar el listener si ya está registrado
    _isListening = true;  // Marcar que el listener está activo

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
        final user = await getUserByEmail(firebaseUser.email!); // Traer datos adicionales del usuario
        _usuario = user;
      }

      // Notificar a los listeners para actualizar la UI
      notifyListeners();
    });
  }

  // Setter para actualizar el usuario
  set usuario(Usuario? nuevoUsuario) {
    _usuario = nuevoUsuario;
    notifyListeners();  // Notifica a los listeners (ejemplo: UI) que el usuario ha cambiado
  }

  // Crea un usuario en FirebaseAuthentification y lo almacena en Firestore, siempre y cuando las credenciales sean validas
  Future<Usuario?> createUser(String email, String password) async {
    try {
      Usuario? user = await _firebaseService.createUserAuthentification(email, password);
      if(user != null){
        await _firebaseService.saveUserInFirestore(user);
        _usuario = user;
        notifyListeners();  // Notifica que el usuario ha iniciado sesion
        return user;
      }else{
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
      return user;  // Retornar el usuario encontrado
    } catch (e) {
      print('Error en UserController al obtener usuario por email: $e');
      rethrow;
    }
  }

  // Iniciar sesión usando el servicio de autenticación de firebase
  Future<void> signIn(String email, String password) async {
    try {
      // Usar el servicio para autenticar con Firebase
      User? firebaseUser = await _firebaseService.signInWithEmailPassword(email, password);

      if (firebaseUser != null) {
        // Aquí creas el usuario para tu aplicación a partir de los datos de Firebase
        final user = await getUserByEmail(firebaseUser.email!); // Traer datos adicionales del usuario
        _usuario = user;
        notifyListeners();  // Notifica que el usuario ha sido actualizado
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
      notifyListeners();  // Notifica que el usuario ha cerrado sesión
    } catch (e) {
      print('Error al cerrar sesión: $e');
      rethrow;
    }
  }
}