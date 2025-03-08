import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moni/views/widgets/CustomButton.dart';
import 'package:moni/views/widgets/CustomDropdown.dart';
import 'package:provider/provider.dart';
import 'package:moni/models/clases/income_offers.dart';
import 'package:moni/controllers/income_offers_controller.dart';
import 'package:moni/controllers/user_controller.dart';

class AddIncomeOfferPage extends StatefulWidget {
  @override
  _AddIncomeOfferPageState createState() => _AddIncomeOfferPageState();
}

class _AddIncomeOfferPageState extends State<AddIncomeOfferPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _pagoController = TextEditingController();
  final TextEditingController _tipoMonedaController = TextEditingController(text: 'USD');

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);
    final offersController = Provider.of<IncomeOffersController>(context);
    final userEmail = userController.usuario?.email;
    final userPhoneNumber = userController.usuario?.phone_number;

    if (userEmail == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Publicar Oferta de Ingreso'),
        backgroundColor: Colors.grey[200],
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título
              Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(10.0),
                color: const Color.fromARGB(217, 217, 217, 217),
                child: TextFormField(
                  controller: _tituloController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.receipt),
                    labelText: 'Título',
                    labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
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
              SizedBox(height: 14),
              // Descripción (opcional)
              Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(10.0),
                color: const Color.fromARGB(217, 217, 217, 217),
                child: TextFormField(
                  controller: _descripcionController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.description),
                    labelText: 'Descripción',
                    labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16.0),
                  ),
                  keyboardType: TextInputType.multiline,
                ),
              ),
              SizedBox(height: 14),
              // Monto
              Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(10.0),
                color: const Color.fromARGB(217, 217, 217, 217),
                child: TextFormField(
                  controller: _pagoController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.money),
                    labelText: 'Monto a pagar',
                    labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16.0),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^[0-9\.]+$')),
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
              SizedBox(height: 14),
              // Tipo de moneda (CustomDropdown con el valor y el controlador)
              CustomDropdown(
                controller: _tipoMonedaController,
                onChanged: (value) {
                  setState(() {
                    _tipoMonedaController.text = value!;
                  });
                },
                labelText: 'Tipo de moneda',
                icon: Icons.monetization_on,
                items: ['BS', 'USD', 'EUR', 'MXN'],
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      IncomeOffers nuevaOferta = IncomeOffers(
                        email: userEmail,
                        titulo: _tituloController.text,
                        descripcion: _descripcionController.text.isEmpty ? "" : _descripcionController.text, // Si está vacía, asigna ""
                        pago: double.parse(_pagoController.text),
                        estado: 'Disponible',
                        phoneNumber: userPhoneNumber, // Usar el número del usuario
                        tipoMoneda: _tipoMonedaController.text,
                      );

                      offersController.agregarIncomeOffer(nuevaOferta);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Oferta de ingreso publicada con éxito.')),
                      );

                      Navigator.pop(context);
                    }
                  },
                  text: 'PUBLICAR OFERTA',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Limpiar controladores al destruir el widget
    _tituloController.dispose();
    _descripcionController.dispose();
    _pagoController.dispose();
    super.dispose();
  }
}
