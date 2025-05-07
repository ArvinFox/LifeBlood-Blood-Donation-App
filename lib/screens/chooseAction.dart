import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/components/custom_main_app_bar.dart';
import 'package:lifeblood_blood_donation_app/components/drawer/side_drawer.dart';
import 'package:lifeblood_blood_donation_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ChooseActionPage extends StatefulWidget {
  final ChooseActionPageNavigation navigation;

  const ChooseActionPage({
    super.key,
    required this.navigation,
  });

  @override
  State<ChooseActionPage> createState() => _ChooseActionPageState();
}

class _ChooseActionPageState extends State<ChooseActionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomMainAppbar(
        title: 'Choose Your Preference',
        showLeading:
            widget.navigation != ChooseActionPageNavigation.bottomNavigation,
        automaticallyImplyLeading:
            widget.navigation == ChooseActionPageNavigation.sideDrawer,
      ),
      endDrawer: NavDrawer(),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Color.fromARGB(255, 247, 167, 178),
              Colors.white
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Consumer<UserProvider>(
                          builder: (context, userProvider, child) {
                            return _actionButton(
                              context: context,
                              title: "Donate Blood",
                              icon: Icons.volunteer_activism,
                              onTap: () {
                                Navigator.pushNamed(context, '/donation-request');
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 40),
                        _actionButton(
                          context: context,
                          title: "Request Blood",
                          icon: Icons.bloodtype,
                          onTap: () {
                            Navigator.pushNamed(context, '/find-donor');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _actionButton({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.width * 0.5,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(99, 0, 0, 0),
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 60, color: Colors.red),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum ChooseActionPageNavigation {
  bottomNavigation,
  sideDrawer,
}
