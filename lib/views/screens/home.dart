// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:moni/controllers/cuenta_controller.dart';
// import 'package:moni/controllers/transaccion_controller.dart';
// import 'package:moni/controllers/user_controller.dart';
// import 'package:moni/models/clases/transaccion.dart';
// import 'package:provider/provider.dart';
// import 'package:moni/views/widgets/NavBar.dart';
// import 'package:moni/views/widgets/CustomDrawer.dart';
// import 'package:moni/views/widgets/RecentTransactionsView.dart';
// import 'package:intl/intl.dart';

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       FirebaseAuth.instance.authStateChanges().listen((User? user) {
//         if (user == null) {
//           Navigator.of(context).pushNamed('/');
//         } else {
//           _loadData(user);
//         }
//       });
//     });
//   }

//   Future<void> _loadData(User user) async {
//     final cuentaController = Provider.of<CuentaController>(context, listen: false);

//     try {
//       await cuentaController.cargarCuentas(user.email!);
//       setState(() {
//         _isLoading = false;
//       });
//     } catch (error) {
//       print('Error al cargar datos: $error');
//       setState(() {
//         _isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error al cargar las cuentas: $error')),
//       );
//     }
//   }

// @override
// Widget build(BuildContext context) {
//   final cuentaController = Provider.of<CuentaController>(context);

//   return Scaffold(
//     appBar: AppBar(
//       backgroundColor: const Color(0xFFF2F2F2),
//       elevation: 0,
//       title: const Text(
//         'Inicio',
//         style: TextStyle(color: Colors.black, fontSize: 20), // Título ajustado
//       ),
//       iconTheme: const IconThemeData(color: Colors.black),
//     ),
//     drawer: CustomDrawer(),
//     body: Column(
//       children: [
//         Container(
//           height: MediaQuery.of(context).size.height * 0.25, // Altura ajustada
//           decoration: const BoxDecoration(
//             color: Color(0xFFF2F2F2),
//             borderRadius: BorderRadius.only(
//               bottomLeft: Radius.circular(40),
//               bottomRight: Radius.circular(40),
//             ),
//           ),
//           child:
//       _buildBalanceCard(cuentaController),),
//         Expanded(
//           child: _isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const SizedBox(height: 20),
//                       const Text(
//                         'Transacciones recientes',
//                         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 10),
//                       Expanded(child: RecentTransactionsView()),
//                     ],
//                   ),
//                 ),
//         ),
//         Container(
//           height: 100.0,
//           decoration: const BoxDecoration(
//             color: Color(0xFFF2F2F2),
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(40),
//               topRight: Radius.circular(40),
//             ),
//           ),
//           child: NavBar(
//             onPlusPressed: () {
//               Navigator.of(context).pushNamed('/addTransactions');
//             },
//             currentPage: '/home',
//           ),
//         ),
//       ],
//     ),
//   );
// }

// Widget _buildBalanceCard(CuentaController cuentaController) {
//   final userController = Provider.of<UserController>(context, listen: false);
//   return Column(
//     mainAxisAlignment: MainAxisAlignment.center,
//     crossAxisAlignment: CrossAxisAlignment.center,
//     children: [
//       // Título "Balance Total"
//       const Text(
//         'Balance Total',
//         style: TextStyle(fontSize: 18),
//       ),

//       // Monto del balance total
//       StreamBuilder<double>(
//         stream: cuentaController.calcularBalanceTotalStream(userController.usuario!.email),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData) {
//             return const Center(child: Text('No hay datos de balance'));
//           } else {
//             return Text(
//               '${NumberFormat.simpleCurrency().format(snapshot.data)}',
//               style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//             );
//           }
//         },
//       ),

//       const SizedBox(height: 10),

//       // Fila con los detalles de ingresos y gastos
//       Row(
//         mainAxisAlignment: MainAxisAlignment.center, // Centrado de ambos bloques
//         children: [
//           // Sección de Total Ingresos
//           Padding(
//             padding: const EdgeInsets.only(right: 4.0), // Añadido un padding a la derecha
//             child: Column(
//               children: [
//                 const Text('Total Ingresos', style: TextStyle(fontSize: 16)),
//                 Row(
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.green.withOpacity(0.5),
//                         shape: BoxShape.circle,
//                       ),
//                       padding: const EdgeInsets.all(4),
//                       child: const Icon(Icons.arrow_upward, color: Color.fromARGB(255, 42, 144, 45), size: 20),
//                     ),
//                     const SizedBox(width: 2),
//                     DefaultTextStyle(
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Color.fromARGB(255, 16, 191, 16),
//                       ),
//                       child: TotalIngresosView(),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),

//           // Línea vertical separadora (simulada con un Container)
//           Container(
//             color: Colors.grey,  // Color de la línea
//             width: 1,  // Grosor de la línea
//             height: 50, // Altura de la línea (ajustar según sea necesario)
//             margin: const EdgeInsets.symmetric(horizontal: 10), // Espaciado alrededor de la línea
//           ),

//           // Sección de Total Gastos
//           Padding(
//             padding: const EdgeInsets.only(left: 4.0), // Añadido un padding a la izquierda
//             child: Column(
//               children: [
//                 const Text('Total Gastos', style: TextStyle(fontSize: 16)),
//                 Row(
//                   children: [
//                     DefaultTextStyle(
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF8B0000),
//                       ),
//                       child: TotalGastosView(),
//                     ),
//                     const SizedBox(width: 2),
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.red.withOpacity(0.5),
//                         shape: BoxShape.circle,
//                       ),
//                       padding: const EdgeInsets.all(4),
//                       child: const Icon(Icons.arrow_downward, color: Color.fromARGB(255, 203, 16, 2), size: 20),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     ],
//   );
// }

//   Future<void> _logout() async {
//     final userController = Provider.of<UserController>(context, listen: false);
//     await userController.logOut();
//     ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Cierre de sesión exitoso.')));
//     Navigator.pushNamed(context, '/');
//   }
// }

// class TotalIngresosView extends StatelessWidget {
//   final TransaccionesController _controller = TransaccionesController();

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<List<Transaccion>>(
//       stream: _controller.obtenerTransaccionesUsuarioStream(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         } else if (snapshot.data == null || snapshot.data!.isEmpty) {
//           return const Center(child: Text('No hay transacciones'));
//         } else {
//           final transacciones = snapshot.data!;

//           // Filtra las transacciones que son de ingreso y ocurren en el mes actual
//           final fechaInicioMes = DateTime(DateTime.now().year, DateTime.now().month, 1);
//           final fechaFinMes = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);

//           final transaccionesDelMes = transacciones.where((transaccion) {
//             return transaccion.fecha.isAfter(fechaInicioMes) && transaccion.fecha.isBefore(fechaFinMes) && transaccion.ingreso;
//           }).toList();

//           // Suma los montos de las transacciones de ingreso
//           final totalIngresos = transaccionesDelMes.fold(0.0, (sum, transaccion) => sum + transaccion.monto);

//           // Usamos el formato correcto para la moneda
//           return Text(
//             '+${NumberFormat.simpleCurrency().format(totalIngresos)}',
//             style: const TextStyle(color: Color.fromARGB(255, 65, 181, 71), fontSize: 20),
//           );
//         }
//       },
//     );
//   }
// }

// class TotalGastosView extends StatelessWidget {
//   final TransaccionesController _controller = TransaccionesController();

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<List<Transaccion>>(
//       stream: _controller.obtenerTransaccionesUsuarioStream(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         } else if (snapshot.data == null || snapshot.data!.isEmpty) {
//           return const Center(child: Text('No hay transacciones'));
//         } else {
//           final transacciones = snapshot.data!;

//           // Filtra las transacciones que son de gasto y ocurren en el mes actual
//           final fechaInicioMes = DateTime(DateTime.now().year, DateTime.now().month, 1);
//           final fechaFinMes = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);

//           final transaccionesDelMes = transacciones.where((transaccion) {
//             return transaccion.fecha.isAfter(fechaInicioMes) && transaccion.fecha.isBefore(fechaFinMes) && !transaccion.ingreso;
//           }).toList();

//           // Suma los montos de las transacciones de gasto
//           final totalGastos = transaccionesDelMes.fold(0.0, (sum, transaccion) => sum + transaccion.monto);

//           return Text(
//             '-${NumberFormat.simpleCurrency().format(totalGastos)}',
//             style: const TextStyle(color: Color.fromARGB(255, 224, 18, 3), fontSize: 20),
//           );
//         }
//       },
//     );
//   }
// }

// lib/views/screens/home.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moni/controllers/cuenta_controller.dart';
import 'package:moni/controllers/transaccion_controller.dart';
import 'package:moni/controllers/user_controller.dart';
import 'package:moni/models/clases/transaccion.dart';
import 'package:moni/views/widgets/NavBar.dart';
import 'package:moni/views/widgets/CustomDrawer.dart';
import 'package:moni/views/widgets/RecentTransactionsView.dart';
import 'package:moni/views/widgets/BudgetWidget.dart'; // Aquí se encuentra BudgetLink
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true; // Controla la barra de carga

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          Navigator.of(context).pushNamed('/');
        } else {
          _loadData(user);
        }
      });
    });
  }

  Future<void> _loadData(User user) async {
    final cuentaController =
        Provider.of<CuentaController>(context, listen: false);
    try {
      await cuentaController.cargarCuentas(user.email!);
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print('Error al cargar datos: $error');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar las cuentas: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cuentaController = Provider.of<CuentaController>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F2F2),
        elevation: 0,
        title: const Text(
          'Inicio',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      drawer: CustomDrawer(),
      body: Stack(
        children: [
          Column(
            children: [
              // Capa gris con balance total, ingresos y gastos.
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.30,
                decoration: const BoxDecoration(
                  color: Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: _buildBalanceCard(cuentaController),
              ),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            const Text(
                              'Transacciones recientes',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Expanded(child: RecentTransactionsView()),
                          ],
                        ),
                      ),
              ),
              Container(
                height: 100.0,
                decoration: const BoxDecoration(
                  color: Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: NavBar(
                  onPlusPressed: () {
                    Navigator.of(context).pushNamed('/addTransactions');
                  },
                  currentPage: '/home',
                ),
              ),
            ],
          ),
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.white.withOpacity(0.8),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(CuentaController cuentaController) {
    final userController = Provider.of<UserController>(context, listen: false);
    if (userController.usuario == null) {
      return const SizedBox.shrink();
    }
    return Container(
      padding: const EdgeInsets.only(
          top: 3), // Padding solo para el contenido escrito
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Balance Total',
            style: TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 4),
          StreamBuilder<double>(
            stream: cuentaController
                .calcularBalanceTotalStream(userController.usuario!.email),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return const Center(child: Text('No hay datos de balance'));
              } else {
                return Text(
                  '${NumberFormat.simpleCurrency().format(snapshot.data)}',
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                );
              }
            },
          ),
          const SizedBox(height: 20),
          // Aquí envolvemos BudgetLink en un StreamBuilder para calcular totalGastos actual
          StreamBuilder<List<Transaccion>>(
            stream:
                TransaccionesController().obtenerTransaccionesUsuarioStream(),
            builder: (context, snapshot) {
              double totalGastos = 0;
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                final transacciones = snapshot.data!;
                final fechaInicioMes =
                    DateTime(DateTime.now().year, DateTime.now().month, 1);
                final fechaFinMes =
                    DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
                final transaccionesDelMes = transacciones.where((transaccion) {
                  return transaccion.fecha.isAfter(fechaInicioMes) &&
                      transaccion.fecha.isBefore(fechaFinMes) &&
                      !transaccion.ingreso;
                }).toList();
                totalGastos = transaccionesDelMes.fold(
                    0.0, (sum, transaccion) => sum + transaccion.monto);
              }
              return BudgetLink(
                totalGastos: totalGastos,
                presupuestoMensual:
                    userController.usuario?.monthlyExpenseBudget ?? 0,
                onBudgetSet: (nuevoPresupuesto) {
                  // Aquí se puede manejar el callback adicional si es necesario.
                  print("Nuevo presupuesto establecido: $nuevoPresupuesto");
                },
              );
            },
          ),
          const SizedBox(height: 25),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Column(
                    children: [
                      const Text('Total Ingresos',
                          style: TextStyle(fontSize: 16)),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(Icons.arrow_upward,
                                color: Color.fromARGB(255, 42, 144, 45),
                                size: 20),
                          ),
                          const SizedBox(width: 2),
                          DefaultTextStyle(
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 16, 191, 16),
                            ),
                            child: TotalIngresosView(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.grey,
                  width: 1,
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Column(
                    children: [
                      const Text('Total Gastos',
                          style: TextStyle(fontSize: 16)),
                      Row(
                        children: [
                          DefaultTextStyle(
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF8B0000),
                            ),
                            child: TotalGastosView(),
                          ),
                          const SizedBox(width: 2),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(Icons.arrow_downward,
                                color: Color.fromARGB(255, 203, 16, 2),
                                size: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}

class TotalIngresosView extends StatelessWidget {
  final TransaccionesController _controller = TransaccionesController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Transaccion>>(
      stream: _controller.obtenerTransaccionesUsuarioStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.data == null || snapshot.data!.isEmpty) {
          return const Center(child: Text('No hay transacciones'));
        } else {
          final transacciones = snapshot.data!;
          final fechaInicioMes =
              DateTime(DateTime.now().year, DateTime.now().month, 1);
          final fechaFinMes =
              DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
          final transaccionesDelMes = transacciones.where((transaccion) {
            return transaccion.fecha.isAfter(fechaInicioMes) &&
                transaccion.fecha.isBefore(fechaFinMes) &&
                transaccion.ingreso;
          }).toList();
          final totalIngresos = transaccionesDelMes.fold(
              0.0, (sum, transaccion) => sum + transaccion.monto);
          return Text(
            '+${NumberFormat.simpleCurrency().format(totalIngresos)}',
            style: const TextStyle(
                color: Color.fromARGB(255, 65, 181, 71), fontSize: 20),
          );
        }
      },
    );
  }
}

class TotalGastosView extends StatelessWidget {
  final TransaccionesController _controller = TransaccionesController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Transaccion>>(
      stream: _controller.obtenerTransaccionesUsuarioStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.data == null || snapshot.data!.isEmpty) {
          return const Center(child: Text('No hay transacciones'));
        } else {
          final transacciones = snapshot.data!;
          final fechaInicioMes =
              DateTime(DateTime.now().year, DateTime.now().month, 1);
          final fechaFinMes =
              DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
          final transaccionesDelMes = transacciones.where((transaccion) {
            return transaccion.fecha.isAfter(fechaInicioMes) &&
                transaccion.fecha.isBefore(fechaFinMes) &&
                !transaccion.ingreso;
          }).toList();
          final totalGastos = transaccionesDelMes.fold(
              0.0, (sum, transaccion) => sum + transaccion.monto);
          return Text(
            '-${NumberFormat.simpleCurrency().format(totalGastos)}',
            style: const TextStyle(
                color: Color.fromARGB(255, 224, 18, 3), fontSize: 20),
          );
        }
      },
    );
  }
}
