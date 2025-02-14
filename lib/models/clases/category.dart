// import 'package:flutter/material.dart';

// class Category {
//   final String id;
//   final String name;
//   final String icon;
//   final Color color;
//   final String user_email;

//   Category({
//     required this.id,
//     required this.name,
//     required this.icon,
//     required this.color,
//     required this.user_email,
//   });

//   // Convertir un objeto a JSON para guardarlo en Firebase
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'name': name,
//       'icon': icon,
//       'color': color.value, // Guardamos el color como un número entero
//       'user_email':user_email,
//     };
//   }

//   // Convertir un documento de Firebase en una categoría
//   factory Category.fromMap(Map<String, dynamic> map, String id) {
//     return Category(
//       id: id,
//       name: map['name'] ?? '',
//       icon: map['icon'] ?? '📂', // Si no hay icono, se asigna uno por defecto
//       color: Color(map['color'] ?? 0xFF000000), // Si no hay color, usa negro
//       user_email: map['user_email'],
//     );
//   }
// }
import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final String icon;
  final Color color;
  final String user_email;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.user_email,
  });

  // Convertir un objeto a JSON para guardarlo en Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'color': color.value, // Guardamos el color como un número entero
      'user_email': user_email,
    };
  }

  // Convertir un documento de Firebase en una categoría
  factory Category.fromMap(Map<String, dynamic> map, String id) {
    // Verificar si el email es nulo y asignar un valor predeterminado
    String? email = map['user_email'];

    // Si user_email es nulo, se asigna un valor genérico para todos los usuarios
    if (email == null || email.isEmpty) {
      email = 'all_users@domain.com'; // Valor para indicar acceso a todos los usuarios
    }

    return Category(
      id: id,
      name: map['name'] ?? '', // Nombre vacío si no está presente
      icon: map['icon'] ?? '📂', // Icono por defecto si no está presente
      color: Color(map['color'] ?? 0xFF000000), // Color por defecto si no está presente
      user_email: email, // Email asignado
    );
  }
}

