import 'package:flutter/material.dart';
import 'package:moni/controllers/user_controller.dart';
import 'package:moni/models/clases/Usuario.dart';
import 'package:provider/provider.dart';
import 'package:moni/views/widgets/NavBar.dart';
import 'package:moni/views/widgets/CustomDrawer.dart';

class StatisticsPage extends StatelessWidget {

@override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        title: const Text('Estadísticas', style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          Expanded(
              child: Center(
                child: userController.usuario != null
                    ? Text('¡Bienvenido, ${userController.usuario?.name}!')
                    : CircularProgressIndicator(),
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


