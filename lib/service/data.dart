import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

Future<double> calBMR(age, weight, height, gender) async {
  if (gender == "Nam") {
    return Future.value(
        (13.397 * weight) + (4.799 * height) - (5.677 * age) + 88.362);
  } else {
    return Future.value(
        (9.247 * weight) + (3.098 * height) - (4.330 * age) + 447.593);
  }
}

Future<double> totalCaloNeedEachDay(bmr, R) {
  return bmr * R;
}

Future<bool> addMealData(Map<String, Object> formData) async {
  final calories = formData['calories'];
  final carb = formData['carb'];
  final fat = formData['fat'];
  final protein = formData['protein'];
  final mealName = formData['mealName'];
  final food = formData['food'];
  final date = formData['date'];
  final prefs = await SharedPreferences.getInstance();
  List<String> mealData = prefs.getStringList('meals') ?? [];
  int id = mealData.isNotEmpty ? int.parse(mealData.last.split('|')[0]) + 1 : 0;
  mealData.add('$id|$calories|$carb|$fat|$protein|$mealName|$food|$date');
  final data = prefs.setStringList('meals', mealData);
  return data;
}

Future<List<Map<String, dynamic>>> getMeals({String? date}) async {
  final prefs = await SharedPreferences.getInstance();
  final mealData = prefs.getStringList('meals') ?? [];
  if (date != null) {
    return mealData
        .where((meal) => meal.split('|')[7].contains(date))
        .map((meal) => {
              'id': meal.split('|')[0],
              'calories': meal.split('|')[1],
              'carb': meal.split('|')[2],
              'fat': meal.split('|')[3],
              'protein': meal.split('|')[4],
              'mealName': meal.split('|')[5],
              'food': meal.split('|')[6],
            })
        .toList();
  } else {
    return mealData
        .map((meal) => {
              'id': meal.split('|')[0],
              'calories': meal.split('|')[1],
              'carb': meal.split('|')[2],
              'fat': meal.split('|')[3],
              'protein': meal.split('|')[4],
              'mealName': meal.split('|')[5],
              'food': meal.split('|')[6],
              'date': meal.split('|')[7],
            })
        .toList();
  }
}

Future<bool> addCaloPerDate(Map<String, Object> formData) async {
  final calo = formData['calo'];
  final date = formData['date'];
  final prefs = await SharedPreferences.getInstance();
  final data = prefs.setString('$date', calo.toString());
  return data;
}

Future<void> delete() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.clear();
}
