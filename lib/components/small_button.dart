import 'package:flutter/material.dart';

class SmallButton extends StatelessWidget {
  final String buttonLabel;
  final double buttonWidth;
  final double buttonHeight;
  final Color buttonColor;
  final Color borderColor;
  final Color labelColor;
  final VoidCallback onTap;

  const SmallButton({
    super.key,
    required this.buttonLabel,
    required this.buttonWidth,
    required this.buttonHeight,
    required this.buttonColor,
    required this.borderColor,
    required this.labelColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          height: buttonHeight,
          width: buttonWidth,
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: borderColor,
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              buttonLabel,
              style: TextStyle(
                color: labelColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
