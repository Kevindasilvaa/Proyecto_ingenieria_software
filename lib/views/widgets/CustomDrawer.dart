import 'package:flutter/material.dart';
import 'package:moni/controllers/user_controller.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  // Variables para los colores de los íconos y textos
  Color homeIconColor = Colors.grey[400]!;
  Color homeTextColor = Colors.grey[400]!;
  Color profileIconColor = Colors.grey[400]!;
  Color profileTextColor = Colors.grey[400]!;
  Color transactionsIconColor = Colors.grey[400]!;
  Color transactionsTextColor = Colors.grey[400]!;
  Color statisticsIconColor = Colors.grey[400]!;
  Color statisticsTextColor = Colors.grey[400]!;
  Color accountsIconColor = Colors.grey[400]!;
  Color accountsTextColor = Colors.grey[400]!;
  Color categoriesIconColor = Colors.grey[400]!;
  Color categoriesTextColor = Colors.grey[400]!;
  Color articlesIconColor = Colors.grey[400]!;
  Color articlesTextColor = Colors.grey[400]!;
  Color offers_incomeIconColor = Colors.grey[400]!;
  Color offers_incomeTextColor = Colors.grey[400]!;
  Color my_offers_incomeIconColor = Colors.grey[400]!;
  Color my_offers_incomeTextColor = Colors.grey[400]!;
  Color logoutIconColor = Colors.grey[400]!;
  Color logoutTextColor = Colors.grey[400]!;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFF2E4A5A), // Fondo azul oscuro
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // Header
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF2E4A5A), // Fondo azul oscuro
              ),
              child: const Text(
                'Menú',
                style: TextStyle(
                  color: Colors.white, // Texto blanco
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Inicio
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  homeIconColor = Colors.white; // Ícono blanco llamativo
                  homeTextColor = Colors.white; // Texto blanco llamativo
                });
              },
              onExit: (_) {
                setState(() {
                  homeIconColor = Colors.grey[400]!; // Ícono gris
                  homeTextColor = Colors.grey[400]!; // Texto gris suave
                });
              },
              child: ListTile(
                leading: Icon(Icons.home, color: homeIconColor),
                title: Text(
                  'Inicio',
                  style: TextStyle(color: homeTextColor),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/home');
                },
              ),
            ),
            // Transacciones
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  transactionsIconColor = Colors.white;
                  transactionsTextColor = Colors.white;
                });
              },
              onExit: (_) {
                setState(() {
                  transactionsIconColor = Colors.grey[400]!;
                  transactionsTextColor = Colors.grey[400]!;
                });
              },
              child: ListTile(
                leading: Icon(Icons.compare_arrows, color: transactionsIconColor),
                title: Text(
                  'Transacciones',
                  style: TextStyle(color: transactionsTextColor),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/transactions');
                },
              ),
            ),
            // Estadísticas
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  statisticsIconColor = Colors.white;
                  statisticsTextColor = Colors.white;
                });
              },
              onExit: (_) {
                setState(() {
                  statisticsIconColor = Colors.grey[400]!;
                  statisticsTextColor = Colors.grey[400]!;
                });
              },
              child: ListTile(
                leading: Icon(Icons.bar_chart, color: statisticsIconColor),
                title: Text(
                  'Estadísticas',
                  style: TextStyle(color: statisticsTextColor),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/statistics');
                },
              ),
            ),
            // Cuentas
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  accountsIconColor = Colors.white;
                  accountsTextColor = Colors.white;
                });
              },
              onExit: (_) {
                setState(() {
                  accountsIconColor = Colors.grey[400]!;
                  accountsTextColor = Colors.grey[400]!;
                });
              },
              child: ListTile(
                leading: Icon(Icons.account_balance, color: accountsIconColor),
                title: Text(
                  'Cuentas',
                  style: TextStyle(color: accountsTextColor),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/accounts');
                },
              ),
            ),
            // Perfil
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  profileIconColor = Colors.white;
                  profileTextColor = Colors.white;
                });
              },
              onExit: (_) {
                setState(() {
                  profileIconColor = Colors.grey[400]!;
                  profileTextColor = Colors.grey[400]!;
                });
              },
              child: ListTile(
                leading: Icon(Icons.person, color: profileIconColor),
                title: Text(
                  'Perfil',
                  style: TextStyle(color: profileTextColor),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/profile');
                },
              ),
            ),
            // Categorías
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  categoriesIconColor = Colors.white;
                  categoriesTextColor = Colors.white;
                });
              },
              onExit: (_) {
                setState(() {
                  categoriesIconColor = Colors.grey[400]!;
                  categoriesTextColor = Colors.grey[400]!;
                });
              },
              child: ListTile(
                leading: Icon(Icons.category, color: categoriesIconColor),
                title: Text(
                  'Categorías',
                  style: TextStyle(color: categoriesTextColor),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/categories');
                },
              ),
            ),
            // Artículos de Interés
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  articlesIconColor = Colors.white;
                  articlesTextColor = Colors.white;
                });
              },
              onExit: (_) {
                setState(() {
                  articlesIconColor = Colors.grey[400]!;
                  articlesTextColor = Colors.grey[400]!;
                });
              },
              child: ListTile(
                leading: Icon(Icons.article, color: articlesIconColor),
                title: Text(
                  'Artículos de Interés',
                  style: TextStyle(color: articlesTextColor),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/articles');
                },
              ),
            ),
            // Ofertas de Ingresos
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  offers_incomeIconColor = Colors.white;
                  offers_incomeTextColor = Colors.white;
                });
              },
              onExit: (_) {
                setState(() {
                  offers_incomeIconColor = Colors.grey[400]!;
                  offers_incomeTextColor = Colors.grey[400]!;
                });
              },
              child: ListTile(
                leading: Icon(Icons.attach_money, color: offers_incomeIconColor),
                title: Text(
                  'Ofertas de Ingresos',
                  style: TextStyle(color: offers_incomeTextColor),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/income_offers');
                },
              ),
            ),
            // Mis Ofertas de Ingresos
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  my_offers_incomeIconColor = Colors.white;
                  my_offers_incomeTextColor = Colors.white;
                });
              },
              onExit: (_) {
                setState(() {
                  my_offers_incomeIconColor = Colors.grey[400]!;
                  my_offers_incomeTextColor = Colors.grey[400]!;
                });
              },
              child: ListTile(
                leading: Icon(Icons.person_pin_circle, color: my_offers_incomeIconColor),
                title: Text(
                  'Mis Ofertas de Ingresos',
                  style: TextStyle(color: my_offers_incomeTextColor),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/my_income_offers');
                },
              ),
            ),
            // Cerrar Sesión
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  logoutIconColor = Colors.white;
                  logoutTextColor = Colors.white;
                });
              },
              onExit: (_) {
                setState(() {
                  logoutIconColor = Colors.grey[400]!;
                  logoutTextColor = Colors.grey[400]!;
                });
              },
              child: ListTile(
                leading: Icon(Icons.logout, color: logoutIconColor),
                title: Text(
                  'Cerrar sesión',
                  style: TextStyle(color: logoutTextColor),
                ),
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
      const SnackBar(
        content: Text('Cierre de sesión exitoso.'),
        duration: Duration(seconds: 1),
      ),
    );
    Navigator.pushNamed(context, '/');
  }
}
