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
import 'package:moni/views/widgets/AddTransactionDialog.dart';

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
        backgroundColor: const Color(0xFF2E4A5A), // Azul del navbar anterior
        elevation: 0,
        title: const Text(
          'Inicio',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white), // Texto blanco
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: CustomDrawer(),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.30,
                decoration: const BoxDecoration(
                  color: Color(0xFF2E4A5A), // Fondo azul navbar
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
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                //color: Colors.white, // Texto blanco
                              ),
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
                  color: Color(0xFF2E4A5A), // Azul inferior navbar
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: NavBar(
                  onPlusPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AddTransactionDialog(),
                    );
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
      padding: const EdgeInsets.only(top: 3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Balance Total',
            style: TextStyle(fontSize: 15, color: Colors.white), // Texto blanco
          ),
          const SizedBox(height: 4),
          StreamBuilder<double>(
            stream: cuentaController
                .calcularBalanceTotalStream(userController.usuario!.email),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.white), // Texto blanco
                  ),
                );
              } else if (!snapshot.hasData) {
                return const Center(
                  child: Text(
                    'No hay datos de balance',
                    style: TextStyle(color: Colors.white), // Texto blanco
                  ),
                );
              } else {
                return Text(
                  '${NumberFormat.simpleCurrency().format(snapshot.data)}',
                  style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white), // Texto blanco
                );
              }
            },
          ),
          const SizedBox(height: 20),
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
                      const Text(
                        'Total Ingresos',
                        style: TextStyle(
                            fontSize: 16, color: Colors.white), // Texto blanco
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(
                                  0.8), // Opacidad incrementada para mejor visibilidad
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(
                                4), // Padding ligeramente aumentado para más equilibrio
                            child: const Icon(
                              Icons.arrow_upward,
                              color: Colors
                                  .white, // Cambié a blanco para mayor contraste
                              size: 20, // Tamaño ajustado para mejor claridad
                            ),
                          ),
                          const SizedBox(width: 2),
                          DefaultTextStyle(
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Texto blanco
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
                      const Text(
                        'Total Gastos',
                        style: TextStyle(
                            fontSize: 16, color: Colors.white), // Texto blanco
                      ),
                      Row(
                        children: [
                          DefaultTextStyle(
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Texto blanco
                            ),
                            child: TotalGastosView(),
                          ),
                          const SizedBox(width: 2),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(
                                  0.8), // Opacidad incrementada para mejor visibilidad
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(
                                4), // Padding ligeramente aumentado para mejor equilibrio
                            child: const Icon(
                              Icons.arrow_downward,
                              color: Colors
                                  .white, // Cambié a blanco para mayor contraste
                              size: 20, // Tamaño ajustado para más claridad
                            ),
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
