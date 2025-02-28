class Article {
  String titulo;
  String resumen;
  String contenido;
  String url;
  String imagen;
  DateTime fecha;

  Article({
    required this.titulo,
    required this.resumen,
    required this.contenido,
    required this.url,
    required this.imagen,
    required this.fecha,
  });

  // Crea un Article a partir de un JSON obtenido de la API
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      titulo: json['title'] ?? '',
      resumen: json['description'] ?? '',
      contenido: json['content'] ?? '',
      url: json['url'] ?? '',
      imagen: json['urlToImage'] ?? '',
      fecha: DateTime.tryParse(json['publishedAt'] ?? '') ?? DateTime.now(),
    );
  }

  // Convierte un Article a un Map para guardarlo en Firestore
  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'resumen': resumen,
      'contenido': contenido,
      'url': url,
      'imagen': imagen,
      'fecha': fecha,
    };
  }
}
