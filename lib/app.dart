import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/providers/event_provider.dart';
import 'package:lifeblood_blood_donation_app/providers/medical_report_provider.dart';
import 'package:lifeblood_blood_donation_app/providers/notification_provider.dart';
import 'package:lifeblood_blood_donation_app/providers/user_provider.dart';
import 'package:lifeblood_blood_donation_app/routes/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:lifeblood_blood_donation_app/providers/current_activity_provider.dart';

class LifeBlood extends StatelessWidget {
  const LifeBlood({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CurrentActivitiesProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => MedicalReportProvider()),
      ],
      child: MaterialApp(
        title: "LifeBlood",
        debugShowCheckedModeBanner: false,
        // home: AuthGate(),
        initialRoute: "/intro",
        routes: AppRoutes.routes,
      ),
    );
  }
}
