import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String btnLabel;
  final Widget? buttonChild;
  final double cornerRadius;
  final Color btnColor;
  final Color btnBorderColor;
  final Color labelColor;
  final bool isLoading;

  const CustomButton({
    super.key,
    this.onPressed,
    required this.btnLabel,
    this.buttonChild,
    required this.cornerRadius,
    required this.btnColor,
    required this.btnBorderColor,
    required this.labelColor,
    this.isLoading = false,
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
      child: buttonChild ?? Text(
        btnLabel.toString(),
        style: TextStyle(
          color: labelColor,
          fontSize: 24,
        ),
      ),
    );
  }
}
