import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final VoidCallback onPlusPressed;
  final String currentPage;

  NavBar({
    required this.onPlusPressed,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[300], // Fondo gris oscuro para el NavBar
        notchMargin: 8.0,
        shape: CircularNotchedRectangle(),
        clipBehavior: Clip.antiAlias,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // Home Icon con color diferente si es la página actual
            IconButton(
              icon: Icon(
                Icons.home,
                color: currentPage == '/home'
                    ? Colors.grey[900]
                    : Colors.white, // Cambio de color
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
            ),
            // Estadísticas Icono
            IconButton(
              icon: Icon(
                Icons.bar_chart,
                color: currentPage == '/statistics'
                    ? Colors.grey[900]
                    : Colors.white, // Cambio de color
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/statistics');
              },
            ),
            SizedBox(width: 48.0), // Espacio para centrar el FAB
            // Transacciones Icono
            IconButton(
              icon: Icon(
                Icons.compare_arrows,
                color: currentPage == '/transactions'
                    ? Colors.grey[900]
                    : Colors.white, // Cambio de color
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/transactions');
              },
            ),
            // Cuentas Icono
            IconButton(
              icon: Icon(
                Icons.account_balance,
                color: currentPage == '/accounts'
                    ? Colors.grey[900]
                    : Colors.white, // Cambio de color
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/accounts');
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked, // Ubicación centrada
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[600], // Color de fondo del botón
        shape: CircleBorder(), // Asegura que el botón sea circular
        child: Icon(Icons.add, color: Colors.black), // El icono del botón "+"
        onPressed: onPlusPressed,
      ),
    );
  }
}
