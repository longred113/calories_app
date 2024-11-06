import 'dart:convert';

import 'package:calories_app/component/text_field.dart';
import 'package:calories_app/models/activity_calorie_index_model.dart';
import 'package:calories_app/service/data.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';

class CalCaloPerDate extends StatefulWidget {
  const CalCaloPerDate({super.key});

  @override
  State<CalCaloPerDate> createState() => _CalCaloPerDateState();
}

class _CalCaloPerDateState extends State<CalCaloPerDate> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _activityController = TextEditingController();
  double totalCaloPerDay = 0;

  void submitData() async {
    final weight = int.tryParse(_weightController.text);
    final height = int.tryParse(_heightController.text);
    final age = int.tryParse(_ageController.text);
    final activityValue = await getValueFormTitle(_activityController.text);
    final totalCalories =
        (await calBMR(age, weight, height, "Nam")) * activityValue;

    setState(() {
      this.totalCaloPerDay = totalCalories;
    });
  }

  Future<double> getValueFormTitle(String title) async {
    final matchedItem = activityCalorieIndexList.firstWhere(
      (activate) => activate.title == title,
      orElse: () =>
          ActivityCalorieIndexModel(title: '', description: '', value: 0.0),
    );
    return matchedItem.value;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Tổng calo cần nạp mỗi ngày',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          AppTextField(
            textEditingController: _weightController,
            title: "Cân nặng",
            hint: "Nhập cân nặng",
            isDataSelected: false,
            isNumberInput: true,
          ),
          AppTextField(
            textEditingController: _heightController,
            title: "Chiều cao(cm)",
            hint: "Nhập chiều cao(cm)",
            isDataSelected: false,
            isNumberInput: true,
          ),
          AppTextField(
            textEditingController: _ageController,
            title: "Tuổi",
            hint: "Nhập tuổi",
            isDataSelected: false,
            isNumberInput: true,
          ),
          AppTextField(
            textEditingController: _activityController,
            title: "Vận động",
            hint: "Chọn loại vận động",
            isDataSelected: true,
            isNumberInput: false,
            isRead: true,
            isMultiSelect: false,
            selectList: activityCalorieIndexList
                .map((activity) => SelectedListItem(
                      value: activity.value.toString(),
                      name: '${activity.title}\n${activity.description}',
                    ))
                .toList(),
          ),
          Text(
            'Tổng calo: ${totalCaloPerDay.toStringAsFixed(1)} kcal',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 12), // Khoảng cách trong của nút
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Bo góc của nút
                ),
                shadowColor: Colors.black, // Màu của bóng
                elevation: 5, // Độ cao của nút (bóng đổ)
              ),
              onPressed: () {
                submitData();
              },
              child: const Text(
                "Xác nhận",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
