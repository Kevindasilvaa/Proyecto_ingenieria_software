// lib/views/screens/articles.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moni/models/clases/article.dart';
import 'package:moni/views/widgets/articleCard.dart';

class ArticlesPage extends StatelessWidget {
  const ArticlesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dimensiones del viewport
    final viewportHeight = MediaQuery.of(context).size.height;
    final viewportWidth = MediaQuery.of(context).size.width;

    // Definimos las dimensiones deseadas para cada tarjeta en teléfonos:
    final double phoneCardHeight = viewportHeight * 0.47;
    final double phoneCardWidth = viewportWidth * 0.64;

    // Determinamos si estamos en teléfono (ancho menor a 600)
    final bool isPhone = viewportWidth < 600;

    if (isPhone) {
      // Para teléfonos, se muestra una tarjeta por fila, centrada
      return Scaffold(
        appBar: AppBar(
          title: const Text("Artículos Financieros"),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Articulos')
              .orderBy('Fecha', descending: true)
              .limit(10)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No hay artículos disponibles"));
            }
            List<Article> articles = snapshot.data!.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              return Article(
                titulo: data['Titulo'] ?? '',
                resumen: data['Resumen'] ?? '',
                contenido: data['Contenido'] ?? '',
                imagen: data['Imagen'] ?? '',
                fecha: (data['Fecha'] as Timestamp).toDate(),
              );
            }).toList();

            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: articles.length,
              itemBuilder: (context, index) {
                return Center(
                  child: SizedBox(
                    width: phoneCardWidth,
                    height: phoneCardHeight,
                    child: ArticleCard(article: articles[index]),
                  ),
                );
              },
            );
          },
        ),
      );
    } else {
      // Para dispositivos anchos, usamos un GridView de 2 columnas.
      // Calculamos el ancho disponible para cada tarjeta en el grid.
      final double crossAxisSpacing = 8.0;
      final double totalHorizontalPadding =
          8.0 * 2; // padding general del GridView
      final double availableWidth =
          viewportWidth - totalHorizontalPadding - crossAxisSpacing;
      final double gridCardWidth = availableWidth / 2;
      final double gridCardHeight = viewportHeight * 0.80;
      final double childAspectRatio = gridCardWidth / gridCardHeight;

      return Scaffold(
        appBar: AppBar(
          title: const Text("Artículos Financieros"),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Articulos')
              .orderBy('Fecha', descending: true)
              .limit(10)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No hay artículos disponibles"));
            }
            List<Article> articles = snapshot.data!.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              return Article(
                titulo: data['Titulo'] ?? '',
                resumen: data['Resumen'] ?? '',
                contenido: data['Contenido'] ?? '',
                imagen: data['Imagen'] ?? '',
                fecha: (data['Fecha'] as Timestamp).toDate(),
              );
            }).toList();

            return GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: crossAxisSpacing,
                mainAxisSpacing: 8.0,
                childAspectRatio: childAspectRatio,
              ),
              itemCount: articles.length,
              itemBuilder: (context, index) {
                return ArticleCard(article: articles[index]);
              },
            );
          },
        ),
      );
    }
  }
}
