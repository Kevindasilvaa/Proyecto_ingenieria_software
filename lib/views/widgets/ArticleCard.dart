// lib/views/widgets/article_card.dart
import 'package:flutter/material.dart';
import 'package:moni/models/clases/article.dart';

class ArticleCard extends StatefulWidget {
  final Article article;
  const ArticleCard({Key? key, required this.article}) : super(key: key);

  @override
  _ArticleCardState createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Alterna entre el estado expandido y compacto
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4.0)],
        ),
        // Usamos constraints para definir el alto según el estado
        constraints: BoxConstraints(
          minHeight: 150,
          maxHeight: _isExpanded ? 400 : 150,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen (si existe)
            if (widget.article.imagen.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  widget.article.imagen,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 8),
            Text(
              widget.article.resumen,
              maxLines: _isExpanded ? null : 12,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              widget.article.resumen,
              maxLines: _isExpanded ? null : 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (_isExpanded) ...[
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(widget.article.contenido),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
