import 'package:flutter/material.dart';
import 'package:moni/models/dbHelper/firebase_service.dart';
import 'package:moni/models/clases/income_offers.dart';

class IncomeOffersController with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  List<IncomeOffers> _incomeOffers = [];

  List<IncomeOffers> get incomeOffers => _incomeOffers;

  // Cargar todas las ofertas de ingreso
  Future<void> cargarTodasIncomeOffers() async {
    _incomeOffers = await _firebaseService.obtenerTodasIncomeOffers();
    notifyListeners();
  }

  // Cargar ofertas de ingreso por email de usuario
  Future<void> cargarIncomeOffersPorUsuario(String userEmail) async {
    _incomeOffers = await _firebaseService.obtenerIncomeOffersPorUsuario(userEmail);
    notifyListeners();
  }

  // Agregar una oferta de ingreso
  Future<void> agregarIncomeOffer(IncomeOffers incomeOffer) async {
    await _firebaseService.agregarIncomeOffer(incomeOffer);
    await cargarTodasIncomeOffers(); // Recargar todas las ofertas
  }

  // Modificar una oferta de ingreso
  Future<void> modificarIncomeOffer(IncomeOffers incomeOffer) async {
    try {
      await _firebaseService.modificarIncomeOffer(incomeOffer);
      await cargarTodasIncomeOffers(); // Recargar todas las ofertas
    } catch (e) {
      print('Error al modificar oferta de ingreso: $e');
      rethrow;
    }
  }

  // Eliminar una oferta de ingreso
  Future<void> eliminarIncomeOffer(String idOferta, String userEmail) async {
    try {
      await _firebaseService.eliminarIncomeOffer(idOferta);
      await cargarTodasIncomeOffers(); // Recargar todas las ofertas
    } catch (e) {
      print('Error al eliminar oferta de ingreso: $e');
      rethrow;
    }
  }
}