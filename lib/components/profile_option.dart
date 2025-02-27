import 'package:flutter/material.dart';

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const ProfileOption({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: Color(0xFFE50F2A)),
        title: Text(text,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
        onTap: onTap,
      ),
    );
  }
}
