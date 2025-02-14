import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final String icon;
  final Color color;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  // Convertir un objeto a JSON para guardarlo en Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'color': color.value, // Guardamos el color como un número entero
    };
  }

  // Convertir un documento de Firebase en una categoría
  factory Category.fromMap(Map<String, dynamic> map, String id) {
    return Category(
      id: id,
      name: map['name'] ?? '',
      icon: map['icon'] ?? '📂', // Si no hay icono, se asigna uno por defecto
      color: Color(map['color'] ?? 0xFF000000), // Si no hay color, usa negro
    );
  }
}
