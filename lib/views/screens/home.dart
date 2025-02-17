// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:moni/controllers/cuenta_controller.dart';
// import 'package:moni/controllers/user_controller.dart';
// import 'package:provider/provider.dart';
// import 'package:moni/views/widgets/NavBar.dart';
// import 'package:moni/views/widgets/CustomDrawer.dart';
// import 'package:moni/views/widgets/RecentTransactionsView.dart';

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       FirebaseAuth.instance.authStateChanges().listen((User? user) {
//         if (user == null) {
//           Navigator.of(context).pushNamed('/');
//         } else {
//           _loadData(user);
//         }
//       });
//     });
//   }

//   Future<void> _loadData(User user) async {
//     final cuentaController = Provider.of<CuentaController>(context, listen: false);

//     try {
//       await cuentaController.cargarCuentas(user.email!);
//       setState(() {
//         _isLoading = false;
//       });
//     } catch (error) {
//       print('Error al cargar datos: $error');
//       setState(() {
//         _isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error al cargar las cuentas: $error')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final userController = Provider.of<UserController>(context);
//     final cuentaController = Provider.of<CuentaController>(context); // Access cuentaController here

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFFFFFFF),
//         title: const Text('Home', style: TextStyle(color: Colors.black)),
//         iconTheme: const IconThemeData(color: Colors.black),
//       ),
//       drawer: CustomDrawer(),
//       body: Column(
//         children: [
//           Expanded(
//             child: _isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : SafeArea(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildBalanceCard(cuentaController), // Pass cuentaController
//                     const SizedBox(height: 20),
//                     const Text('Recent Transactions',
//                         style: TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 10),
//                     Expanded(
//                       child: RecentTransactionsView(),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Container(
//             height: 80.0,
//             child: NavBar(
//               onPlusPressed: () {
//                 Navigator.of(context).pushNamed('/addTransactions');
//               },
//               currentPage: '/home',
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBalanceCard(CuentaController cuentaController) { // Receive cuentaController
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF2F2F2),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text('Total Balance', style: TextStyle(fontSize: 16)),
//           Text(
//             '\$${cuentaController.calcularBalanceTotal()}',
//             style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 children: [
//                   const Text('Total Income',
//                       style: TextStyle(color: Colors.green)),
//                   Text('\$${'Falta por hacer'}',
//                       style: const TextStyle(color: Colors.green)),
//                 ],
//               ),
//               Column(
//                 children: [
//                   const Text('Total Expense',
//                       style: TextStyle(color: Colors.red)),
//                   Text('-\$${'Falta por hacer'}',
//                       style: const TextStyle(color: Colors.red)),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _logout() async {
//     final userController = Provider.of<UserController>(context, listen: false);
//     await userController.logOut();
//     ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Cierre de sesión exitoso.')));
//     Navigator.pushNamed(context, '/');
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moni/controllers/cuenta_controller.dart';
import 'package:moni/controllers/user_controller.dart';
import 'package:provider/provider.dart';
import 'package:moni/views/widgets/NavBar.dart';
import 'package:moni/views/widgets/CustomDrawer.dart';
import 'package:moni/views/widgets/RecentTransactionsView.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          Navigator.of(context).pushNamed('/');
        } else {
          _loadData(user);
        }
      });
    });
  }

  Future<void> _loadData(User user) async {
    final cuentaController = Provider.of<CuentaController>(context, listen: false);

    try {
      await cuentaController.cargarCuentas(user.email!);
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print('Error al cargar datos: $error');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar las cuentas: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cuentaController = Provider.of<CuentaController>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        title: const Text('Home', style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      drawer: CustomDrawer(),
      body: Column( // <-- Main Column
        children: [
          Expanded( // <-- Expanded for the main content
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding( // <-- Padding instead of SafeArea
              padding: const EdgeInsets.all(16.0),
              child: Column( // <-- Column inside Padding
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBalanceCard(cuentaController),
                  const SizedBox(height: 20),
                  const Text('Recent Transactions',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Expanded(
                    child: RecentTransactionsView(),
                  ),
                ],
              ),
            ),
          ),
          Container( // <-- NavBar remains outside Expanded
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
    );
  }

  Widget _buildBalanceCard(CuentaController cuentaController) { // Receive cuentaController
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Total Balance', style: TextStyle(fontSize: 16)),
          Text(
            '\$${cuentaController.calcularBalanceTotal()}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const Text('Total Income',
                      style: TextStyle(color: Colors.green)),
                  Text('\$${'Falta por hacer'}',
                      style: const TextStyle(color: Colors.green)),
                ],
              ),
              Column(
                children: [
                  const Text('Total Expense',
                      style: TextStyle(color: Colors.red)),
                  Text('-\$${'Falta por hacer'}',
                      style: const TextStyle(color: Colors.red)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    final userController = Provider.of<UserController>(context, listen: false);
    await userController.logOut();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cierre de sesión exitoso.')));
    Navigator.pushNamed(context, '/');
  }
}