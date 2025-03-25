import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/providers/user_provider.dart';
import 'package:lifeblood_blood_donation_app/routes/app_routes.dart';
import 'package:lifeblood_blood_donation_app/services/auth_gate.dart';
import 'package:provider/provider.dart';

class LifeBlood extends StatelessWidget {
  const LifeBlood({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: "LifeBlood",
        debugShowCheckedModeBanner: false,
        home: AuthGate(),
        // initialRoute: "/intro",
        routes: AppRoutes.routes,
      ),
    );
  }
}