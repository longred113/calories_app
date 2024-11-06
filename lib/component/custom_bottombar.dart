import 'package:calories_app/models/nav_item_model.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class CustomBottomBar extends StatefulWidget {
  const CustomBottomBar({super.key});

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      avoidBottomPadding: true,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      tabs: List.generate(
        bottomNavItems.length,
        (index) {
          final item = bottomNavItems[index];
          return PersistentTabConfig(
            screen: item.screen,
            item: ItemConfig(icon: item.icon, title: item.title),
          );
        },
      ),
      navBarBuilder: (navBarConfig) => Style9BottomNavBar(
        itemAnimationProperties: const ItemAnimation(
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
        ),
        navBarDecoration: NavBarDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          // color: Colors.black,
        ),
        navBarConfig: navBarConfig,
      ),
    );
  }
}
