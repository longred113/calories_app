import 'package:calories_app/component/custom_appbar.dart';
import 'package:calories_app/service/data.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double totalCalories = 0;
  double totalCaloPerDay = 0;
  List<Map<String, dynamic>> historyCaloriesToday = [];

  void _addCalories(double calories) {
    setState(() {
      totalCalories += calories;
    });
  }

  void _fetchData() async {
    final now = DateTime.now().toLocal();
    final date = '${now.day}/${now.month}/${now.year}';
    historyCaloriesToday = await getMeals(date: date);
    for (var meal in historyCaloriesToday) {
      _addCalories(double.parse(meal['calories']));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Theo dõi lượng calo"),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Lượng calo cần nạp một ngày",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              '$totalCaloPerDay kcal',
              style: TextStyle(fontSize: 36, color: Colors.green),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'Tổng lượng calo hôm nay',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              '$totalCalories kcal',
              style: TextStyle(fontSize: 36, color: Colors.green),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Divider(),
            const Text('Chi tiết calo hôm nay', style: TextStyle(fontSize: 22)),
            Expanded(
              child: ListView.builder(
                  itemCount: historyCaloriesToday.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        title: Text(
                          '${historyCaloriesToday[index]['mealName']}',
                          style: const TextStyle(fontSize: 20),
                        ),
                        subtitle: Text(
                          '${historyCaloriesToday[index]['calories']} kcal',
                          style: const TextStyle(fontSize: 20),
                        ),
                        trailing: Column(
                          children: [
                            Text(
                              '${historyCaloriesToday[index]['food'].replaceAll("[", "").replaceAll("]", "").replaceAll(",", "\n")}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ));
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
