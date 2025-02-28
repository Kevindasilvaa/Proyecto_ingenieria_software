import 'package:flutter/material.dart';
import 'package:moni/controllers/user_controller.dart';
import 'package:provider/provider.dart';
import 'package:moni/views/widgets/NavBar.dart';
import 'package:moni/views/widgets/CustomDrawer.dart';
import 'package:moni/views/widgets/MonthSelector.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:moni/controllers/transaccion_controller.dart';
import 'package:moni/models/clases/transaccion.dart';

class StatisticsPage extends StatefulWidget {
  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  bool _ingreso = true;
  DateTime _selectedDate = DateTime.now();
  TransaccionesController _transaccionesController = TransaccionesController();

  List<PieChartSectionData> _pieChartSections = [];

  @override
  void initState() {
    super.initState();
    _updatePieChartData();
  }

  void _updatePieChartData() async {
    List<Transaccion> transacciones = await _getFilteredTransactions();
    Map<String, double> categoriasMontos = {};

    for (var transaccion in transacciones) {
      if (categoriasMontos.containsKey(transaccion.categoria_id)) {
        categoriasMontos[transaccion.categoria_id] =
            (categoriasMontos[transaccion.categoria_id] ?? 0) + transaccion.monto;
      } else {
        categoriasMontos[transaccion.categoria_id] = transaccion.monto;
      }
    }

    List<PieChartSectionData> sections = [];
    categoriasMontos.forEach((categoria, monto) {
      sections.add(PieChartSectionData(
        color: Color((categoria.hashCode * 0xFFFFFF).toInt()).withOpacity(1.0),
        value: monto,
        title: categoria,
        radius: 50,
      ));
    });

    setState(() {
      _pieChartSections = sections;
    });
  }

  Future<List<Transaccion>> _getFilteredTransactions() async {
    DateTime firstDayOfMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
    DateTime lastDayOfMonth = DateTime(_selectedDate.year, _selectedDate.month + 1, 0);

    return await _transaccionesController
        .obtenerTransaccionesUsuarioStream()
        .first
        .then((transacciones) => transacciones
            .where((transaccion) =>
                transaccion.ingreso == _ingreso &&
                transaccion.fecha.isAfter(firstDayOfMonth.subtract(Duration(days: 1))) &&
                transaccion.fecha.isBefore(lastDayOfMonth.add(Duration(days: 1))))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Text('Estadísticas'),
      ),
      drawer: CustomDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(45),
                  bottomRight: Radius.circular(45),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _ingreso = true;
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 150),
                        padding: EdgeInsets.only(left: 35, right: 35, top: 5, bottom: 5),
                        decoration: BoxDecoration(
                          color: _ingreso
                              ? Colors.green.withOpacity(0.7)
                              : const Color.fromARGB(255, 205, 205, 205),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Ingreso',
                          style: TextStyle(fontSize: 22),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _ingreso = false;
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 150),
                        padding: EdgeInsets.only(left: 35, right: 35, top: 5, bottom: 5),
                        decoration: BoxDecoration(
                          color: !_ingreso
                              ? Colors.red.withOpacity(0.7)
                              : Color.fromARGB(255, 205, 205, 205),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Gasto',
                          style: TextStyle(fontSize: 22),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: MonthSelector(
                onMonthChanged: (DateTime newDate) {
                  setState(() {
                    _selectedDate = newDate;
                    _updatePieChartData();
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 245, 245, 245),
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 124, 124, 124).withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ]
                ),
                child: PieChart(
                  PieChartData(
                    sections: _pieChartSections,
                    centerSpaceRadius: 40,
                    sectionsSpace: 0,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text("Relleno"),
              ),
            ),
            Container(
              height: 80.0,
              child: NavBar(
                onPlusPressed: () {
                  Navigator.of(context).pushNamed('/addTransactions');
                },
                currentPage: '/statistics',
              ),
            ),
          ],
        ),
      ),
    );
  }
}