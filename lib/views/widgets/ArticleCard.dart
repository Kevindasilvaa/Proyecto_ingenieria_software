// lib/views/widgets/article_card.dart
import 'package:flutter/material.dart';
import 'package:moni/models/clases/article.dart';
import 'package:moni/views/screens/articlesDetails.dart';

class ArticleCard extends StatelessWidget {
  final Article article;
  const ArticleCard({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calcula la altura de la tarjeta como el 70% del viewport.
    final viewportHeight = MediaQuery.of(context).size.height;
    final cardHeight = viewportHeight * 0.7;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(seconds: 1),
            pageBuilder: (context, animation, secondaryAnimation) =>
                ArticleDetailPage(article: article),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      },
      child: Hero(
        tag: article.titulo, // Usamos el título como tag; debe ser único.
        flightShuttleBuilder: (flightContext, animation, flightDirection,
            fromHeroContext, toHeroContext) {
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          );
          return ScaleTransition(
            scale: curvedAnimation,
            child: FadeTransition(
              opacity: curvedAnimation,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 174, 226, 227),
                      Color(0xFF5DA6A7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          );
        },
        child: Container(
          height: cardHeight,
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 174, 226, 227),
                Color(0xFF5DA6A7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                offset: const Offset(0, 4),
                blurRadius: 6,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen (si existe)
              if (article.imagen.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    article.imagen,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  article.titulo,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B4E59),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    article.resumen,
                    textAlign: TextAlign.justify,
                    style:
                        const TextStyle(fontSize: 14, color: Color(0xFF1B4E59)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
