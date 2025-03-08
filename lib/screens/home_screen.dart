import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/components/carousel_container.dart';
import 'package:lifeblood_blood_donation_app/components/donation_request_card.dart';
import 'package:lifeblood_blood_donation_app/components/drawer/side_drawer.dart';
import 'package:lifeblood_blood_donation_app/components/small_button.dart';
import 'package:lifeblood_blood_donation_app/models/donation_request_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  final List<DonationRequestDetails> _donationRequests = [
    DonationRequestDetails(
      requestId: 1,
      requestBloodType: 'A+',
      urgencyLevel: "High",
      location: "Base Hospital ",
      city: "Homagama", 
      name: 'ABC', 
      contactNumber: '0771234567', 
    ),
    DonationRequestDetails(
      requestId: 1,
      requestBloodType: 'O+',
      urgencyLevel: "High",
      location: "Base Hospital ",
      city: "Homagama", 
      name: 'ABC', 
      contactNumber: '0771234567', 
    ),
    DonationRequestDetails(
      requestId: 1,
      requestBloodType: 'AB+',
      urgencyLevel: "High",
      location: "Base Hospital ",
      city: "Homagama", 
      name: 'ABC', 
      contactNumber: '0771234567', 
    ),
    DonationRequestDetails(
      requestId: 1,
      requestBloodType: 'B+',
      urgencyLevel: "High",
      location: "Base Hospital ",
      city: "Homagama", 
      name: 'ABC', 
      contactNumber: '0771234567', 
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
          size: 30,
        ),
        automaticallyImplyLeading: false,
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
              //donation request cards (take only 3 cards from the list)
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return DonationRequestCard(
                    donationRequest: _donationRequests[index],
                  );
                },
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
                    buttonLabel: "See More",
                    buttonHeight: 40,
                    buttonWidth: 120,
                    buttonColor: Colors.white,
                    borderColor: Colors.black,
                    labelColor: Colors.black,
                    onTap: () {
                      Navigator.pushNamed(context, '/donation-request');
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
