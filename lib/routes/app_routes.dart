import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/routes/auth_routes.dart';
import 'package:lifeblood_blood_donation_app/routes/user_routes.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    ...AuthRoutes.routes,
    ...UserRoutes.routes,
  };
}