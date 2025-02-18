import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moni/controllers/cuenta_controller.dart';
import 'package:moni/controllers/transaccion_controller.dart';
import 'package:moni/controllers/user_controller.dart';
import 'package:moni/models/clases/transaccion.dart';
import 'package:provider/provider.dart';
import 'package:moni/views/widgets/NavBar.dart';
import 'package:moni/views/widgets/CustomDrawer.dart';
import 'package:moni/views/widgets/RecentTransactionsView.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;

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
    final cuentaController = Provider.of<CuentaController>(context, listen: false);

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
        backgroundColor: const Color(0xFFFFFFFF),
        title: const Text('Home', style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBalanceCard(cuentaController),
                        const SizedBox(height: 20),
                        const Text('Transacciones recientes',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Expanded(child: RecentTransactionsView()),
                      ],
                    ),
                  ),
          ),
          Container(
            height: 80.0,
            child: NavBar(
              onPlusPressed: () {
                Navigator.of(context).pushNamed('/addTransactions');
              },
              currentPage: '/home',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(CuentaController cuentaController) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,  // Centrar contenido
      crossAxisAlignment: CrossAxisAlignment.center,  // Centrar contenido horizontalmente
        children: [
          const Text('Balance Total', style: TextStyle(fontSize: 16)),
          Text(
            '\$${cuentaController.calcularBalanceTotal()}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const Text('Total Ingresos',
                      style: TextStyle(color: Colors.green)),
                  TotalIngresosView(),
                ],
              ),
              Column(
                children: [
                  const Text('Total Gastos',
                      style: TextStyle(color: Colors.red)),
                  TotalGastosView(),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    final userController = Provider.of<UserController>(context, listen: false);
    await userController.logOut();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cierre de sesión exitoso.')));
    Navigator.pushNamed(context, '/');
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

          // Filtra las transacciones que son de ingreso y ocurren en el mes actual
          final fechaInicioMes = DateTime(DateTime.now().year, DateTime.now().month, 1);
          final fechaFinMes = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);

          final transaccionesDelMes = transacciones.where((transaccion) {
            return transaccion.fecha.isAfter(fechaInicioMes) && transaccion.fecha.isBefore(fechaFinMes) && transaccion.ingreso;
          }).toList();

          // Suma los montos de las transacciones de ingreso
          final totalIngresos = transaccionesDelMes.fold(0.0, (sum, transaccion) => sum + transaccion.monto);

          // Usamos el formato correcto para la moneda
          return Text(
            '+${NumberFormat.simpleCurrency().format(totalIngresos)}',
            style: const TextStyle(color: Colors.green, fontSize: 16),
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

          // Filtra las transacciones que son de gasto y ocurren en el mes actual
          final fechaInicioMes = DateTime(DateTime.now().year, DateTime.now().month, 1);
          final fechaFinMes = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
          
          final transaccionesDelMes = transacciones.where((transaccion) {
            return transaccion.fecha.isAfter(fechaInicioMes) && transaccion.fecha.isBefore(fechaFinMes) && !transaccion.ingreso;
          }).toList();

          // Suma los montos de las transacciones de gasto
          final totalGastos = transaccionesDelMes.fold(0.0, (sum, transaccion) => sum + transaccion.monto);

          return Text(
            '-${NumberFormat.simpleCurrency().format(totalGastos)}',
            style: const TextStyle(color: Colors.red, fontSize: 16),
          );
        }
      },
    );
  }
}
