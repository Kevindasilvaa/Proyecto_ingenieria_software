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
    // Accedemos al controlador de usuario para obtener el email
    final userController = Provider.of<UserController>(context);
    final cuentaController = Provider.of<CuentaController>(context, listen: false);
    
    // Aquí accedemos al correo del usuario desde el controlador
    final userEmail = userController.usuario?.email; 

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
              child: userEmail != null
                  ? Consumer<CuentaController>(
                      builder: (context, cuentaController, child) {
                        // Filtramos las cuentas por userEmail
                        final cuentasDelUsuario = cuentaController.cuentas
                            .where((cuenta) => cuenta.userEmail == userEmail)
                            .toList();

                        if (cuentasDelUsuario.isEmpty) {
                          return Center(child: Text('No tienes cuentas aún.'));
                        }

                        return ListView.builder(
                          itemCount: cuentasDelUsuario.length,
                          itemBuilder: (context, index) {
                            Cuenta cuenta = cuentasDelUsuario[index];
                            return Card(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: ListTile(
                                title: Text(cuenta.nombre,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                subtitle: Text(
                                    '${cuenta.tipo} - ${cuenta.tipoMoneda} - \$${cuenta.saldo.toStringAsFixed(2)}'),
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
                // Usamos el email del usuario desde el controlador
                onAdd: () {
                  if (userEmail?.isNotEmpty ?? false) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AddAccountPage()),
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
