import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moni/models/dbHelper/articlesServiceApi.dart'; // Asegúrate de que la ruta sea correcta

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({Key? key}) : super(key: key);

  @override
  _ArticlesPageState createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  final NewsApiService _newsApiService = NewsApiService();

  @override
  void initState() {
    super.initState();
    // Puedes actualizar los artículos al iniciar la página, si lo deseas:
    // _newsApiService.fetchAndStoreArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Artículos Financieros"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              await _newsApiService.fetchAndStoreArticles();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Artículos actualizados")),
              );
            },
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Articles') // Consulta a la colección "Articles"
            .orderBy('fecha', descending: true)
            .limit(10)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final articles = snapshot.data!.docs;
          if (articles.isEmpty) {
            return const Center(child: Text("No hay artículos disponibles"));
          }

          return ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final articleData =
                  articles[index].data() as Map<String, dynamic>;
              final title = articleData['titulo'] ?? 'Sin título';
              final summary = articleData['resumen'] ?? '';
              final imageUrl = articleData['imagen'] ?? '';

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: imageUrl.isNotEmpty
                      ? Image.network(imageUrl, width: 100, fit: BoxFit.cover)
                      : null,
                  title: Text(title),
                  subtitle: Text(summary),
                  onTap: () {
                    // Aquí podrías navegar a una página de detalle del artículo
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
