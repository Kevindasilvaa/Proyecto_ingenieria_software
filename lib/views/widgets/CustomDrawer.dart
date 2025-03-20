import 'package:flutter/material.dart';
import 'package:moni/controllers/user_controller.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  // Variables para los colores de los íconos cuando el cursor está sobre ellos
  Color homeIconColor = Colors.grey[600]!;
  Color profileIconColor = Colors.grey[600]!;
  Color settingsIconColor = Colors.grey[600]!;
  Color logoutIconColor = Colors.grey[600]!;
  Color statisticsIconColor = Colors.grey[600]!;
  Color accountsIconColor = Colors.grey[600]!;
  Color categoriesIconColor = Colors.grey[600]!;
  Color articlesIconColor = Colors.grey[600]!;
  Color offers_incomeIconColor = Colors.grey[600]!;
  Color my_offers_incomeIconColor = Colors.grey[600]!;
  Color transactionsIconColor = Colors.grey[600]!;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.grey[300], // Fondo gris para todo el Drawer
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // Header
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey[300], // Fondo gris en el header
              ),
              child: Text(
                'Menú',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Opción Inicio
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  homeIconColor = Colors.grey[900]!;
                });
              },
              onExit: (_) {
                setState(() {
                  homeIconColor = Colors.grey[600]!;
                });
              },
              child: ListTile(
                leading: Icon(Icons.home, color: homeIconColor),
                title: Text('Inicio'),
                onTap: () {
                  Navigator.pushNamed(context, '/home');
                },
              ),
            ),
            // Opción Transacciones
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  transactionsIconColor = Colors.grey[900]!;
                });
              },
              onExit: (_) {
                setState(() {
                  transactionsIconColor = Colors.grey[600]!;
                });
              },
              child: ListTile(
                leading:
                    Icon(Icons.compare_arrows, color: transactionsIconColor),
                title: Text('Transacciones'),
                onTap: () {
                  Navigator.pushNamed(context, '/transactions');
                },
              ),
            ),
            // Opción Estadísticas
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  statisticsIconColor = Colors.grey[900]!;
                });
              },
              onExit: (_) {
                setState(() {
                  statisticsIconColor = Colors.grey[600]!;
                });
              },
              child: ListTile(
                leading: Icon(Icons.bar_chart, color: statisticsIconColor),
                title: Text('Estadísticas'),
                onTap: () {
                  Navigator.pushNamed(context, '/statistics');
                },
              ),
            ),
            // Opción Cuentas
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  accountsIconColor = Colors.grey[900]!;
                });
              },
              onExit: (_) {
                setState(() {
                  accountsIconColor = Colors.grey[600]!;
                });
              },
              child: ListTile(
                leading: Icon(Icons.account_balance, color: accountsIconColor),
                title: Text('Cuentas'),
                onTap: () {
                  Navigator.pushNamed(context, '/accounts');
                },
              ),
            ),
            // Opción Perfil
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  profileIconColor = Colors.grey[900]!;
                });
              },
              onExit: (_) {
                setState(() {
                  profileIconColor = Colors.grey[600]!;
                });
              },
              child: ListTile(
                leading: Icon(Icons.person, color: profileIconColor),
                title: Text('Perfil'),
                onTap: () {
                  Navigator.pushNamed(context, '/profile');
                },
              ),
            ),
            // Opción Categorías
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  categoriesIconColor = Colors.grey[900]!;
                });
              },
              onExit: (_) {
                setState(() {
                  categoriesIconColor = Colors.grey[600]!;
                });
              },
              child: ListTile(
                leading: Icon(Icons.category, color: categoriesIconColor),
                title: Text('Categorías'),
                onTap: () {
                  Navigator.pushNamed(context, '/categories');
                },
              ),
            ),
            // NUEVA OPCIÓN: Artículos de Interés
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  articlesIconColor = Colors.grey[900]!;
                });
              },
              onExit: (_) {
                setState(() {
                  articlesIconColor = Colors.grey[600]!;
                });
              },
              child: ListTile(
                leading: Icon(Icons.article, color: articlesIconColor),
                title: Text('Artículos de Interés'),
                onTap: () {
                  Navigator.pushNamed(context, '/articles');
                },
              ),
            ),
            // Opción Ofertas de Ingresos
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  offers_incomeIconColor = Colors.grey[900]!;
                });
              },
              onExit: (_) {
                setState(() {
                  offers_incomeIconColor = Colors.grey[600]!;
                });
              },
              child: ListTile(
                leading:
                    Icon(Icons.attach_money, color: offers_incomeIconColor),
                title: Text('Ofertas de Ingresos'),
                onTap: () {
                  Navigator.pushNamed(context, '/income_offers');
                },
              ),
            ),
            // Opción de mis Ofertas de Ingresos
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  my_offers_incomeIconColor = Colors.grey[900]!;
                });
              },
              onExit: (_) {
                setState(() {
                  my_offers_incomeIconColor = Colors.grey[600]!;
                });
              },
              child: ListTile(
                leading:
                    Icon(Icons.person_pin_circle, color: my_offers_incomeIconColor),
                title: Text('Mis Ofertas de Ingresos'),
                onTap: () {
                  Navigator.pushNamed(context, '/my_income_offers');
                },
              ),
            ),
            // Opción Cerrar sesión
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  logoutIconColor = Colors.grey[900]!;
                });
              },
              onExit: (_) {
                setState(() {
                  logoutIconColor = Colors.grey[600]!;
                });
              },
              child: ListTile(
                leading: Icon(Icons.logout, color: logoutIconColor),
                title: Text('Cerrar sesión'),
                onTap: () async {
                  _logout();
                },
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
      SnackBar(
        content: Text('Cierre de sesión exitoso.'),
        duration: Duration(seconds: 1),
        ),
    );
    Navigator.pushNamed(context, '/');
  }
}
