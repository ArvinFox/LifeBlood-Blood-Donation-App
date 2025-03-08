import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/routes/app_routes.dart';
import 'package:lifeblood_blood_donation_app/screens/static/get_started_page.dart';

class LifeBlood extends StatelessWidget {
  const LifeBlood({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "LifeBlood",
      debugShowCheckedModeBanner: false,
      home: GetStartedPage(), 
      routes: AppRoutes.routes,
    );
  }
}
