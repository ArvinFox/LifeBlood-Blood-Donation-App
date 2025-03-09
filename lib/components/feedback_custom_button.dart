import 'package:flutter/material.dart';

class FeedbackCustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String btnLabel;
  final double cornerRadius;
  final Color btnColor;
  final Color btnBorderColor;
  final Color labelColor;
  final double width;
  final double fontSize;

  const FeedbackCustomButton({
    super.key,
    required this.onPressed,
    required this.btnLabel,
    this.cornerRadius = 10,
    this.btnColor = const Color(0xFFE50F2A),
    this.btnBorderColor = Colors.transparent,
    this.labelColor = Colors.white,
    this.width = 140, // Optimized width for feedback section
    this.fontSize = 16, // Optimized font size for feedback section
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width, 45), // Controlled width & height
        backgroundColor: btnColor,
        side: BorderSide(color: btnBorderColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cornerRadius),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        btnLabel,
        style: TextStyle(
          color: labelColor,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
