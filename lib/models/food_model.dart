import 'package:flutter/material.dart';

class Food {
  final String name;
  final double calorie;
  final double carb;
  final double protein;
  final double fat;
  final TextEditingController controller = TextEditingController();
  double gram;

  Food({
    required this.name,
    required this.calorie,
    required this.carb,
    required this.protein,
    required this.fat,
    this.gram = 0,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      name: json['ten'],
      calorie: json['calo'].toDouble(),
      carb: json['carb'].toDouble(),
      protein: json['protein'].toDouble(),
      fat: json['fat'].toDouble(),
    );
  }

  double get totalCalories => (calorie * gram) / 100;
  double get totalCarbs => (carb * gram) / 100;
  double get totalProtein => (protein * gram) / 100;
  double get totalFat => (fat * gram) / 100;
}
