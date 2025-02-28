import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moni/models/clases/article.dart';

class NewsApiService {
  // API key de NewsAPI (nota: exponerla en producción no es seguro)
  final String apiKey = '46d4671133844f18ad1b5b34e3063158';

  // Método para extraer artículos de NewsAPI y guardarlos en Firestore
  Future<void> fetchAndStoreArticles() async {
    // Se usa el endpoint "everything" para obtener artículos en general,
    // se limita la respuesta a 10 resultados con pageSize=10.
    final url =
        'https://newsapi.org/v2/everything?q=noticias&language=es&pageSize=10&apiKey=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      print("Response status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['articles'] == null) {
          print("No se encontraron artículos en la respuesta");
          return;
        }
        final List<dynamic> articlesJson = data['articles'];
        print("Número de artículos recibidos: ${articlesJson.length}");
        final FirebaseFirestore firestore = FirebaseFirestore.instance;

        for (var articleJson in articlesJson) {
          // Convertir el JSON a nuestro modelo Article
          Article article = Article.fromJson(articleJson);
          print("Procesando artículo: ${article.titulo}");

          // Convertir el campo fecha a Timestamp para Firestore
          Map<String, dynamic> articleMap = article.toMap();
          if (articleMap['fecha'] is DateTime) {
            articleMap['fecha'] = Timestamp.fromDate(article.fecha);
          }

          // Verificar si el artículo ya existe usando la URL como identificador único
          final querySnapshot = await firestore
              .collection(
                  'Articles') // Asegúrate de usar el nombre correcto de la colección
              .where('url', isEqualTo: article.url)
              .get();

          if (querySnapshot.docs.isEmpty) {
            await firestore.collection('Articles').add(articleMap);
            print("Artículo agregado: ${article.titulo}");
          } else {
            print("El artículo ya existe: ${article.titulo}");
          }
        }
        print(
            'Proceso finalizado: Artículos extraídos y guardados correctamente.');
      } else {
        print('Error al obtener noticias: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al extraer artículos: $e');
    }
  }
}
