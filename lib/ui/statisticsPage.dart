import 'package:calories_app/component/custom_appbar.dart';
import 'package:calories_app/service/data.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => StatisticsPageState();
}

class StatisticsPageState extends State<StatisticsPage> {
  final List<SelectedListItem> _listOfCities = [
    SelectedListItem(
      name: "kTokyo",
      value: "TYO",
    ),
    SelectedListItem(
      name: "kNewYork",
      value: "NY",
    ),
    SelectedListItem(
      name: "kLondon",
      value: "LDN",
    ),
    SelectedListItem(name: "kParis"),
    SelectedListItem(name: "kMadrid"),
    SelectedListItem(name: "kDubai"),
    SelectedListItem(name: "kRome"),
    SelectedListItem(name: "kBarcelona"),
    SelectedListItem(name: "kCologne"),
    SelectedListItem(name: "kMonteCarlo"),
    SelectedListItem(name: "kPuebla"),
    SelectedListItem(name: "kFlorence"),
  ];

  /// This is register text field controllers.
  final TextEditingController _fullNameTextEditingController =
      TextEditingController();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _phoneNumberTextEditingController =
      TextEditingController();
  final TextEditingController _cityTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _fullNameTextEditingController.dispose();
    _emailTextEditingController.dispose();
    _phoneNumberTextEditingController.dispose();
    _cityTextEditingController.dispose();
    _passwordTextEditingController.dispose();
  }

  List<Map<String, dynamic>> dataMeal = [];
  void _fetchData() async {
    final data = await getMeals();
    setState(() {
      dataMeal = data;
    });
  }

  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Thống kê lượng calo"),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // const Text(
            //   "Thống kê lượng calo",
            //   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            // ),
            Expanded(
              child: ListView.builder(
                itemCount: dataMeal.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(dataMeal[index]['mealName'],
                        style: const TextStyle(fontSize: 18)),
                    subtitle: Text('${dataMeal[index]['calories']} kcal',
                        style: const TextStyle(fontSize: 18)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
