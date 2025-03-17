import 'package:moni/views/widgets/CustomDrawer.dart';
import 'package:flutter/material.dart';
import 'package:moni/controllers/income_offers_controller.dart';
import 'package:moni/models/clases/income_offers.dart';
import 'package:moni/controllers/user_controller.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IncomeOffersPage extends StatefulWidget {
  @override
  _IncomeOffersPageState createState() => _IncomeOffersPageState();
}

class _IncomeOffersPageState extends State<IncomeOffersPage> {
  List<IncomeOffers> _incomeOffers = [];
  final IncomeOffersController _incomeOffersController = IncomeOffersController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarIncomeOffersInicial();
  }

  Future<void> _cargarIncomeOffersInicial() async {
    try {
      await _incomeOffersController.cargarTodasLasIncomeOffers();
      setState(() {
        _incomeOffers = _incomeOffersController.incomeOffers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error al cargar ofertas: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar las ofertas.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Text('Ofertas de Ingreso Disponibles'),
      ),
      drawer: CustomDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _incomeOffers.isEmpty
              ? Center(child: Text('No hay ofertas disponibles.'))
              : ListView.builder(
                  itemCount: _incomeOffers.length,
                  itemBuilder: (context, index) {
                    final incomeOffer = _incomeOffers[index];
                    return _buildIncomeOfferContainer(incomeOffer);
                  },
                ),
    );
  }

  Widget _buildIncomeOfferContainer(IncomeOffers incomeOffer) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 7, horizontal: 25),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  incomeOffer.titulo,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(Provider.of<UserController>(context, listen: false).usuario?.id)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.exists) {
                    final userData = snapshot.data!.data() as Map<String, dynamic>;
                    final savedOffers = List<dynamic>.from(userData['saved_offers'] ?? []);
                    final isSaved = savedOffers.contains(incomeOffer.idOfertaDeTrabajo);
                    return IconButton(
                      icon: Icon(
                        isSaved ? Icons.bookmark : Icons.bookmark_border,
                      ),
                      onPressed: () async {
                        if (isSaved) {
                          await _removeOfferFromSaved(context, incomeOffer.idOfertaDeTrabajo);
                        } else {
                          await _addOfferToSaved(context, incomeOffer.idOfertaDeTrabajo);
                        }
                      },
                    );
                  } else {
                    return IconButton(
                      icon: Icon(Icons.bookmark_border),
                      onPressed: () async {
                        await _addOfferToSaved(context, incomeOffer.idOfertaDeTrabajo);
                      },
                    );
                  }
                },
              ),
            ],
          ),
          SizedBox(height: 5),
          Text(incomeOffer.descripcion),
          SizedBox(height: 8),
          Text('Pago: \$${incomeOffer.pago.toStringAsFixed(2)}'),
          Text('Contacto: ${incomeOffer.email}'),
        ],
      ),
    );
  }

  Future<void> _addOfferToSaved(BuildContext context, String offerId) async {
    final userController = Provider.of<UserController>(context, listen: false);
    final userId = userController.usuario?.id;

    if (userId != null) {
      try {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
        if (userSnapshot.exists) {
          Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
          List<dynamic> savedOffers = List.from(userData['saved_offers'] ?? []);

       

          if (!savedOffers.contains(offerId)) {
            savedOffers.add(offerId);

            await FirebaseFirestore.instance.collection('users').doc(userId).update({'saved_offers': savedOffers});

            // print('Oferta guardada: $offerId');
            // print(savedOffers);
          }
        }
      } catch (e) {
        print('Error al guardar oferta: $e');
      }
    }
  }

  Future<void> _removeOfferFromSaved(BuildContext context, String offerId) async {
    final userController = Provider.of<UserController>(context, listen: false);
    final userId = userController.usuario?.id;

    if (userId != null) {
      try {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
        if (userSnapshot.exists) {
          Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
          List<dynamic> savedOffers = List.from(userData['saved_offers'] ?? []);

          // print('Lista guardada antes de eliminar: $savedOffers');

          if (savedOffers.contains(offerId)) {
            savedOffers.remove(offerId);

            await FirebaseFirestore.instance.collection('users').doc(userId).update({'saved_offers': savedOffers});

            // print('Oferta eliminada: $offerId');
            // print(savedOffers);
          }
        }
      } catch (e) {
        print('Error al eliminar oferta: $e');
      }
    }
  }
}