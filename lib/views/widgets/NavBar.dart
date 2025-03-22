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
        color: Color(0xFF2E4A5A), // Fondo azul oscuro
        notchMargin: 8.0,
        shape: CircularNotchedRectangle(),
        clipBehavior: Clip.antiAlias,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // Home Icon
            IconButton(
              icon: Icon(
                Icons.home,
                color: currentPage == '/home'
                    ? Colors.white // Blanco más llamativo para el icono activo
                    : Colors.grey[400], // Color gris claro para inactivos
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
                    ? Colors.white
                    : Colors.grey[400],
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
                    ? Colors.white
                    : Colors.grey[400],
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
                    ? Colors.white
                    : Colors.grey[400],
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
        backgroundColor: Color(0xFF5DA6A7), // Color verde
        shape: CircleBorder(), // Botón circular
        child: Icon(Icons.add, color: Colors.white), // El signo "+"
        onPressed: onPlusPressed,
      ),
    );
  }
}
