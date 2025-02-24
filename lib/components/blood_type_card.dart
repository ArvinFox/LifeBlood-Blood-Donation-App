import 'package:flutter/material.dart';

class BloodTypeCard extends StatelessWidget {
  final String bloodType;
  final bool isSelected;
  final VoidCallback onSelect;

  const BloodTypeCard({
    super.key,
    required this.bloodType,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.red : Colors.white,
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            bloodType,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
