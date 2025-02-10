import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moni/controllers/user_controller.dart';
import 'package:moni/models/clases/Usuario.dart';
import 'package:provider/provider.dart';
import 'package:moni/views/widgets/NavBar.dart';
import 'package:moni/views/widgets/CustomDrawer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // En caso de que el usuario no haya iniciado sesion se redirije a la pagina de login
    FirebaseAuth.instance
  .authStateChanges()
  .listen((User? user) {
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
        backgroundColor: Colors.grey[200],
        title: Text('Home'),
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cierre de sesión exitoso.')));
    Navigator.pushNamed(context, '/');
  }
}
