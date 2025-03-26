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
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Cargar las ofertas cuando se inicia la página
    final incomeOffersController =
        Provider.of<IncomeOffersController>(context, listen: false);
    final userController = Provider.of<UserController>(context, listen: false);

    // Obtener el correo del usuario actual
    final userEmail = userController.usuario?.email;

    if (userEmail != null) {
      // Cargar solo las ofertas que no fueron publicadas por el usuario actual
      incomeOffersController.cargarIncomeOffersSinPublicadasPorMi(userEmail);
    } else {
      // Si no hay un usuario autenticado, cargar todas las ofertas como fallback
      incomeOffersController.cargarTodasLasIncomeOffers();
    }
  }

  @override
  void dispose() {
    _searchController.dispose(); // Liberar recursos del controlador
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final incomeOffersController = Provider.of<IncomeOffersController>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E4A5A), // Fondo azul oscuro
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Buscar ofertas...',
            hintStyle: const TextStyle(
                color: Colors.white70), // Texto de hint en blanco translúcido
            border: InputBorder.none,
            prefixIcon:
                const Icon(Icons.search, color: Colors.white), // Ícono blanco
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
          style:
              const TextStyle(color: Colors.white), // Texto ingresado en blanco
          onChanged: (value) {
            incomeOffersController
                .filtrarIncomeOffers(value); // Filtra las ofertas
          },
        ),
        iconTheme: const IconThemeData(
            color: Colors.white), // Íconos del AppBar en blanco
      ),
      drawer: CustomDrawer(),
      body: Consumer<IncomeOffersController>(
        builder: (context, controller, child) {
          final incomeOffers = controller.incomeOffers;

          if (incomeOffers.isEmpty) {
            return Center(
                child: Text('No hay ofertas que coincidan con la búsqueda.'));
          }

          return ListView.builder(
            itemCount: incomeOffers.length,
            itemBuilder: (context, index) {
              final incomeOffer = incomeOffers[index];
              return _buildIncomeOfferContainer(incomeOffer);
            },
          );
        },
      ),
    );
  }

  Widget _buildIncomeOfferContainer(IncomeOffers incomeOffer) {
    String formatText(String text) {
      if (text.isEmpty) return text; // Manejo de texto vacío
      return text[0].toUpperCase() + text.substring(1).toLowerCase();
    }

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
                  formatText(incomeOffer.titulo), // Capitaliza el título
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(Provider.of<UserController>(context, listen: false)
                        .usuario
                        ?.id)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.exists) {
                    final userData =
                        snapshot.data!.data() as Map<String, dynamic>;
                    final savedOffers =
                        List<dynamic>.from(userData['saved_offers'] ?? []);
                    final isSaved =
                        savedOffers.contains(incomeOffer.idOfertaDeTrabajo);
                    return IconButton(
                      icon: Icon(
                        isSaved ? Icons.bookmark : Icons.bookmark_border,
                      ),
                      onPressed: () async {
                        if (isSaved) {
                          await _removeOfferFromSaved(
                              context, incomeOffer.idOfertaDeTrabajo);
                        } else {
                          await _addOfferToSaved(
                              context, incomeOffer.idOfertaDeTrabajo);
                        }
                      },
                    );
                  } else {
                    return IconButton(
                      icon: Icon(
                        Icons.bookmark_border,
                        color: Colors.yellow[700],
                      ),
                      onPressed: () async {
                        await _addOfferToSaved(
                            context, incomeOffer.idOfertaDeTrabajo);
                      },
                    );
                  }
                },
              ),
            ],
          ),
          SizedBox(height: 6),
          // Mostrar la descripción completa
          Text(
            formatText(incomeOffer.descripcion),
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          SizedBox(height: 6),
          // Mostrar el contacto
          Text(
            'Contacto: ${incomeOffer.email}', // Mostrar el nombre del contacto
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blueAccent[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blueAccent, width: 2),
                ),
                child: Row(
                  children: [
                    Icon(Icons.attach_money, color: Colors.blueAccent),
                    SizedBox(width: 4),
                    Text(
                      '${incomeOffer.pago.toStringAsFixed(2)} ${incomeOffer.tipoMoneda}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14, // Ajustado para coherencia
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _addOfferToSaved(BuildContext context, String offerId) async {
    final userController = Provider.of<UserController>(context, listen: false);
    final userId = userController.usuario?.id;

    if (userId != null) {
      try {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
        if (userSnapshot.exists) {
          Map<String, dynamic> userData =
              userSnapshot.data() as Map<String, dynamic>;
          List<dynamic> savedOffers = List.from(userData['saved_offers'] ?? []);

          if (!savedOffers.contains(offerId)) {
            savedOffers.add(offerId);

            await FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .update({'saved_offers': savedOffers});
          }
        }
      } catch (e) {
        print('Error al guardar oferta: $e');
      }
    }
  }

  Future<void> _removeOfferFromSaved(
      BuildContext context, String offerId) async {
    final userController = Provider.of<UserController>(context, listen: false);
    final userId = userController.usuario?.id;

    if (userId != null) {
      try {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
        if (userSnapshot.exists) {
          Map<String, dynamic> userData =
              userSnapshot.data() as Map<String, dynamic>;
          List<dynamic> savedOffers = List.from(userData['saved_offers'] ?? []);

          if (savedOffers.contains(offerId)) {
            savedOffers.remove(offerId);

            await FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .update({'saved_offers': savedOffers});
          }
        }
      } catch (e) {
        print('Error al eliminar oferta: $e');
      }
    }
  }
}
