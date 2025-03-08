import 'dart:async';
import 'package:flutter/material.dart';
import 'package:moni/controllers/income_offers_controller.dart';
import 'package:moni/controllers/user_controller.dart';
import 'package:moni/models/clases/income_offers.dart';
import 'package:moni/views/widgets/CustomButton.dart';
import 'package:moni/views/widgets/CustomDrawer.dart';
import 'package:moni/views/widgets/NavBar.dart';
import 'package:provider/provider.dart';
import 'package:moni/views/screens/AddIncomeOffer.dart';

class MyIncomeOffersPage extends StatefulWidget {
  @override
  State<MyIncomeOffersPage> createState() => _MyIncomeOffersPageState();
}

class _MyIncomeOffersPageState extends State<MyIncomeOffersPage> {
  List<IncomeOffers> _incomeOffers = [];
  StreamSubscription? _incomeOffersSubscription;
  final IncomeOffersController _incomeOffersController = IncomeOffersController();
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

  // Este método asegura que el usuario esté disponible antes de cargar las ofertas
  Future<void> _cargarIncomeOffersInicial() async {
    final userController = Provider.of<UserController>(context, listen: false);
    
    // Si el usuario no está cargado, esperamos hasta que se cargue
    if (userController.usuario == null) {
      setState(() {
        _isLoading = true; // Indicamos que estamos esperando el usuario
      });
      // Esperamos un poco para que el estado del usuario pueda ser cargado.
      await Future.delayed(Duration(seconds: 2));
    }

    if (userController.usuario != null) {
      try {
        await _incomeOffersController
            .cargarIncomeOffersPorUsuario(userController.usuario!.email);
        setState(() {
          _incomeOffers = _incomeOffersController.incomeOffers;
          _isLoading = false; // Terminamos de cargar las ofertas
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
        _isLoading = false; // Terminamos de esperar
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
        backgroundColor: Colors.grey[200],
        title: Text('Mis Ofertas de Ingreso'),
      ),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          // Barra de carga en la parte superior mientras esperamos al usuario
          if (_isLoading)
            LinearProgressIndicator(),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator()) // Indicador en el centro mientras carga
                : Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child:
                      ElevatedButton(
                        onPressed: () async {
                                    if (userEmail != null) {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AddIncomeOfferPage()),
                                      );
                                      await _cargarIncomeOffersInicial(); // Esperamos a que se recarguen las ofertas
                                      _iniciarStream();
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text('Inicia sesión para agregar ofertas'),
                                        duration: Duration(seconds: 2),
                                      ));
                                    }
                                  },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Publicar Oferta de Ingreso',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ),
                      Expanded(
                        child: userEmail != null
                            ? _buildIncomeOfferList(_incomeOffers)
                            : Center(
                                child: Text(
                                    'Inicia sesión para ver tus ofertas de ingreso')),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeOfferList(List<IncomeOffers> incomeOffers) {
    if (incomeOffers.isEmpty) {
      return Center(child: Text('No hay ofertas de ingreso registradas.'));
    }
    return ListView.builder(
      itemCount: incomeOffers.length,
      itemBuilder: (context, index) {
        final incomeOffer = incomeOffers[index];
        return _buildIncomeOfferContainer(incomeOffer);
      },
    );
  }

  Widget _buildIncomeOfferContainer(IncomeOffers incomeOffer) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                incomeOffer.titulo,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text('Pago: ${incomeOffer.pago} ${incomeOffer.tipoMoneda}'),
              Text('Estado: ${incomeOffer.estado}'),
            ],
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => _confirmarEliminacion(incomeOffer),
          ),
        ],
      ),
    );
  }

  void _confirmarEliminacion(IncomeOffers incomeOffer) {
    final userController = Provider.of<UserController>(context, listen: false);
    final offersController = Provider.of<IncomeOffersController>(context, listen: false);
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
                    .eliminarIncomeOffer(incomeOffer.idOfertaDeTrabajo, incomeOffer.email)
                    .then((_) async {
                  Navigator.of(context).pop(); // Cerrar el diálogo
                  _cargarIncomeOffersInicial(); // recargar las ofertas
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Oferta de ingreso eliminada exitosamente')),
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