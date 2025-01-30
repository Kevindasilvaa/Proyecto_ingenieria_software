import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hello_flutter/models/dbHelper/firebase_options.dart';
import 'package:hello_flutter/views/screens/home.dart';
import 'package:hello_flutter/views/screens/login.dart';
import 'package:hello_flutter/views/screens/profile.dart';
import 'package:hello_flutter/views/screens/settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Aplicación',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => LoginPage(), // Ruta inicial
        '/home': (context) => HomePage(), // Ruta para la pantalla de inicio
        '/settings': (context) => SettingsPage(),
        '/profile': (context) => ProfilePage(),
      },
      initialRoute: '/', // Ruta inicial de la aplicación
    );
  }
}