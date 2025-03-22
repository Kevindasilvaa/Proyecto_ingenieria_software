// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:moni/controllers/user_controller.dart';
// import 'package:moni/views/widgets/TransactionCard.dart';
// import 'package:provider/provider.dart';
// import 'package:moni/views/widgets/NavBar.dart';
// import 'package:moni/views/widgets/CustomDrawer.dart';
// import 'package:moni/views/widgets/MonthSelector.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:moni/controllers/transaccion_controller.dart';
// import 'package:moni/models/clases/transaccion.dart';
// import 'package:moni/controllers/category_controller.dart';
// import 'package:moni/models/clases/category.dart';

// class StatisticsPage extends StatefulWidget {
//   @override
//   State<StatisticsPage> createState() => _StatisticsPageState();
// }

// class _StatisticsPageState extends State<StatisticsPage> {
//   bool _ingreso = true;
//   DateTime _selectedDate = DateTime.now();
//   TransaccionesController _transaccionesController = TransaccionesController();
//   CategoryController _categoryController = CategoryController();
//   List<Category> _categorias = [];

//   List<PieChartSectionData> _pieChartSections = [];
//   List<Transaccion> _transaccionesFiltradas = []; // Lista de transacciones filtradas

//   @override
//   void initState() {
//     super.initState();
//     _updatePieChartData();
//     _cargarCategorias();
//   }

//   Future<void> _cargarCategorias() async {
//     final categoryController = Provider.of<CategoryController>(context, listen: false);
//     categoryController.categoriesStream().listen((categories) {
//       setState(() {
//         _categorias = categories;
//       });
//     });
//   }

//   void _updatePieChartData() async {
//   List<Transaccion> transacciones = await _getFilteredTransactions();
//   Map<String, double> categoriasMontos = {};

//   for (var transaccion in transacciones) {
//     if (categoriasMontos.containsKey(transaccion.categoria_id)) {
//       categoriasMontos[transaccion.categoria_id] =
//           (categoriasMontos[transaccion.categoria_id] ?? 0) + transaccion.monto;
//     } else {
//       categoriasMontos[transaccion.categoria_id] = transaccion.monto;
//     }
//   }

//   List<PieChartSectionData> sections = [];
//   final categoryController = Provider.of<CategoryController>(context, listen: false);

//   if (categoriasMontos.isEmpty) {
//     // No hay transacciones, muestra un pie chart vacío
//     sections.add(PieChartSectionData(
//       color: Colors.grey, // Color gris para indicar vacío
//       value: 1, 
//       title: "No hay datos",
//       radius: 50,
//     ));
//   } else {
//     // Hay transacciones, construye las secciones del pie chart
//     for (var entry in categoriasMontos.entries) {
//       String categoriaId = entry.key;
//       double monto = entry.value;

//       Category? categoria = await categoryController.getCategoryById(categoriaId);
      

//       sections.add(PieChartSectionData(
//        // color: Color((categoriaId.hashCode * 0xFFFFFF).toInt()).withOpacity(1.0),
//         color: categoria!.color,
//         value: monto,
//         title: categoria!.name,
//         radius: 50,
//         titleStyle: TextStyle( // Estilo para las categorías
//          // color: Colors.white,
//           fontSize: 12,
//           fontWeight: FontWeight.w500,
//         ),
//       ));
//     }
//   }

//   setState(() {
//     _pieChartSections = sections;
//   });
// }

//   Future<List<Transaccion>> _getFilteredTransactions() async {
//     DateTime firstDayOfMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
//     DateTime lastDayOfMonth = DateTime(_selectedDate.year, _selectedDate.month + 1, 0);

//     List<Transaccion> transacciones = await _transaccionesController
//         .obtenerTransaccionesUsuarioStream()
//         .first;

//     // Filtrar las transacciones según la fecha y el tipo de transacción (_ingreso)
//     List<Transaccion> filteredTransacciones = transacciones
//         .where((transaccion) =>
//             transaccion.ingreso == _ingreso &&
//             transaccion.fecha.isAfter(firstDayOfMonth) &&
//             transaccion.fecha.isBefore(lastDayOfMonth.add(Duration(days: 1))))
//         .toList();

//     // Actualizar la lista de transacciones filtradas
//     setState(() {
//       _transaccionesFiltradas = filteredTransacciones;
//     });

//     return filteredTransacciones;
//   }

