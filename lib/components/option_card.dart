import 'package:flutter/material.dart';

class OptionCard extends StatelessWidget {
  final String option;
  final String imgUrl;

  const OptionCard({
    super.key,
    required this.option,
    required this.imgUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Image.asset(
            imgUrl.toString(),
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: Text(
            option,
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
