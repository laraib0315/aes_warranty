import 'package:flutter/material.dart';
import 'notification_bell.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBell;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBell = true,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      actions: [
        if (showBell) const NotificationBell(),
        if (actions != null) ...actions!,
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
