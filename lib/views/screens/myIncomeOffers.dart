import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moni/controllers/income_offers_controller.dart';
import 'package:moni/controllers/user_controller.dart';
import 'package:moni/models/clases/income_offers.dart';
import 'package:moni/views/widgets/CustomDrawer.dart';
import 'package:moni/views/widgets/NavBar.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    final offersController = Provider.of<IncomeOffersController>(context);
    final userEmail = userController.usuario?.email;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E4A5A), // Fondo azul oscuro
        title: const Text(
          'Mis Ofertas de Ingreso',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white), // Texto blanco
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          if (_isLoading)
            const LinearProgressIndicator(
              color: Color(0xFF5DA6A7), // Indicador de progreso en verde
              backgroundColor: Color(0xFFB0BEC5), // Fondo gris claro
            ),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF5DA6A7), // Indicador de carga en verde
                    ),
                  )
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
                              const Text(
                                'Mis Ofertas',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black, // Texto blanco
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (userEmail != null) {
                                    _showAddIncomeOfferDialog(context, userController,offersController);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Inicia sesión para agregar ofertas'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF5DA6A7), // Fondo verde
                                  foregroundColor: Colors.black,
                                ),
                                child: Row(
                                  children: const [
                                    Icon(Icons.add, color: Colors.white, size: 25), // Ícono blanco
                                    SizedBox(width: 6),
                                    Text(
                                      'Agregar',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white, // Texto blanco
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        userEmail != null
                            ? _buildIncomeOfferList(_incomeOffers, false)
                            : const Center(
                                child: Text(
                                  'Inicia sesión para ver tus ofertas de ingreso',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),

                        // Separador visual
                        const Divider(
                          color: Color(0xFFB0BEC5), // Color gris oscuro más visible
                          thickness: 1.5, // Grosor ajustado para mejor visibilidad
                          height: 40, // Altura del separador
                        ),

                        // Sección "Ofertas Guardadas"
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Ofertas Guardadas',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
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
        backgroundColor: const Color(0xFF2E4A5A), // Fondo azul
        title: const Text(
          "Confirmar eliminación",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // Texto blanco
        ),
        content: Text(
          "¿Seguro que desea eliminar la oferta '${incomeOffer.titulo}'?",
          style: const TextStyle(color: Colors.white), // Texto blanco
        ),
        actions: <Widget>[
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.transparent), // Fondo transparente
            ),
            child: const Text(
              "Cancelar",
              style: TextStyle(color: Colors.white), // Texto blanco
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(const Color(0xFFF44336)), // Fondo rojo
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // Bordes redondeados
                ),
              ),
            ),
            child: const Text(
              "Eliminar",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // Texto blanco
            ),
            onPressed: () async {
              await offersController
                  .eliminarIncomeOffer(
                      incomeOffer.idOfertaDeTrabajo, incomeOffer.email)
                  .then((_) async {
                Navigator.of(context).pop();
                _cargarIncomeOffersInicial();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Oferta de ingreso eliminada exitosamente')),
                );
              }).catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error al eliminar la oferta')),
                );
              });
            },
          ),
        ],
      );
    },
  );
}
void _showAddIncomeOfferDialog(BuildContext context, UserController userController,
    IncomeOffersController offersController) {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _pagoController = TextEditingController();
  final TextEditingController _tipoMonedaController =
      TextEditingController(text: 'USD');

  final userEmail = userController.usuario?.email;
  final userPhoneNumber = userController.usuario?.phone_number;

  if (userEmail == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Inicia sesión para agregar ofertas')),
    );
    return;
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF2E4A5A), // Fondo azul oscuro
            title: const Center(
              child: Text(
                'Publicar Oferta de Ingreso',
                style: TextStyle(
                  color: Colors.white, // Texto blanco
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9, // Ancho ajustado
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título
                      Material(
                        elevation: 4.0,
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white, // Fondo blanco del campo
                        child: TextFormField(
                          controller: _tituloController,
                          decoration: const InputDecoration(
                            prefixIcon:
                                Icon(Icons.title, color: Colors.black),
                            labelText: 'Título',
                            labelStyle: TextStyle(color: Colors.black),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16.0),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'El título es obligatorio';
                            }
                            return null;
                          },
                        ),
                      ),

                      const SizedBox(height: 16),
                        // Descripción
                      Material(
                        elevation: 4.0,
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white, // Fondo blanco del campo
                        child: TextFormField(
                          controller: _descripcionController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.description, color: Colors.black), // Ícono negro
                            labelText: 'Descripción',
                            labelStyle: TextStyle(color: Colors.black), // Texto del label en negro
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16.0), // Espaciado interno
                          ),
                          style: const TextStyle(color: Colors.black), // Texto ingresado en negro
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'La descripción es obligatoria';
                            }
                            return null;
                          },
                        ),
                      ),

                     const SizedBox(height: 16),
                      // Monto
                      Material(
                        elevation: 4.0,
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                        child: TextFormField(
                          controller: _pagoController,
                          decoration: const InputDecoration(
                            prefixIcon:
                                Icon(Icons.money, color: Colors.black),
                            labelText: 'Monto a pagar',
                            labelStyle: TextStyle(color: Colors.black),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16.0),
                          ),
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^[0-9\.]+$')),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'El monto es obligatorio';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Ingrese un monto válido';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Tipo de moneda
                      Material(
                        elevation: 4.0,
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                        child: DropdownButtonFormField<String>(
                          value: _tipoMonedaController.text,
                          onChanged: (value) {
                            setState(() {
                              _tipoMonedaController.text = value!;
                            });
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.monetization_on,
                                color: Colors.black),
                            labelText: 'Tipo de moneda',
                            labelStyle: TextStyle(color: Colors.black),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16.0),
                          ),
                          items: ['BS', 'USD', 'EUR', 'MXN']
                              .map((moneda) => DropdownMenuItem(
                                    value: moneda,
                                    child: Text(moneda),
                                  ))
                              .toList(),
                        ),
                      ),
                    
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(const Color(0xFF5DA6A7)), // Fondo verde
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final nuevaOferta = IncomeOffers(
                      email: userEmail,
                      titulo: _tituloController.text,
                      descripcion: _descripcionController.text.isEmpty
                          ? ""
                          : _descripcionController.text,
                      pago: double.parse(_pagoController.text),
                      estado: 'Disponible',
                      phoneNumber: userPhoneNumber,
                      tipoMoneda: _tipoMonedaController.text,
                    );

                    offersController.agregarIncomeOffer(nuevaOferta);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Oferta de ingreso publicada con éxito.')),
                    );

                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  'Publicar',
                  style: TextStyle(color: Colors.white), // Texto negro
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

}
