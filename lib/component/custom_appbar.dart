import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final String? title;
  final List<Widget>? action;
  final PreferredSizeWidget? bottom;
  const CustomAppBar({
    super.key,
    this.leading,
    this.action,
    this.bottom,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: leading,
      title: Text(title ?? ''),
      actions: action,
      bottom: bottom,
      // elevation: 10,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
