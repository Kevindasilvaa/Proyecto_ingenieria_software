import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moni/controllers/user_controller.dart';
import 'package:moni/models/clases/Usuario.dart';
import 'package:provider/provider.dart';
import 'package:moni/views/widgets/NavBar.dart';
import 'package:moni/views/widgets/CustomDrawer.dart';
import 'package:moni/controllers/transaccion_controller.dart';
import 'package:moni/models/clases/transaccion.dart'; 
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
        Navigator.of(context).pushNamed('/');
      } else {
        print('User is signed in!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFCECECE),
        title: Text('Home'),
      ),
      drawer: CustomDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: TransaccionesView(), // Usa la clase TransaccionesView
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
      ),
    );
  }

  Future<void> _logout() async {
    final userController = Provider.of<UserController>(context, listen: false);
    await userController.logOut();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cierre de sesión exitoso.')));
    Navigator.pushNamed(context, '/');
  }
}

// Muestra las 3 ultimas transacciones segun su fecha
class TransaccionesView extends StatelessWidget { // Cambiado a StatelessWidget
  final TransaccionesController _controller = TransaccionesController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Transaccion>>( // Usamos StreamBuilder
      stream: _controller.obtenerTransaccionesUsuarioStream(), // Escuchamos el stream
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Mientras carga
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}')); // Si hay error
        } else if (snapshot.data == null || snapshot.data!.isEmpty) {
          return Center(child: Text('No hay transacciones')); // Si no hay datos
        } else {
          final transacciones = snapshot.data!;

          // Ordena las transacciones por fecha de forma descendente (las más recientes primero)
          transacciones.sort((a, b) => b.fecha.compareTo(a.fecha));

          // Toma solo las últimas 3 transacciones
          final ultimasTransacciones = transacciones.take(3).toList();

          return ListView.builder(
            itemCount: ultimasTransacciones.length,
            itemBuilder: (context, index) {
              final transaccion = ultimasTransacciones[index];
              return ListTile(
                title: Text(transaccion.nombre),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Categoría: ${transaccion.categoria}'),
                    Text('Monto: ${transaccion.monto}'),
                    Text('Ingreso: ${transaccion.ingreso}'),
                    Text('Fecha: ${DateFormat.yMd().format(transaccion.fecha)}'),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}