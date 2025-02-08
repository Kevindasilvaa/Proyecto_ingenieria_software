import 'package:flutter/material.dart';
import 'package:moni/controllers/user_controller.dart';
import 'package:moni/models/clases/Usuario.dart';
import 'package:provider/provider.dart';
import 'package:moni/views/widgets/NavBar.dart';
import 'package:moni/views/widgets/CustomDrawer.dart';

class TransactionsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);
    userController.startAuthListener(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Text('Transacciones'),
      ),
      drawer: CustomDrawer(), // Aquí agregamos el Drawer
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: userController.usuario != null
                    ? Text('¡Bienvenido, ${userController.usuario?.name}!')
                    : CircularProgressIndicator(),
              ),
            ),
            Container(
              height: 80.0,
              child: NavBar(
                onPlusPressed: () {
                  Navigator.of(context).pushNamed('/addTransactions');
                },
                currentPage: '/transactions',
              ),
            ),
          ],
        ),
      ),

    );
  }
}

