import 'package:flutter/material.dart';

class ArticlesPage extends StatelessWidget {
  const ArticlesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artículos Financieros'),
      ),
      body: const Center(
        child: Text('Página de Artículos en blanco'),
      ),
    );
  }
}
