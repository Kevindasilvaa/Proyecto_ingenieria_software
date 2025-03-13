import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moni/models/dbHelper/firebase_service.dart';
import 'package:moni/models/clases/income_offers.dart';

class IncomeOffersController with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  List<IncomeOffers> _incomeOffers = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  IncomeOffers? _savedIncomeOffers;


  List<IncomeOffers> get incomeOffers => _incomeOffers;

  // Cargar ofertas de ingreso por email de usuario
  Future<void> cargarIncomeOffersPorUsuario(String userEmail) async {
    _incomeOffers =
        await _firebaseService.obtenerIncomeOffersPorUsuario(userEmail);
    notifyListeners();
  }

  // Agregar una oferta de ingreso
  Future<void> agregarIncomeOffer(IncomeOffers incomeOffer) async {
    await _firebaseService.agregarIncomeOffer(incomeOffer);
    await cargarTodasLasIncomeOffers(); // Recargar todas las ofertas
  }

  // Modificar una oferta de ingreso
  Future<void> modificarIncomeOffer(IncomeOffers incomeOffer) async {
    try {
      await _firebaseService.modificarIncomeOffer(incomeOffer);
      await cargarTodasLasIncomeOffers(); // Recargar todas las ofertas
    } catch (e) {
      print('Error al modificar oferta de ingreso: $e');
      rethrow;
    }
  }

  // Eliminar una oferta de ingreso
  Future<void> eliminarIncomeOffer(String idOferta, String userEmail) async {
    try {
      await _firebaseService.eliminarIncomeOffer(idOferta);
      await cargarTodasLasIncomeOffers(); // Recargar todas las ofertas
    } catch (e) {
      print('Error al eliminar oferta de ingreso: $e');
      rethrow;
    }
  }

  Future<void> cargarTodasLasIncomeOffers() async {
    try {
      _incomeOffers = await _firebaseService.obtenerTodasIncomeOffers();
      notifyListeners(); // Notifica a la vista que los datos han cambiado
    } catch (e) {
      print('Error al cargar todas las ofertas: $e');
    }
  }




Future<IncomeOffers?> getIncomeOfferById(String id) async {
  try {
    final snapshot = await _firestore
        .collection('income_offers')
        .where('id_oferta_de_trabajo', isEqualTo: id)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return IncomeOffers.fromMap(snapshot.docs.first.data() as Map<String, dynamic>);
    } else {
      return null; // Return null if no matching document is found
    }
  } catch (e) {
    print('Error getting IncomeOffer: $e');
    return null; 
  }
}




}
