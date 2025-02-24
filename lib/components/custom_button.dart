import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String btnLabel;
  final double cornerRadius;
  final Color btnColor;
  final Color btnBorderColor;
  final Color labelColor;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.btnLabel,
    required this.cornerRadius,
    required this.btnColor,
    required this.btnBorderColor,
    required this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(350, 50),
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
          fontSize: 24,
        ),
      ),
    );
  }
}
