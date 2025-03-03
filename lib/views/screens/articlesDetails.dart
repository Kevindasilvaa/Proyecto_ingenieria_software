// lib/views/screens/article_detail_page.dart
import 'package:flutter/material.dart';
import 'package:moni/models/clases/article.dart';

class ArticleDetailPage extends StatelessWidget {
  final Article article;
  const ArticleDetailPage({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Procesamos el contenido para insertar saltos de línea en cada punto y aparte.
    String processedContent = article.contenido.replaceAll('. ', '.\n\n');

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Hero(
              tag: article.titulo, // mismo tag que en la miniatura
              child: Container(
                width: double.infinity,
                height: double.infinity,
                padding: const EdgeInsets.all(16),
                // Sin bordes redondeados
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF69BFA0),
                      Color(0xFFF2F2F2),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                // Todo el contenido es scrolleable
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                          height: 60), // Espacio para el botón de cerrar
                      Center(
                        child: Text(
                          article.titulo,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B4E59),
                          ),
                        ),
                      ),
                      // Imagen centrada debajo del título
                      if (article.imagen.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(
                            child: Image.network(
                              article.imagen,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      Text(
                        processedContent,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Botón de cerrar (X)
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                icon:
                    const Icon(Icons.close, size: 30, color: Color(0xFF1B4E59)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
