import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:moni/controllers/user_controller.dart';
import 'package:moni/models/dbHelper/firebase_options.dart';
import 'package:moni/views/screens/CreateAccount.dart';
import 'package:moni/views/screens/home.dart';
import 'package:moni/views/screens/login.dart';
import 'package:moni/views/screens/profile.dart';
import 'package:moni/views/screens/settings.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => UserController(),  // Crear el UserController
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moni',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white, // Color de fondo blanco para las paginas
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white, // Color de AppBar (titulos) blanco
        ),
      ),
      // Rutas de la aplicación
      routes: {
        '/': (context) => LoginPage(),
        '/createAccount': (context) => CreateAccountPage(),
        '/home': (context) => HomePage(),
        '/settings': (context) => SettingsPage(),
        '/profile': (context) => ProfilePage(),
      },
      initialRoute: '/', // Ruta inicial de la aplicación
    );
  }
}