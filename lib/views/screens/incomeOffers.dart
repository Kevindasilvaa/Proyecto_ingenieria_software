import 'package:moni/views/widgets/CustomDrawer.dart';
import 'package:flutter/material.dart';
import 'package:moni/controllers/income_offers_controller.dart';
import 'package:moni/models/clases/income_offers.dart';

class IncomeOffersPage extends StatefulWidget {
  @override
  _IncomeOffersPageState createState() => _IncomeOffersPageState();
}

class _IncomeOffersPageState extends State<IncomeOffersPage> {
  List<IncomeOffers> _incomeOffers = [];
  final IncomeOffersController _incomeOffersController =
      IncomeOffersController();
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
          Text(
            incomeOffer.titulo,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 5),
          Text(incomeOffer.descripcion),
          SizedBox(height: 8),
          Text('Pago: \$${incomeOffer.pago.toStringAsFixed(2)}'),
          Text(
              'Publicado por: ${incomeOffer.email}'), //OPCIONAL lo podemos quitar
        ],
      ),
    );
  }
}
