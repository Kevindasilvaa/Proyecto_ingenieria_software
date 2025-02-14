import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moni/controllers/user_controller.dart';
import 'package:moni/controllers/cuenta_controller.dart';
import 'package:moni/views/widgets/AddAccountButton.dart';
import 'package:moni/views/widgets/NavBar.dart';
import 'package:moni/views/widgets/CustomDrawer.dart';
import 'package:moni/views/screens/addAccount.dart';
import 'package:moni/models/clases/cuenta.dart';

class AccountsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);
    final cuentaController =
        Provider.of<CuentaController>(context, listen: false);
    final userId = userController.usuario?.id;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Text('Cuentas'),
      ),
      drawer: CustomDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            // Mensaje de bienvenida
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: userController.usuario != null
                    ? Text(
                        '¡Bienvenido, ${userController.usuario?.name}!',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )
                    : CircularProgressIndicator(),
              ),
            ),

            // Lista de cuentas
            Expanded(
              child: userId != null
                  ? Consumer<CuentaController>(
                      builder: (context, cuentaController, child) {
                        if (cuentaController.cuentas.isEmpty) {
                          return Center(child: Text('No tienes cuentas aún.'));
                        }

                        return ListView.builder(
                          itemCount: cuentaController.cuentas.length,
                          itemBuilder: (context, index) {
                            Cuenta cuenta = cuentaController.cuentas[index];
                            return Card(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: ListTile(
                                title: Text(cuenta.nombre,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                subtitle: Text(
                                    '${cuenta.tipo} - \$${cuenta.saldo.toStringAsFixed(2)}'),
                                leading: Icon(Icons.account_balance_wallet,
                                    color: Colors.blue),
                              ),
                            );
                          },
                        );
                      },
                    )
                  : Center(child: Text('Inicia sesión para ver tus cuentas')),
            ),

            // Botón para agregar una nueva cuenta usando el widget AddAccountButton
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: AddAccountButton(
                userId: userId ?? '',
                onAdd: () {
                  if (userId?.isNotEmpty ?? false) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AddAccountPage(userId: userId ?? '')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Inicia sesión para agregar cuentas'),
                      duration: Duration(seconds: 2),
                    ));
                  }
                },
              ),
            ),

            // Barra de navegación
            Container(
              height: 80.0,
              child: NavBar(
                onPlusPressed: () {
                  Navigator.of(context).pushNamed('/addTransactions');
                },
                currentPage: '/accounts',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
