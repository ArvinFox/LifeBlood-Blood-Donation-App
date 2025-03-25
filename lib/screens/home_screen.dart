import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/components/carousel_container.dart';
import 'package:lifeblood_blood_donation_app/components/donation_request_card.dart';
import 'package:lifeblood_blood_donation_app/components/drawer/side_drawer.dart';
import 'package:lifeblood_blood_donation_app/components/small_button.dart';
import 'package:lifeblood_blood_donation_app/models/donation_request_model.dart';
import 'package:lifeblood_blood_donation_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  List<DonationRequestDetails> _donationRequests = [];
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final User? currentUser = auth.currentUser;
      if (currentUser != null) {
        Provider.of<UserProvider>(context, listen: false).fetchUser(currentUser.uid);
      }
    });

    _fetchDonationRequests(); // Fetch donation requests when the screen is loaded
  }

  // Fetch donation requests from Firestore and order by 'createdAt' field
  Future<void> _fetchDonationRequests() async {
    try {
      QuerySnapshot snapshot = await firestore
          .collection('requests')
          .orderBy('createdAt',
              descending: true) // Order by 'createdAt' (latest first)
          .limit(3) // Limit to the latest 3 requests
          .get();

      List<DonationRequestDetails> donationRequests = [];
      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        // Only extract the required fields
        donationRequests.add(DonationRequestDetails(
          requestId: doc.id, // Use Firestore document ID as requestId
          patientName: data['patientName'] ?? '',
          requestBloodType: data['requestBloodType'] ?? '',
          urgencyLevel: data['urgencyLevel'] ?? '',
          hospitalName: data['hospitalName'] ?? '',
          city: data['city'] ?? '',
          province: data['province'] ?? '',
          contactNumber: data['contactNumber'] ?? '',
          createdAt: (data['createdAt'] as Timestamp).toDate(),
        ));
      }

      setState(() {
        _donationRequests = donationRequests; // Update state with fetched data
      });
    } catch (e) {
      print("Error fetching donation requests: $e");
    }
  }

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
          child: Consumer<UserProvider>(
            builder: (context, userProvider, child){
              if (userProvider.isLoading) {
                return Center(child: CircularProgressIndicator());
              }
              final user = userProvider.user;

              return Text(
                'Hi ${user?.personalInfo.firstName}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              );
            },
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
              SizedBox(height: 20),
              Text(
                "Lifesaving Alerts: Donate Blood Now!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Urgent help needed! Browse the list of blood donation requests and be a hero. Your donation can save lives and bring hope. Every drop counts!",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              // Donation request cards (display fetched requests)
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _donationRequests.length,
                itemBuilder: (context, index) {
                  return DonationRequestCard(
                    donationRequest:
                        _donationRequests[index], // Pass the fetched data
                  );
                },
              ),
              SizedBox(height: 20),
              // See more donation requests button
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
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
