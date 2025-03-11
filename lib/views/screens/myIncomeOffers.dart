import 'dart:async';
import 'package:flutter/material.dart';
import 'package:moni/controllers/income_offers_controller.dart';
import 'package:moni/controllers/user_controller.dart';
import 'package:moni/models/clases/income_offers.dart';
import 'package:moni/views/widgets/CustomDrawer.dart';
import 'package:moni/views/widgets/NavBar.dart';
import 'package:provider/provider.dart';
import 'package:moni/views/screens/AddIncomeOffer.dart'; // Asegúrate de tener la página de modificación.

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
          if (_isLoading)
            LinearProgressIndicator(),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (userEmail != null) {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddIncomeOfferPage(),
                                ),
                              );
                              await _cargarIncomeOffersInicial();
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
                          padding: EdgeInsets.symmetric(vertical: 18, horizontal: 32),
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
                                child: Text('Inicia sesión para ver tus ofertas de ingreso')),
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
    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.blueGrey.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 6,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fila con el título pegado a la izquierda y los iconos pegados a la derecha
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Título pegado a la izquierda
            Text(
              incomeOffer.titulo,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
            ),
            // Iconos pegados a la derecha
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red, size: 30),
                  onPressed: () => _confirmarEliminacion(incomeOffer),
                ),
              ],
            ),
          ],
        ),
        //SizedBox(height: 2),
        // Detalles adicionales
        ExpansionTile(
          title: Text(
            'Más detalles',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey[600]),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                incomeOffer.descripcion,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        // Sección para mostrar el monto y el disponible de forma estilizada
        Row(
          children: [
            // Monto con icono y estilo visual atractivo
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blueAccent[50], // Fondo suave azul
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blueAccent, width: 2),
              ),
              child: Row(
                children: [
                  Icon(Icons.attach_money, color: Colors.blueAccent),
                  SizedBox(width: 4),
                  Text(
                    '${incomeOffer.pago} ${incomeOffer.tipoMoneda}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            // Estado con color y formato llamativo
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green[50], // Fondo suave verde
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green, width: 2),
              ),
              child: Text(
                incomeOffer.estado,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green[600],
                  fontSize: 16,
                ),
              ),
            ),
          ],
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
                  Navigator.of(context).pop();
                  _cargarIncomeOffersInicial();
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


