import 'package:flutter/material.dart';
import 'package:project_1/widgets/bottom_navigation.dart';
import 'package:project_1/widgets/carousel_container.dart';
import 'package:project_1/widgets/donation_request_card.dart';
import 'package:project_1/widgets/drawer/side_drawer.dart';
import 'package:project_1/widgets/small_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      //AppBar
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
          size: 30,
        ),
        backgroundColor: Color(0xFFE50F2A),
        title: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            "Hi @Username",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
      ),
      endDrawer: NavDrawer(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              CarouselContainer(),
              SizedBox(
                height: 20,
              ),
              Text(
                "Lifesaving Alerts: Donate Blood Now!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Urgent help needed! Browse the list of blood donation requests and be a hero. Your donation can save lives and bring hope. Every drop counts!",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              //donation request cards
              DonationRequestCard(
                bloodType: "A+",
                urgencyLevel: "High",
                hospitalLocation: "Base Hospital ",
                city: "Homagama",
              ),
              SizedBox(
                height: 20,
              ),
              DonationRequestCard(
                bloodType: "O+",
                urgencyLevel: "High",
                hospitalLocation: "Base Hospital ",
                city: "Homagama",
              ),
              SizedBox(
                height: 20,
              ),
              DonationRequestCard(
                bloodType: "O+",
                urgencyLevel: "High",
                hospitalLocation: "Base Hospital ",
                city: "Homagama",
              ),
              SizedBox(
                height: 20,
              ),
              //see more donation requests button
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SmallButton(
                    buttonTitle: "See More",
                    buttonHeight: 40,
                    buttonWidth: 120,
                  ),
                ],
              ),
              SizedBox(
                height: 90,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CurveNavBar(),
    );
  }
}
