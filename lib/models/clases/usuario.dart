import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  final String id;
  final String email;
  final String? name;
  final String? gender;
  final DateTime? birthdate;
  final String? country;
  final String? phone_number;
  final double? monthlyIncomeBudget; // Presupuesto de ingreso mensual
  final double? monthlyExpenseBudget; // Presupuesto de gasto mensual

  const Usuario({
    required this.id,
    required this.email,
    this.name,
    this.gender,
    this.birthdate,
    this.country,
    this.phone_number,
    this.monthlyIncomeBudget,
    this.monthlyExpenseBudget,
  });

  // Método para convertir a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'gender': gender,
      'birthdate': birthdate != null ? Timestamp.fromDate(birthdate!) : null,
      'country': country,
      'phone_number': phone_number,
      'monthlyIncomeBudget': monthlyIncomeBudget,
      'monthlyExpenseBudget': monthlyExpenseBudget,
    };
  }

  // Método para convertir desde Map
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      email: map['email'],
      name: map['name'],
      gender: map['gender'],
      birthdate: map['birthdate'] != null ? (map['birthdate'] as Timestamp).toDate() : null,
      country: map['country'],
      phone_number: map['phone_number'],
      monthlyIncomeBudget: map['monthlyIncomeBudget']?.toDouble(), // Convertir a double si existe
      monthlyExpenseBudget: map['monthlyExpenseBudget']?.toDouble(), // Convertir a double si existe
    );
  }
}