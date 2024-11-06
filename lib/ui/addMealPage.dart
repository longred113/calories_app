import 'dart:convert';

import 'package:calories_app/component/text_field.dart';
import 'package:calories_app/models/food_model.dart';
import 'package:calories_app/service/data.dart';
import 'package:calories_app/service/format.dart';
import 'package:flutter/material.dart';

class AddMealPage extends StatefulWidget {
  const AddMealPage({super.key});

  @override
  State<AddMealPage> createState() => _AddMealPageState();
}

class _AddMealPageState extends State<AddMealPage> {
  List<Food> foods = [];
  List<Food> selectedFoods = [];
  TextEditingController mealText = TextEditingController();
  TextEditingController search = TextEditingController();
  List<Food> filteredFoods = [];
  List<Map<String, dynamic>> mealData = [];

  @override
  void initState() {
    super.initState();
    loadFoodsFromJson();
    getMeals().then((data) {
      setState(() {
        mealData = data;
      });
    });
  }

  void filterFoods(String query) {
    setState(() {
      final normalizedQuery = removeDiacritics(query.toLowerCase());
      filteredFoods = foods.where((food) {
        final normalizedName = removeDiacritics(food.name.toLowerCase());
        return normalizedName.contains(normalizedQuery);
      }).toList();
    });
  }

  Future<void> loadFoodsFromJson() async {
    final String response = await DefaultAssetBundle.of(context)
        .loadString('assets/nutrition_data.json');
    final data = await json.decode(response);
    setState(() {
      foods = (data['thuc_pham'] as List).map((json) {
        final food = Food.fromJson(json);
        food.controller.addListener(() {
          setState(() {
            food.gram = double.tryParse(food.controller.text) ?? 0;
            if (!selectedFoods.contains(food) && food.gram > 0) {
              selectedFoods.add(food);
            }
          });
        });
        return food;
      }).toList();
    });
  }

  double get totalCalories =>
      selectedFoods.fold(0, (sum, food) => sum + food.totalCalories);
  double get totalProtein =>
      selectedFoods.fold(0, (sum, food) => sum + food.totalProtein);
  double get totalFat =>
      selectedFoods.fold(0, (sum, food) => sum + food.totalFat);
  double get totalCarbohydrate =>
      selectedFoods.fold(0, (sum, food) => sum + food.totalCarbs);

  void submitData() async {
    if (mealText.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Dữ liệu chưa được gửi'),
          content: const Text('Vui lòng nhập bữa ăn'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Đóng'),
            ),
          ],
        ),
      );
    }
    if (selectedFoods.isNotEmpty) {
      final now = DateTime.now().toLocal();
      final formData = {
        'mealName': mealText.text,
        'calories': totalCalories.toString(),
        'protein': totalProtein.toString(),
        'fat': totalFat.toString(),
        'carb': totalCarbohydrate.toString(),
        'food':
            selectedFoods.map((food) => '${food.name}-${food.gram}g').toList(),
        'date': '${now.day}/${now.month}/${now.year}',
      };
      final res = await addMealData(formData);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Dữ liệu đã được gửi'),
          content: Text('Tổng calo: ${totalCalories.toStringAsFixed(1)} kcal\n'
              'Tổng protein: ${totalProtein.toStringAsFixed(1)} g\n'
              'Tổng chất béo: ${totalFat.toStringAsFixed(1)} g\n'
              'Tổng carb: ${totalCarbohydrate.toStringAsFixed(1)} g'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Đóng'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Dữ liệu chưa được gửi'),
          content: const Text('Vui lòng chọn thực phẩm'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Đóng'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextField(
                    textEditingController: mealText,
                    title: "Bữa ăn",
                    hint: "Nhập bữa ăn",
                    isDataSelected: false,
                    isNumberInput: false,
                  ),
                  AppTextField(
                    textEditingController: search,
                    title: "Các món ăn",
                    hint: "Tìm kiếm món",
                    isDataSelected: false,
                    isNumberInput: false,
                    onChanged: (value) => filterFoods(value),
                  ),
                  SizedBox(
                    height: 400,
                    child: ListView.builder(
                      itemCount: filteredFoods.isNotEmpty
                          ? filteredFoods.length
                          : foods.length,
                      itemBuilder: (context, index) {
                        final food = filteredFoods.isNotEmpty
                            ? filteredFoods[index]
                            : foods[index];
                        return ListTile(
                          title: Text(food.name),
                          subtitle: Text('Calo/100g: ${food.calorie} kcal'),
                          trailing: SizedBox(
                            width: 100,
                            child: TextField(
                              controller: food.controller,
                              decoration: const InputDecoration(
                                labelText: 'Gram',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  food.gram = double.tryParse(value) ?? 0;
                                  if (!selectedFoods.contains(food)) {
                                    selectedFoods.add(food);
                                  }
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      rowData("Tổng calo", totalCalories.toStringAsFixed(1)),
                      const SizedBox(height: 10),
                      rowData("Tổng protein", totalProtein.toStringAsFixed(1)),
                      const SizedBox(height: 10),
                      rowData("Tổng chất béo", totalFat.toStringAsFixed(1)),
                      const SizedBox(height: 10),
                      rowData(
                          "Tổng carb", totalCarbohydrate.toStringAsFixed(1)),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: submitData,
                    child: const Text('Gửi dữ liệu'),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget rowData(title, value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$title: ',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        Text('$value g',
            style: const TextStyle(fontSize: 15, color: Colors.green)),
      ],
    );
  }
}
