import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lifeblood_blood_donation_app/constants/app_credentials.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Supabase.initialize(
    url: AppCredentials.supabaseUrl,
    anonKey: AppCredentials.supabaseAnonKey,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const LifeBlood(); // Running the app after setup
  }
}
