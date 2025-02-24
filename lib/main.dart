import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/app.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LifeBlood();
  }
}
