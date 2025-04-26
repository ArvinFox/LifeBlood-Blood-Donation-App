import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/components/carousel_container.dart';
import 'package:lifeblood_blood_donation_app/components/drawer/side_drawer.dart';
import 'package:lifeblood_blood_donation_app/components/small_button.dart';
import 'package:lifeblood_blood_donation_app/components/current_activity_card.dart';
import 'package:lifeblood_blood_donation_app/models/donation_request_model.dart';
import 'package:lifeblood_blood_donation_app/providers/current_activity_provider.dart';
import 'package:lifeblood_blood_donation_app/providers/medical_report_provider.dart';
import 'package:lifeblood_blood_donation_app/providers/user_provider.dart';
import 'package:lifeblood_blood_donation_app/utils/helpers.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  List<BloodRequest> _donationRequests = [];
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_)  async {
      final User? currentUser = auth.currentUser;
      if (currentUser != null) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        
        if (userProvider.user == null) {
          await userProvider.fetchUser(currentUser.uid);
        }

        Provider.of<MedicalReportProvider>(context, listen: false)
          .fetchReport(userProvider.user!.userId!);

        await Future.delayed(Duration(milliseconds: 800));
        final currentRoute = ModalRoute.of(context)!.settings.name!;
        if (currentRoute == '/home') {
          _showDonorPopup();
        }
      }
    });
    _fetchDonationRequests(); // Fetch donation requests when the screen is loaded
  }

  void _showDonorPopup() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;

    if (user != null && !user.isDonorPromptShown) {
      try {
        _showDonorDialog();
        await userProvider.updateStatus(user.userId!, 'isDonorPromptShown', true);
      } catch (e) {
        Helpers.debugPrintWithBorder('Error displaying donor popup: $e');
      }
    }
  }

  void _showDonorDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 255, 238, 238),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text('Complete Your Donor Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite, color: Colors.red, size: 40),
            SizedBox(height: 10),
            Text(
              'Thank you for signing up!\nTo start donating blood and help save lives, please complete your donor profile.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, '/donor-registration');
            },
            child: Text('Complete Now'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Later'),
          ),
        ],
      ),
    );
  }

  // Fetch donation requests from Firestore and order by 'createdAt' field
  Future<void> _fetchDonationRequests() async {
    try {
      QuerySnapshot snapshot = await firestore
          .collection('requests')
          .orderBy('createdAt', descending: true) // Order by latest first
          .limit(3) // Limit to latest 3 requests
          .get();

      List<BloodRequest> donationRequests = [];
      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        donationRequests.add(
          BloodRequest(
            requestId: doc.id,
            patientName: data['patientName'] ?? '',
            requestedBy: data['requestBy'] ?? '',
            requestBloodType: data['requestBloodType'] ?? '',
            requestQuantity: data['requestQuantity'] ?? '',
            urgencyLevel: data['urgencyLevel'] ?? '',
            hospitalName: data['hospitalName'] ?? '',
            city: data['city'] ?? '',
            province: data['province'] ?? '',
            contactNumber: data['contactNumber'] ?? '',
            createdAt: (data['createdAt'] as Timestamp).toDate(),
          )
        );
      }

      setState(() {
        _donationRequests = donationRequests;
      });
    } catch (e) {
      print("Error fetching donation requests: $e");
    }
  }

  // Show confirmation dialog
  void _showRequestConfirmDialog(
      BuildContext context, BloodRequest request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 255, 238, 238),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.bloodtype, color: Colors.redAccent),
            SizedBox(width: 8),
            Text('Confirm Donation', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text('Are you sure you want to donate blood for this request?', style: TextStyle(fontSize: 16)),
        actions: [
          TextButton.icon(
            icon: Icon(Icons.cancel, color: Colors.grey),
            onPressed: () => Navigator.pop(context),
            label: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            icon: Icon(Icons.check, color: Colors.white),
            label: Text('Confirm', style: TextStyle(color: Colors.white)),
            onPressed: () async {
              Navigator.pop(context);
              final provider = Provider.of<CurrentActivitiesProvider>(context, listen: false);
              final isAlreadyAdded = provider.currentActivities
                  .any((r) => r.requestId == request.requestId);

              if (isAlreadyAdded) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'This request is already in to your Current Activities. You can view it there.',
                    ),
                    backgroundColor: Colors.orange[700],
                  ),
                );
              } else {
                await provider.addActivity(request);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Donation confirmed! The request has been added to your Current Activities.'),
                    backgroundColor: Colors.green[600],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  //display alert
  void showAlert(BuildContext context){
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text('Already Submitted Data'),
        content: Text('You are already submitted data. We will notify you after verifying your details.\nThank you for your support!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK')
          )
        ],
      )
    );
  }

  String _getGreetingMessage() {
    final hour = DateTime.now().hour;
    if (hour >= 0 && hour < 12) {
      return "Good Morning!";
    } else if (hour >= 12 && hour < 16) {
      return "Good Afternoon!";
    } else {
      return "Good Evening!";
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
            size: 30,
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xFFE50F2A),
          title: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer<UserProvider>(
                  builder: (context, userProvider, child) {
                    final user = userProvider.user;
                    Widget widget;

                    if (user == null || !user.isDonorVerified!) {
                      widget = SizedBox.shrink();
                    } else {
                      String firstName = user.fullName!.split(' ').first;
                      if (firstName == '') {
                        firstName = user.fullName!;
                      }

                      widget = Text(
                        'Hi $firstName',
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getGreetingMessage(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(height: 2),
                        widget,
                      ],
                    );
                  }
                ),
              ],
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
              SizedBox(height: 8),
              Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  final user = userProvider.user;

                  final isDonorVerified = user?.isDonorVerified ?? false;               
                  final hasCompletedProfile = user?.hasCompletedProfile ?? false;

                  if (userProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return Consumer<MedicalReportProvider>(
                      builder: (context, medicalReportProvider, child) {
                        if (medicalReportProvider.isLoading) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        bool isDonorRejected = false;
                        if (medicalReportProvider.report != null) {
                          isDonorRejected = medicalReportProvider.report!.status == 'Rejected';
                        }

                        if (isDonorVerified) {
                          // If verified
                          return SizedBox.shrink();
                        } else if (isDonorRejected) {
                          // If profile was rejected
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, '/donor-registration');
                              },
                              borderRadius: BorderRadius.circular(15),
                              child: Card(
                                color: Colors.red[100],
                                elevation: 4,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Icon(Icons.error_outline, color: Colors.redAccent, size: 30),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Your donor profile was rejected.",
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(height: 6),
                                            Text(
                                              "Please review and update your details to resubmit.",
                                              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.redAccent),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else if (hasCompletedProfile) {
                          // If completed profile but not yet verified
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, '/donor-registration');
                              },
                              borderRadius: BorderRadius.circular(15),
                              child: Card(
                                color: Colors.blue[50],
                                elevation: 4,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Icon(Icons.info_outline, color: Colors.blueAccent, size: 30),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Your donor profile has been submitted and is awaiting verification.",
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                            ),
                                            SizedBox(height: 6),
                                            Text(
                                              "Tap here if you'd like to review or update your details.",
                                              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.blueAccent),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          // Show link to complete profile
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, '/donor-registration');
                              },
                              borderRadius: BorderRadius.circular(15),
                              child: Card(
                                color: Colors.yellow[100],
                                elevation: 4,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.volunteer_activism, color: Colors.redAccent, size: 30),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          'Complete your donor profile to start saving lives. Tap here to get started!',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Icon(Icons.arrow_forward_ios, size: 16, color: Colors.redAccent),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    );
                  }
                },
              ),
              

              // Display Current Activities
              Consumer<CurrentActivitiesProvider>(
                builder: (context, provider, child) {
                  final currentActivities = provider.currentActivities;

                  if (currentActivities.isEmpty) {
                    return SizedBox.shrink(); // Hide the section if empty
                  }

                  return Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Current Activities",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: currentActivities.length,
                        itemBuilder: (context, index) {
                          return CurrentActivityCard(
                            donationRequest: currentActivities[index],
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 20),

              // Lifesaving Alerts Section
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

              // Donation Requests
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _donationRequests.length,
                itemBuilder: (context, index) {
                  final request = _donationRequests[index];
                  return GestureDetector(
                    onTap: () {
                      if (userProvider.user!.isDonorVerified!) {
                        _showRequestConfirmDialog(context, request); // <-- fixed by passing context
                      } else {
                        if (userProvider.user!.hasCompletedProfile!) {
                          _showDonorNotVerifiedPopup(
                            context,
                            title: "Verification Pending",
                            message: "Your donor profile is under review. You can accept requests once you are verified."
                          );
                        } else {
                          _showDonorNotVerifiedPopup(
                            context,
                            title: "Complete Your Profile",
                            message: "Please complete your donor profile to start accepting blood donation requests."
                          );
                        }
                      }
                    },
                    child: _donationRequestCard(donationRequest: request),
                  );
                },
              ),
              SizedBox(height: 20),

              // "See More" button for donation requests
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

  void _showDonorNotVerifiedPopup(BuildContext context, {required String title, required String message}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Widget _donationRequestCard({required BloodRequest donationRequest}){
    return Card(
      child: Container(
        width: double.infinity,
        height: 120,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(0xFFCACACA).withOpacity(0.20),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: Color(0xFFE50F2A),
              radius: 30,
              child: Text(
                donationRequest.requestBloodType,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      'Urgency Level: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      donationRequest.urgencyLevel,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Location: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      donationRequest.hospitalName,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                Text(
                  donationRequest.city,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
