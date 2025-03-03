// lib/views/screens/articles.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moni/models/clases/article.dart';
import 'package:moni/views/widgets/ArticleCard.dart';

class ArticlesPage extends StatelessWidget {
  const ArticlesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtenemos las dimensiones del viewport.
    final viewportHeight = MediaQuery.of(context).size.height;
    final viewportWidth = MediaQuery.of(context).size.width;

    // Queremos que cada tarjeta tenga el 70% de la altura del viewport.
    final cardHeight = viewportHeight * 0.7;

    // Suponiendo un padding general y spacing, vamos a calcular el ancho de cada tarjeta.
    // Por ejemplo, si usamos un padding de 8 en cada lado y un crossAxisSpacing de 8:
    final totalHorizontalPadding = 8 * 2; // padding de la GridView
    final crossAxisSpacing = 8.0;
    // Para 2 columnas, el ancho disponible es:
    final availableWidth =
        viewportWidth - totalHorizontalPadding - crossAxisSpacing;
    final cardWidth = availableWidth / 2;

    // Calculamos el childAspectRatio = ancho / altura.
    final childAspectRatio = cardWidth / cardHeight;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Artículos Financieros"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Articulos') // Nombre exacto de la colección
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
              crossAxisCount: 2, // 2 columnas
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
