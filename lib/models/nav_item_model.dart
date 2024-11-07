import 'package:calories_app/ui/addPage.dart';
import 'package:calories_app/ui/homePage.dart';
import 'package:calories_app/ui/statisticsPage.dart';
import 'package:flutter/material.dart';

class NavItemModel {
  final String title;
  final Icon icon;
  final Widget screen;

  NavItemModel({required this.title, required this.icon, required this.screen});
}

List<NavItemModel> bottomNavItems = [
  NavItemModel(title: "Trang chủ", icon: Icon(Icons.home), screen: HomePage()),
  NavItemModel(title: "Thêm", icon: Icon(Icons.add), screen: AddPage()),
  NavItemModel(
      title: "Thống kê",
      icon: Icon(Icons.history_outlined),
      screen: StatisticsPage()),
];
