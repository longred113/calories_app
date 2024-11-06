import 'dart:convert';

import 'package:calories_app/component/custom_appbar.dart';
import 'package:calories_app/ui/addMealPage.dart';
import 'package:calories_app/ui/calCaloPerDate.dart';
import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _foodController = TextEditingController();
  final _calorieController = TextEditingController();
  final _gramController = TextEditingController();
  Map<String, dynamic>? _nutritionData;
  String? _selectedFood;
  double _calories = 0;
  double _protein = 0;

  List daaa = [
    {"title": "Calo mỗi bữa ăn"},
    {
      "title": "Calo cần nạp mỗi ngày",
    }
  ];

  void _submitData() {
    final enteredFood = _foodController.text;
    final enteredCalories = int.tryParse(_calorieController.text);

    if (enteredFood.isEmpty ||
        enteredCalories == null ||
        enteredCalories <= 0) {
      return;
    }

    // widget.onAddCalories(enteredCalories);
    // _foodController.clear();
    // _calorieController.clear();
  }

  Future<void> _loadNutritionData() async {
    final String response = await DefaultAssetBundle.of(context)
        .loadString('assets/nutrition_data.json');
    final data = await json.decode(response);
    setState(() {
      _nutritionData = {
        for (var item in data['thuc_pham'])
          item['ten']: {
            'calo': item['calo'],
            'protein': item['protein'],
          },
      };
    });
  }

  void _updateCalories() {
    final enteredGrams = double.tryParse(_gramController.text) ?? 0;
    if (_selectedFood != null && _nutritionData != null) {
      final caloPer100g = _nutritionData![_selectedFood]!['calo'];
      final proteinPer100g = _nutritionData![_selectedFood]!['protein'];
      setState(() {
        _protein = (enteredGrams / 100) * proteinPer100g;
        _calories = (enteredGrams / 100) * caloPer100g;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadNutritionData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: CustomAppBar(
          bottom: TabBar(
            dividerHeight: 0,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              for (int i = 0; i < daaa.length; i++)
                Tab(
                  text: daaa[i]['title'],
                )
            ],
          ),
        ),
        body: TabBarView(children: [
          AddMealPage(),
          CalCaloPerDate(),
        ]),
      ),
    );
  }

  Widget next() {
    return Column(
      children: [
        if (_nutritionData != null)
          DropdownButton<String>(
            hint: Text("Chọn món ăn"),
            value: _selectedFood,
            items: _nutritionData!.keys.map((food) {
              return DropdownMenuItem(
                value: food,
                child: Text(food),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedFood = value;
                _updateCalories();
              });
            },
          ),
        TextField(
          controller: _gramController,
          decoration: InputDecoration(labelText: 'Số gram'),
          keyboardType: TextInputType.number,
          onChanged: (_) => _updateCalories(),
        ),
        TextField(
          controller: _calorieController,
          decoration: InputDecoration(labelText: 'Lượng calo'),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10),
        Text("Lượng calo: ${_calories.toStringAsFixed(2)} kcal"),
        SizedBox(height: 10),
        Text("Protein: ${_protein.toStringAsFixed(1)} gr"),
        ElevatedButton(
          onPressed: _submitData,
          child: Text('Thêm'),
        ),
      ],
    );
  }
}