// Widget _buildLegend() {
//   double total = 0;
//   for (var section in _pieChartSections) {
//     total += section.value;
//   }
//   return Wrap(
//     spacing: 20.0, // Espacio horizontal entre los elementos
//     runSpacing: 8.0, // Espacio vertical entre las líneas
//     children: _pieChartSections.map((section) {
//       double percentage = (section.value / total * 100);
//       return Column(
//         mainAxisSize: MainAxisSize.min, // Ajusta la columna al tamaño de su contenido
//         children: [
//           Row(
//             mainAxisSize: MainAxisSize.min, // Ajusta la fila al tamaño de su contenido
//             children: [
//               Container(
//                 width: 19,
//                 height: 19,
//                 color: section.color,
//               ),
//               SizedBox(width: 4), // Espacio entre el color y el nombre
//               Text(
//                 section.title ?? '',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 12),
//               ),
//             ],
//           ),
//           Text(
//             '${percentage.toStringAsFixed(1)}%',
//             textAlign: TextAlign.center,
//             style: TextStyle(fontSize: 12),
//           ),
//         ],
//       );
//     }).toList(),
//   );
// }

//   @override
// Widget build(BuildContext context) {
//   final userController = Provider.of<UserController>(context);

//   return Scaffold(
//     appBar: AppBar(
//       backgroundColor: Colors.grey[200],
//       title: Text('Estadísticas'),
//     ),
//     drawer: CustomDrawer(),
//     body: Column(
//       children: [
//         Container(
//           width: double.infinity,
//           height: 0,
//           decoration: BoxDecoration(
//             color: Colors.grey[200],
//             borderRadius: BorderRadius.only(
//               bottomLeft: Radius.circular(45),
//               bottomRight: Radius.circular(45),
//             ),
//           ),
//         ),
//         Center(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       _ingreso = true;
//                       _updatePieChartData();
//                     });
//                   },
//                   child: AnimatedContainer(
//                     duration: Duration(milliseconds: 150),
//                     padding: EdgeInsets.only(left: 35, right: 35, top: 5, bottom: 5),
//                     decoration: BoxDecoration(
//                       color: _ingreso
//                           ? Colors.green.withOpacity(0.7)
//                           : const Color.fromARGB(255, 205, 205, 205),
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                     child: Text(
//                       'Ingreso',
//                       style: TextStyle(fontSize: 22),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 20),
//                 GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       _ingreso = false;
//                       _updatePieChartData();
//                     });
//                   },
//                   child: AnimatedContainer(
//                     duration: Duration(milliseconds: 150),
//                     padding: EdgeInsets.only(left: 35, right: 35, top: 5, bottom: 5),
//                     decoration: BoxDecoration(
//                       color: !_ingreso
//                           ? Colors.red.withOpacity(0.7)
//                           : Color.fromARGB(255, 205, 205, 205),
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                     child: Text(
//                       'Gasto',
//                       style: TextStyle(fontSize: 22),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         Container(
//           child: MonthSelector(
//             onMonthChanged: (DateTime newDate) {
//               setState(() {
//                 _selectedDate = newDate;
//                 _updatePieChartData();
//               });
//             },
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
//           child: Container(
//             height: MediaQuery.of(context).size.height * 0.35,
//             decoration: BoxDecoration(
//               color: const Color(0xFFF9F9F9),
//               borderRadius: BorderRadius.circular(6),
//               boxShadow: [
//                 BoxShadow(
//                   color: const Color.fromARGB(255, 124, 124, 124).withOpacity(0.5),
//                   spreadRadius: 2,
//                   blurRadius: 5,
//                   offset: Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 Expanded(
//                   flex: 2,
//                   child: PieChart(
//                     PieChartData(
//                       sections: _pieChartSections,
//                       centerSpaceRadius: 40,
//                       sectionsSpace: 0,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   flex: 1,
//                   child: _buildLegend(), // Aquí se llama a la leyenda
//                 ),
//               ],
//             ),
//           ),
//         ),
//         SizedBox(height: 8),
//         Padding(
//           padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
//           child: Row(
//             children: [
//               Expanded(
//                 child: Container(
//                   height: 75,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFF9F9F9),
//                     borderRadius: BorderRadius.circular(6),
//                     boxShadow: [
//                       BoxShadow(
//                         color: const Color.fromARGB(255, 124, 124, 124).withOpacity(0.5),
//                         spreadRadius: 2,
//                         blurRadius: 5,
//                         offset: Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   // Presupuesto mensual
//                   child: Stack(
//                     children: [
//                       Positioned(
//                         top: 4,
//                         left: 8,
//                         child: Text(
//                           'Presupuesto Mensual',
//                           style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       Center(
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             _ingreso
//                                 ? Text(
//                                     '+ ${userController.usuario?.monthlyIncomeBudget != null
//                                         ? NumberFormat('#,##0.00', 'es_ES').format(userController.usuario?.monthlyIncomeBudget ?? 0.00)
//                                         : '0.00'}',
//                                     style: TextStyle(
//                                       fontSize: 22,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.green,
//                                     ),
//                                   )
//                                 : Text(
//                                     '- ${userController.usuario?.monthlyExpenseBudget != null
//                                         ? NumberFormat('#,##0.00', 'es_ES').format(userController.usuario?.monthlyExpenseBudget ?? 0.00)
//                                         : '0.00'}',
//                                     style: TextStyle(
//                                       fontSize: 22,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.red,
//                                     ),
//                                   ),
//                             _ingreso
//                                 ? Container(
//                                     padding: EdgeInsets.all(5),
//                                     decoration: BoxDecoration(
//                                       color: Colors.green.withOpacity(0.3),
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: Icon(
//                                       Icons.arrow_upward,
//                                       color: Colors.green,
//                                     ),
//                                   )
//                                 : Container(
//                                     padding: EdgeInsets.all(5),
//                                     decoration: BoxDecoration(
//                                       color: Colors.red.withOpacity(0.3),
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: Icon(
//                                       Icons.arrow_downward,
//                                       color: Colors.red,
//                                     ),
//                                   ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(width: 15), // Separación entre los dos widgets
//               Expanded(
//                 child: Container(
//                   height: 75,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFF9F9F9),
//                     borderRadius: BorderRadius.circular(6),
//                     boxShadow: [
//                       BoxShadow(
//                         color: const Color.fromARGB(255, 124, 124, 124).withOpacity(0.5),
//                         spreadRadius: 2,
//                         blurRadius: 5,
//                         offset: Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: Stack(
//                     children: [
//                       Positioned(
//                         top: 4,
//                         left: 8,
//                         child: Text('Total', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
//                       ),
//                       Center(
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             _ingreso
//                                 ? Text(
//                                     '+ ${_transaccionesFiltradas.isNotEmpty
//                                         ? NumberFormat('#,##0.00', 'es_ES').format(
//                                             _transaccionesFiltradas.fold(0.0, (sum, transaccion) => sum + transaccion.monto))
//                                         : '0.00'}',
//                                     style: TextStyle(
//                                       fontSize: 22,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.green,
//                                     ),
//                                   )
//                                 : Text(
//                                     '- ${_transaccionesFiltradas.isNotEmpty
//                                         ? NumberFormat('#,##0.00', 'es_ES').format(
//                                             _transaccionesFiltradas.fold(0.0, (sum, transaccion) => sum + transaccion.monto))
//                                         : '0.00'}',
//                                     style: TextStyle(
//                                       fontSize: 22,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.red,
//                                     ),
//                                   ),
//                             _ingreso
//                                 ? Container(
//                                     padding: EdgeInsets.all(5),
//                                     decoration: BoxDecoration(
//                                       color: Colors.green.withOpacity(0.3),
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: Icon(
//                                       Icons.arrow_upward,
//                                       color: Colors.green,
//                                     ),
//                                   )
//                                 : Container(
//                                     padding: EdgeInsets.all(5),
//                                     decoration: BoxDecoration(
//                                       color: Colors.red.withOpacity(0.3),
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: Icon(
//                                       Icons.arrow_downward,
//                                       color: Colors.red,
//                                     ),
//                                   ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Expanded(
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SizedBox(height: 10),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: _transaccionesFiltradas.length,
//                     itemBuilder: (context, index) {
//                       return TransactionCard(
//                         transaccion: _transaccionesFiltradas[index],
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         Container(
//           height: 100.0,
//           child: NavBar(
//             onPlusPressed: () {
//               Navigator.of(context).pushNamed('/addTransactions');
//             },
//             currentPage: '/statistics',
//           ),
//         ),
//       ],
//     ),
//   );
//   }
// }
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moni/controllers/user_controller.dart';
import 'package:moni/views/widgets/TransactionCard.dart';
import 'package:provider/provider.dart';
import 'package:moni/views/widgets/NavBar.dart';
import 'package:moni/views/widgets/CustomDrawer.dart';
import 'package:moni/views/widgets/MonthSelector.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:moni/controllers/transaccion_controller.dart';
import 'package:moni/models/clases/transaccion.dart';
import 'package:moni/controllers/category_controller.dart';
import 'package:moni/models/clases/category.dart';

class StatisticsPage extends StatefulWidget {
  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  bool _ingreso = true;
  DateTime _selectedDate = DateTime.now();
  TransaccionesController _transaccionesController = TransaccionesController();
  CategoryController _categoryController = CategoryController();
  List<Category> _categorias = [];

  List<PieChartSectionData> _pieChartSections = [];
  List<Transaccion> _transaccionesFiltradas = []; // Lista de transacciones filtradas

  @override
  void initState() {
    super.initState();
    _updatePieChartData();
    _cargarCategorias();
  }

  Future<void> _cargarCategorias() async {
    final categoryController = Provider.of<CategoryController>(context, listen: false);
    categoryController.categoriesStream().listen((categories) {
      setState(() {
        _categorias = categories;
      });
    });
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
  final categoryController = Provider.of<CategoryController>(context, listen: false);

  if (categoriasMontos.isEmpty) {
    // No hay transacciones, muestra un pie chart vacío
    sections.add(PieChartSectionData(
      color: Colors.grey, // Color gris para indicar vacío
      value: 1, 
      title: "No hay datos",
      radius: 50,
    ));
  } else {
    // Hay transacciones, construye las secciones del pie chart
    for (var entry in categoriasMontos.entries) {
      String categoriaId = entry.key;
      double monto = entry.value;

      Category? categoria = await categoryController.getCategoryById(categoriaId);
      

      sections.add(PieChartSectionData(
       // color: Color((categoriaId.hashCode * 0xFFFFFF).toInt()).withOpacity(1.0),
        color: categoria!.color,
        value: monto,
        title: categoria!.name,
        radius: 50,
        titleStyle: TextStyle( // Estilo para las categorías
         // color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ));
    }
  }

  setState(() {
    _pieChartSections = sections;
  });
}

  Future<List<Transaccion>> _getFilteredTransactions() async {
    DateTime firstDayOfMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
    DateTime lastDayOfMonth = DateTime(_selectedDate.year, _selectedDate.month + 1, 0);

    List<Transaccion> transacciones = await _transaccionesController
        .obtenerTransaccionesUsuarioStream()
        .first;

    // Filtrar las transacciones según la fecha y el tipo de transacción (_ingreso)
    List<Transaccion> filteredTransacciones = transacciones
        .where((transaccion) =>
            transaccion.ingreso == _ingreso &&
            transaccion.fecha.isAfter(firstDayOfMonth) &&
            transaccion.fecha.isBefore(lastDayOfMonth.add(Duration(days: 1))))
        .toList();

    // Actualizar la lista de transacciones filtradas
    setState(() {
      _transaccionesFiltradas = filteredTransacciones;
    });

    return filteredTransacciones;
  }

Widget _buildLegend() {
  double total = 0;
  for (var section in _pieChartSections) {
    total += section.value;
  }
  return Wrap(
    spacing: 20.0, // Espacio horizontal entre los elementos
    runSpacing: 8.0, // Espacio vertical entre las líneas
    children: _pieChartSections.map((section) {
      double percentage = (section.value / total * 100);
      return Column(
        mainAxisSize: MainAxisSize.min, // Ajusta la columna al tamaño de su contenido
        children: [
          Row(
            mainAxisSize: MainAxisSize.min, // Ajusta la fila al tamaño de su contenido
            children: [
              Container(
                width: 19,
                height: 19,
                color: section.color,
              ),
              SizedBox(width: 4), // Espacio entre el color y el nombre
              Text(
                section.title ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          Text(
            '${percentage.toStringAsFixed(1)}%',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
        ],
      );
    }).toList(),
  );
}

  @override
Widget build(BuildContext context) {
  final userController = Provider.of<UserController>(context);

  return Scaffold(
    appBar: AppBar(
        backgroundColor: const Color(0xFF2E4A5A), // Azul del navbar anterior
        elevation: 0,
        title: const Text(
          'Estadísticas',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white), // Texto blanco
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
    drawer: CustomDrawer(),
    body: Column(
      children: [
        Container(
          width: double.infinity,
          height: 0,
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
                      _updatePieChartData();
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
                      _updatePieChartData();
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
            height: MediaQuery.of(context).size.height * 0.35,
            decoration: BoxDecoration(
              color: const Color(0xFFF9F9F9),
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 124, 124, 124).withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: PieChart(
                    PieChartData(
                      sections: _pieChartSections,
                      centerSpaceRadius: 40,
                      sectionsSpace: 0,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: _buildLegend(), // Aquí se llama a la leyenda
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 75,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F9F9),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 124, 124, 124).withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  // Presupuesto mensual
                  child: Stack(
                    children: [
                      Positioned(
                        top: 4,
                        left: 8,
                        child: Text(
                          'Presupuesto Mensual',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Icono de flecha en el lado izquierdo
                            // _ingreso
                            //     ? Container(
                            //         padding: EdgeInsets.all(4),
                            //         decoration: BoxDecoration(
                            //           color: Colors.green.withOpacity(0.3),
                            //           shape: BoxShape.circle,
                            //         ),
                            //         child: Icon(
                            //           Icons.arrow_upward,
                            //           color: Colors.green,
                            //         ),
                            //       )
                            //     : Container(
                            //         padding: EdgeInsets.all(4),
                            //         decoration: BoxDecoration(
                            //           color: Colors.red.withOpacity(0.3),
                            //           shape: BoxShape.circle,
                            //         ),
                            //         child: Icon(
                            //           Icons.arrow_downward,
                            //           color: Colors.red,
                            //         ),
                            //       ),
                            // SizedBox(width: 1), // Espacio entre la flecha y el monto
                            _ingreso
                                ? Text(
                                    '+ ${userController.usuario?.monthlyIncomeBudget != null
                                        ? NumberFormat('#,##0.00', 'es_ES').format(userController.usuario?.monthlyIncomeBudget ?? 0.00)
                                        : '0.00'}',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  )
                                : Text(
                                    '- ${userController.usuario?.monthlyExpenseBudget != null
                                        ? NumberFormat('#,##0.00', 'es_ES').format(userController.usuario?.monthlyExpenseBudget ?? 0.00)
                                        : '0.00'}',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 15), // Separación entre los dos widgets
              Expanded(
                child: Container(
                  height: 75,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F9F9),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 124, 124, 124).withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 4,
                        left: 8,
                        child: Text('Total', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _ingreso
                                ? Text(
                                    '+ ${_transaccionesFiltradas.isNotEmpty
                                        ? NumberFormat('#,##0.00', 'es_ES').format(
                                            _transaccionesFiltradas.fold(0.0, (sum, transaccion) => sum + transaccion.monto))
                                        : '0.00'}',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  )
                                : Text(
                                    '- ${_transaccionesFiltradas.isNotEmpty
                                        ? NumberFormat('#,##0.00', 'es_ES').format(
                                            _transaccionesFiltradas.fold(0.0, (sum, transaccion) => sum + transaccion.monto))
                                        : '0.00'}',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                            // SizedBox(width: 1), // Espacio entre la flecha y el monto
                            // _ingreso
                            //     ? Container(
                            //         padding: EdgeInsets.all(4),
                            //         decoration: BoxDecoration(
                            //           color: Colors.green.withOpacity(0.3),
                            //           shape: BoxShape.circle,
                            //         ),
                            //         child: Icon(
                            //           Icons.arrow_upward,
                            //           color: Colors.green,
                            //         ),
                            //       )
                            //     : Container(
                            //         padding: EdgeInsets.all(4),
                            //         decoration: BoxDecoration(
                            //           color: Colors.red.withOpacity(0.3),
                            //           shape: BoxShape.circle,
                            //         ),
                            //         child: Icon(
                            //           Icons.arrow_downward,
                            //           color: Colors.red,
                            //         ),
                            //       ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: _transaccionesFiltradas.length,
                    itemBuilder: (context, index) {
                      return TransactionCard(
                        transaccion: _transaccionesFiltradas[index],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 100.0,
          child: NavBar(
            onPlusPressed: () {
              Navigator.of(context).pushNamed('/addTransactions');
            },
            currentPage: '/statistics',
          ),
        ),
      ],
    ),
  );
  }
}