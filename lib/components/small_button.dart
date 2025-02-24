import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/screens/events_screen.dart';

class SmallButton extends StatelessWidget {
  final String buttonTitle;
  final double buttonWidth;
  final double buttonHeight;

  const SmallButton({
    super.key,
    required this.buttonTitle,
    required this.buttonWidth,
    required this.buttonHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => EventsScreen()));
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          height: buttonHeight,
          width: buttonWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              buttonTitle,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
