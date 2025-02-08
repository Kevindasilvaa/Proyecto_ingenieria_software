import 'package:flutter/material.dart';
import 'package:moni/controllers/user_controller.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  // Variable para almacenar el color del icono cuando el cursor está sobre él
  Color homeIconColor = Colors.grey[600]!;
  Color profileIconColor = Colors.grey[600]!;
  Color settingsIconColor = Colors.grey[600]!;
  Color logoutIconColor = Colors.grey[600]!;
  Color statisticsIconColor = Colors.grey[600]!;
  Color accountsIconColor = Colors.grey[600]!;
  Color categoriesIconColor = Colors.grey[600]!;
  Color offers_incomeIconColor = Colors.grey[600]!;
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
                  color: Colors.black, // Color del texto del header
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),           
            ),
            // Opciones del menú con iconos visibles y resaltado al pasar el cursor
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  homeIconColor = Colors.grey[900]!; // Gris más oscuro al pasar el cursor
                });
              },
              onExit: (_) {
                setState(() {
                  homeIconColor = Colors.grey[600]!; // Restaura el color original
                });
              },
              child: ListTile(
                leading: Icon(Icons.home, color: homeIconColor), // Solo cambia el color del icono de Home
                title: Text('Inicio'),
                onTap: () {
                  Navigator.pushNamed(context, '/home');
                },
              ),
            ),
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  transactionsIconColor = Colors.grey[900]!; // Gris más oscuro al pasar el cursor
                });
              },
              onExit: (_) {
                setState(() {
                  transactionsIconColor = Colors.grey[600]!; // Restaura el color original
                });
              },
              child: ListTile(
                leading: Icon(Icons.compare_arrows, color: transactionsIconColor), // Solo cambia el color del icono de Home
                title: Text('Transacciones'),
                onTap: () {
                  Navigator.pushNamed(context, '/transactions');
                },
              ),
            ),
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  statisticsIconColor = Colors.grey[900]!; // Gris más oscuro al pasar el cursor
                });
              },
              onExit: (_) {
                setState(() {
                  statisticsIconColor = Colors.grey[600]!; // Restaura el color original
                });
              },
              child: ListTile(
                leading: Icon(Icons.bar_chart, color: statisticsIconColor), // Solo cambia el color del icono de Home
                title: Text('Estadísticas'),
                onTap: () {
                  Navigator.pushNamed(context, '/statistics');
                },
              ),
            ),
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  accountsIconColor = Colors.grey[900]!; // Gris más oscuro al pasar el cursor
                });
              },
              onExit: (_) {
                setState(() {
                  accountsIconColor = Colors.grey[600]!; // Restaura el color original
                });
              },
              child: ListTile(
                leading: Icon(Icons.account_balance, color: accountsIconColor), // Solo cambia el color del icono de Home
                title: Text('Cuentas'),
                onTap: () {
                  Navigator.pushNamed(context, '/accounts');
                },
              ),
            ),
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  profileIconColor = Colors.grey[900]!; // Gris más oscuro al pasar el cursor
                });
              },
              onExit: (_) {
                setState(() {
                  profileIconColor = Colors.grey[600]!; // Restaura el color original
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
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  categoriesIconColor = Colors.grey[900]!; // Gris más oscuro al pasar el cursor
                });
              },
              onExit: (_) {
                setState(() {
                  categoriesIconColor = Colors.grey[600]!; // Restaura el color original
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
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  offers_incomeIconColor = Colors.grey[900]!; // Gris más oscuro al pasar el cursor
                });
              },
              onExit: (_) {
                setState(() {
                  offers_incomeIconColor = Colors.grey[600]!; // Restaura el color original
                });
              },
              child: ListTile(
                leading: Icon(Icons.attach_money, color: offers_incomeIconColor),
                title: Text('Ofertas de Ingresos'),
                onTap: () {
                  Navigator.pushNamed(context, '/income_offers');
                },
              ),
            ),
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  settingsIconColor = Colors.grey[900]!; // Gris más oscuro al pasar el cursor
                });
              },
              onExit: (_) {
                setState(() {
                  settingsIconColor = Colors.grey[600]!; // Restaura el color original
                });
              },
              child: ListTile(
                leading: Icon(Icons.settings, color: settingsIconColor),
                title: Text('Configuración'),
                onTap: () {
                  Navigator.pushNamed(context, '/settings');
                },
              ),
            ),
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  logoutIconColor = Colors.grey[900]!; // Gris más oscuro al pasar el cursor
                });
              },
              onExit: (_) {
                setState(() {
                  logoutIconColor = Colors.grey[600]!; // Restaura el color original
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cierre de sesión exitoso.')));
    Navigator.pushNamed(context, '/');
  }
}