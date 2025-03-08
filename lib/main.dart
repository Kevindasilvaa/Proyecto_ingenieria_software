import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:moni/controllers/income_offers_controller.dart';
import 'package:moni/controllers/user_controller.dart';
import 'package:moni/controllers/category_controller.dart';
import 'package:moni/controllers/cuenta_controller.dart';
import 'package:moni/models/dbHelper/firebase_options.dart';
import 'package:moni/views/screens/accounts.dart';
import 'package:moni/views/screens/categories.dart';
import 'package:moni/views/screens/incomeOffers.dart';
import 'package:moni/views/screens/myIncomeOffers.dart';
import 'package:moni/views/screens/register.dart';
import 'package:moni/views/screens/home.dart';
import 'package:moni/views/screens/login.dart';
import 'package:moni/views/screens/profile.dart';
import 'package:moni/views/screens/statistics.dart';
import 'package:moni/views/screens/transactions.dart';
import 'package:provider/provider.dart';
import 'package:moni/views/screens/addTransactions.dart';
import 'package:moni/views/screens/addAccount.dart';
import 'package:moni/views/screens/articles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserController()),
        ChangeNotifierProvider(create: (_) => CategoryController()),
        ChangeNotifierProvider(create: (_) => CuentaController()),
        ChangeNotifierProvider(create: (_) => IncomeOffersController()),
        // ... otros providers
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);

    // Este método debe ejecutarse solo una vez, al inicio
    // Verificamos si el usuario ya está autenticado y escuchamos cambios de autenticación
    // Es importante que lo hagas solo una vez
    userController.startAuthListener(context);

    return MaterialApp(
      title: 'Moni',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor:
            Colors.white, // Color de fondo blanco para las paginas
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white, // Color de AppBar (titulos) blanco
        ),
      ),
      // Rutas de la aplicación
      routes: {
        '/': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => HomePage(),
        '/profile': (context) => ProfilePage(),
        '/addTransactions': (context) => AddTransactionsPage(),
        '/transactions': (context) => TransactionsPage(),
        '/statistics': (context) => StatisticsPage(),
        '/income_offers': (context) => IncomeOffersPage(),
        '/my_income_offers': (context) => MyIncomeOffersPage(),
        '/categories': (context) => CategoriesPage(),
        '/accounts': (context) => AccountsPage(),
        '/addAccounts': (context) => AddAccountPage(),
        '/articles': (context) => ArticlesPage(),
      },
      initialRoute: '/home', // Ruta inicial de la aplicación
    );
  }
}
