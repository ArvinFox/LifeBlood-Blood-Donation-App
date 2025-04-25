import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomMainAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showLeading;
  final bool? automaticallyImplyLeading;

  const CustomMainAppbar({super.key, required this.title,required this.showLeading, this.automaticallyImplyLeading });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      foregroundColor: Colors.white,
      backgroundColor: Color(0xFFE50F2A),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: showLeading ? 
        IconButton(
          icon: Icon(CupertinoIcons.back, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ) : null,
      automaticallyImplyLeading: automaticallyImplyLeading ?? true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
