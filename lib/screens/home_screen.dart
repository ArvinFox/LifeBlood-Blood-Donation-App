import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/components/blood_request_card.dart';
import 'package:lifeblood_blood_donation_app/components/carousel_container.dart';
import 'package:lifeblood_blood_donation_app/components/drawer/side_drawer.dart';
import 'package:lifeblood_blood_donation_app/components/small_button.dart';
import 'package:lifeblood_blood_donation_app/components/current_activity_card.dart';
import 'package:lifeblood_blood_donation_app/models/donation_request_model.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final User? currentUser = auth.currentUser;
      if (currentUser != null) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);

        if (userProvider.user == null) {
          await userProvider.fetchUser(currentUser.uid);
        }

        Provider.of<MedicalReportProvider>(context, listen: false)
            .fetchReport(userProvider.user!.userId!);
        
        await userProvider.loadCurrentActivity();

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
        await userProvider.updateStatus(
            user.userId!, 'isDonorPromptShown', true);
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
        title: Text('Complete Your Donor Profile',
            style: TextStyle(fontWeight: FontWeight.bold)),
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
    // TODO: get pending requests
    try {
      QuerySnapshot snapshot = await firestore
          .collection('requests')
          .orderBy('createdAt', descending: true) // Order by latest first
          .limit(3) // Limit to latest 3 requests
          .get();

      List<BloodRequest> donationRequests = [];
      for (var doc in snapshot.docs) {
        donationRequests.add(BloodRequest.fromFirestore(doc));
      }

      setState(() {
        _donationRequests = donationRequests;
      });
    } catch (e) {
      print("Error fetching donation requests: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
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
                Consumer<UserProvider>(builder: (context, userProvider, child) {
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
                          fontWeight: FontWeight.bold),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Helpers.getGreetingMessage(),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 2),
                      widget,
                    ],
                  );
                }),
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
              _buildDonorVerificationSection(),
              _buildCurrentActivitySection(),
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
              SizedBox(height: 5),
              Align(
                alignment: Alignment.centerRight,
                child: SmallButton(
                  buttonLabel: "See More Donation Requests",
                  buttonHeight: 40,
                  buttonWidth: 240,
                  buttonColor: Colors.white,
                  borderColor: Colors.black,
                  labelColor: Colors.black,
                  onTap: () => Navigator.pushNamed(context, '/donation-request'),
                ),
              ),
              SizedBox(height: 5),
              // Donation Requests
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _donationRequests.length,
                itemBuilder: (context, index) {
                  final request = _donationRequests[index];
                  return BloodRequestCard(request: request);
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Consumer<UserProvider> _buildCurrentActivitySection() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        if (userProvider.isLoading) {
          return const SizedBox.shrink();
        }

        final currentActivityId = userProvider.currentActivityId;
        final currentActivity = userProvider.currentActivity;

        if (currentActivityId == null || currentActivity == null) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            const SizedBox(height: 10),
            CurrentActivityCard(request: currentActivity),
            const SizedBox(height: 4),
          ],
        );
      },
    );
  }

  Consumer<UserProvider> _buildDonorVerificationSection() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        if (userProvider.isLoading) {
          return const Center(child: CircularProgressIndicator(color: Colors.red));
        }

        final user = userProvider.user;
        final isDonorVerified = user?.isDonorVerified ?? false;
        final hasCompletedProfile = user?.hasCompletedProfile ?? false;

        return Consumer<MedicalReportProvider>(
          builder: (context, medicalReportProvider, child) {
            if (medicalReportProvider.isLoading) {
              return const Center(child: CircularProgressIndicator(color: Colors.red));
            }

            bool isDonorRejected = false;
            if (medicalReportProvider.report != null) {
              isDonorRejected = medicalReportProvider.report!.status == 'Rejected';
            }

            if (isDonorVerified) {
              return SizedBox.shrink();
            } else if (isDonorRejected) {
              return _buildDonorVerificationInfoCard(
                Colors.red[100]!, 
                Icons.error_outline, 
                Colors.redAccent, 
                "Your donor profile was rejected.",
                action: "Please review and update your details to resubmit.",
              );
            } else if (hasCompletedProfile) {
              return _buildDonorVerificationInfoCard(
                Colors.blue[50]!, 
                Icons.info_outline, 
                Colors.blueAccent, 
                "Your donor profile has been submitted and is awaiting verification.",
                action: "Tap here if you'd like to review or update your details.",
              );
            } else {
              return _buildDonorVerificationInfoCard(
                Colors.yellow[100]!, 
                Icons.volunteer_activism, 
                Colors.redAccent, 
                "Complete your donor profile to start saving lives. Tap here to get started!",
                actionIcon: Icons.arrow_forward_ios,
              );
            }
          },
        );
      }
    );
  }

  Widget _buildDonorVerificationInfoCard(Color backgroundColor, IconData icon, Color color, String message, {String? action, IconData? actionIcon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, '/donor-registration'),
        borderRadius: BorderRadius.circular(15),
        child: Card(
          color: backgroundColor,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: color, size: 30),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      if (action != null) ...[
                        SizedBox(height: 6),
                        Text(
                          action,
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: color,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                if (actionIcon != null)
                  Icon(actionIcon, color: color, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
