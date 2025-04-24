import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/components/carousel_container.dart';
import 'package:lifeblood_blood_donation_app/components/drawer/side_drawer.dart';
import 'package:lifeblood_blood_donation_app/components/small_button.dart';
import 'package:lifeblood_blood_donation_app/components/current_activity_card.dart';
import 'package:lifeblood_blood_donation_app/models/donation_request_model.dart';
import 'package:lifeblood_blood_donation_app/providers/current_activity_provider.dart';
import 'package:lifeblood_blood_donation_app/providers/donor_status_provider.dart';
import 'package:lifeblood_blood_donation_app/providers/user_provider.dart';
import 'package:lifeblood_blood_donation_app/services/user_service.dart';
import 'package:lifeblood_blood_donation_app/utils/helpers.dart';
import 'package:provider/provider.dart';

bool _donorPopupShown = false;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  List<DonationRequestDetails> _donationRequests = [];
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_)  async {
      if (_donorPopupShown) return;
      _donorPopupShown = true;

      final User? currentUser = auth.currentUser;
      if (currentUser != null) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        if(userProvider.user == null){
          await userProvider.fetchUser(currentUser.uid);
        }
        _donorStatus(currentUser.uid);
        _showDonorPopup();
        print('--------------Donor popup triggered----------------------');
      }
    });
    _fetchDonationRequests(); // Fetch donation requests when the screen is loaded
  }

  Future<void> _showDonorPopup() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final donorProvider = Provider.of<DonorStatusProvider>(context, listen: false);
    final user = userProvider.user;
    if (user == null || donorProvider.donorDialogShown) return;

    if (user.isDonorPromptShown == null || user.isDonorPromptShown == false) {
      try {
        await FirebaseFirestore.instance.collection('user').doc(user.userId).update({
          'isDonorPromptShown': true,
        });

        donorProvider.markDialogShown();
        _showDonorDialog();
      } catch (e) {
        Helpers.debugPrintWithBorder('Error updating user.');
      }
    }
  }

  void _donorStatus(String userId) {
    _userService.getDonorStatus(userId).listen((isDonor) {
      final provider = Provider.of<DonorStatusProvider>(context, listen: false);
      provider.setShowDonorPoster(!isDonor);
    });
  }

  // Fetch donation requests from Firestore and order by 'createdAt' field
  Future<void> _fetchDonationRequests() async {
    try {
      QuerySnapshot snapshot = await firestore
          .collection('requests')
          .orderBy('createdAt', descending: true) // Order by latest first
          .limit(3) // Limit to latest 3 requests
          .get();

      List<DonationRequestDetails> donationRequests = [];
      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        donationRequests.add(DonationRequestDetails(
          requestId: doc.id,
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
        _donationRequests = donationRequests;
      });
    } catch (e) {
      print("Error fetching donation requests: $e");
    }
  }

  void _showDonorDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Become a Donor'),
        content: Text('Do you want to become a blood donor and help save lives?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, '/donor-registration');
            },
            child: Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('No'),
          ),
        ],
      ),
    );
  }

  // Show confirmation dialog
  void _showConfirmDialog(
      BuildContext context, DonationRequestDetails request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Blood Donation'),
        content:
            Text('Are you sure you want to donate blood for this request?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final provider = Provider.of<CurrentActivitiesProvider>(context,
                  listen: false);
              final isAlreadyAdded = provider.currentActivities
                  .any((r) => r.requestId == request.requestId);

              if (isAlreadyAdded) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'This Request is already Added to your Current Activities. Check it out under Current Activities Section.',
                    ),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              } else {
                await provider.addActivity(request);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Blood Donation Confirmed and Added to Current Activities!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: Text('Confirm'),
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

  // Add selected request to Current Activities
  void _addToCurrentActivities(DonationRequestDetails request) {
    Provider.of<CurrentActivitiesProvider>(context, listen: false)
        .addActivity(request);
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
                Text(
                  _getGreetingMessage(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Consumer<UserProvider>(
                  builder: (context, userProvider,_){
                    final user = userProvider.user;
                    if(user == null || user.isDonor == false){
                      return SizedBox.shrink();
                    }

                    final firstName = user.fullName!.split(' ').first;
                    return Text(
                      'Hi $firstName',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
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
              Consumer<DonorStatusProvider>(
                builder: (context, donorProvider, _){
                  final user = Provider.of<UserProvider>(context, listen: false).user;
                  final hasFullName = user?.fullName != null && user!.fullName!.trim().isNotEmpty;

                  return donorProvider.showDonorPoster
                    ? 
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: InkWell(
                          onTap: (){
                            if(hasFullName){
                              showAlert(context);
                            } else {
                              Navigator.pushNamed(context, '/donor-registration');
                            }
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
                                      'Want to become a donor later? Click here to register and save lives anytime!',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ) 
                    : SizedBox.shrink();
                },
              ),
              

              // Display Current Activities
              Consumer<CurrentActivitiesProvider>(
                builder: (context, provider, _) {
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
                      _showConfirmDialog(context, request); // <-- fixed by passing context
                    },
                    child: _dobationRequestCard(donationRequest: request),
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

  Widget _dobationRequestCard({required DonationRequestDetails donationRequest}){
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
