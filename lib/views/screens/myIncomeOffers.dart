import 'dart:async';
import 'package:flutter/material.dart';
import 'package:moni/controllers/income_offers_controller.dart';
import 'package:moni/controllers/user_controller.dart';
import 'package:moni/models/clases/income_offers.dart';
import 'package:moni/views/widgets/CustomDrawer.dart';
import 'package:moni/views/widgets/NavBar.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moni/views/screens/AddIncomeOffer.dart';

class MyIncomeOffersPage extends StatefulWidget {
  @override
  State<MyIncomeOffersPage> createState() => _MyIncomeOffersPageState();
}

class _MyIncomeOffersPageState extends State<MyIncomeOffersPage> {
  List<IncomeOffers> _incomeOffers = [];
  StreamSubscription? _incomeOffersSubscription;
  final IncomeOffersController _incomeOffersController =
      IncomeOffersController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarIncomeOffersInicial();
    _iniciarStream();
  }

  @override
  void dispose() {
    _incomeOffersSubscription?.cancel();
    super.dispose();
  }

  Future<void> _cargarIncomeOffersInicial() async {
    final userController = Provider.of<UserController>(context, listen: false);
    if (userController.usuario == null) {
      setState(() {
        _isLoading = true;
      });
      await Future.delayed(Duration(seconds: 2));
    }

    if (userController.usuario != null) {
      try {
        await _incomeOffersController
            .cargarIncomeOffersPorUsuario(userController.usuario!.email);
        setState(() {
          _incomeOffers = _incomeOffersController.incomeOffers;
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error al cargar las ofertas.'),
          duration: Duration(seconds: 2),
        ));
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _iniciarStream() {
    final userController = Provider.of<UserController>(context, listen: false);
    if (userController.usuario != null) {
      _incomeOffersSubscription?.cancel();
      _incomeOffersSubscription = _incomeOffersController
          .cargarIncomeOffersPorUsuario(userController.usuario!.email)
          .asStream()
          .listen((_) {
        setState(() {
          _incomeOffers = _incomeOffersController.incomeOffers;
        });
      }, onError: (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error al actualizar las ofertas.'),
          duration: Duration(seconds: 2),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);
    final userEmail = userController.usuario?.email;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[50],
        title: Text('Mis Ofertas de Ingreso'),
      ),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          if (_isLoading) LinearProgressIndicator(),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Sección "Mis Ofertas" con el botón de agregar
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Mis Ofertas',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  if (userEmail != null) {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AddIncomeOfferPage(),
                                      ),
                                    );
                                    await _cargarIncomeOffersInicial();
                                    _iniciarStream();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Inicia sesión para agregar ofertas'),
                                          duration: Duration(seconds: 2)),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[200],
                                  foregroundColor: Colors.black87,
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.add,
                                        color: Colors.black87, size: 25),
                                    SizedBox(width: 6),
                                    Text('Agregar',
                                        style: TextStyle(fontSize: 18)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        userEmail != null
                            ? _buildIncomeOfferList(_incomeOffers, false)
                            : Center(
                                child: Text(
                                    'Inicia sesión para ver tus ofertas de ingreso')),

                        // Separador visual
                        Divider(
                          color: Colors.grey,
                          thickness: 1,
                          height: 40,
                        ),

                        // Sección "Ofertas Guardadas"
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Ofertas Guardadas',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        _buildSavedIncomeOffersStream(),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeOfferList(List<IncomeOffers> incomeOffers, bool isSaved) {
    if (incomeOffers.isEmpty) {
      return Center(
        child: Text(
          isSaved
              ? 'No tienes ofertas guardadas.'
              : 'No hay ofertas de ingreso registradas.',
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
      );
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: incomeOffers.map((incomeOffer) {
          return Container(
            width: 360,
            child: _buildIncomeOfferContainer(incomeOffer, isSaved),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSavedIncomeOffersStream() {
    final userController = Provider.of<UserController>(context, listen: false);
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userController.usuario?.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.exists) {
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final savedOffersIds =
              List<String>.from(userData['saved_offers'] ?? []);
          return FutureBuilder<List<IncomeOffers>>(
            future: _fetchSavedOffers(savedOffersIds),
            builder: (context, offersSnapshot) {
              if (offersSnapshot.hasData) {
                return _buildIncomeOfferList(offersSnapshot.data!, true);
              } else if (offersSnapshot.hasError) {
                return Center(child: Text('Error al cargar ofertas guardadas'));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          );
        } else {
          return Center(child: Text('No hay ofertas guardadas') as Widget);
        }
      },
    );
  }

  Future<List<IncomeOffers>> _fetchSavedOffers(
      List<String> savedOffersIds) async {
    List<IncomeOffers> savedOffers = [];
    for (String offerId in savedOffersIds) {
      IncomeOffers? offer =
          await _incomeOffersController.getIncomeOfferById(offerId);
      if (offer != null) {
        savedOffers.add(offer);
      }
    }
    return savedOffers;
  }

  Widget _buildIncomeOfferContainer(IncomeOffers incomeOffer, bool isSaved) {
    String formatText(String text) {
      if (text.isEmpty) return text; // Manejo de texto vacío
      return text[0].toUpperCase() + text.substring(1).toLowerCase();
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 124, 124, 124).withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      // Definimos un tamaño fijo con `SizedBox` o mediante `height`.
      child: SizedBox(
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatText(incomeOffer.titulo),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                if (!isSaved)
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red, size: 25),
                        onPressed: () => _confirmarEliminacion(incomeOffer),
                      ),
                    ],
                  ),
              ],
            ),
            SizedBox(height: 6),
            // Mostrar el contacto (aplica para guardadas y no guardadas)
            Text(
              'Contacto: ${incomeOffer.email}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 6),
            // Mostrar la descripción completa
            Expanded(
              child: Text(
                formatText(incomeOffer.descripcion),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  overflow: TextOverflow.ellipsis, // Manejo de texto largo
                ),
                maxLines:
                    8, // Fija el número máximo de líneas para evitar desbordes
              ),
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
                          fontSize: 14,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSaved ? Colors.orange[50] : Colors.green[50],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: isSaved ? Colors.orange : Colors.green,
                        width: 2),
                  ),
                  child: Text(
                    isSaved ? 'Guardado' : incomeOffer.estado,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isSaved ? Colors.orange[600] : Colors.green[600],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmarEliminacion(IncomeOffers incomeOffer) {
    final userController = Provider.of<UserController>(context, listen: false);
    final offersController =
        Provider.of<IncomeOffersController>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmar eliminación"),
          content: Text(
              "¿Seguro que desea eliminar la oferta '${incomeOffer.titulo}'?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Eliminar"),
              onPressed: () async {
                await offersController
                    .eliminarIncomeOffer(
                        incomeOffer.idOfertaDeTrabajo, incomeOffer.email)
                    .then((_) async {
                  Navigator.of(context).pop();
                  _cargarIncomeOffersInicial();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('Oferta de ingreso eliminada exitosamente')),
                  );
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al eliminar la oferta')),
                  );
                });
              },
            ),
          ],
        );
      },
    );
  }
}
