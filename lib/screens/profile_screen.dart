import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final ProfilePageNavigation navigation;

  const ProfileScreen({super.key, required this.navigation});

  @override
  State<ProfileScreen> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfileScreen> {
  bool isAvailable = true;
  String? firstName;
  String? lastName;
  String? contactNumber;
  bool isUserDataFetched = false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('user');

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    if(isUserDataFetched) return ;

    try {
      User? currentUser = auth.currentUser;

      if (currentUser != null) {
        String uid = currentUser.uid;
        DocumentSnapshot userDoc =
            await userCollection.doc(uid).get();

        if (userDoc.exists) {
          setState(() {
            firstName = userDoc['personalInfo']['firstName'];
            lastName = userDoc['personalInfo']['lastName'];
            contactNumber = userDoc['personalInfo']['contactNumber'];
            isAvailable = userDoc['isActive'] ;
          });
        }
      }
    } catch (e) {
      print("Error fetching user details.: $e");
    }
  }

  Future<void> _setAvailabilityStatus(bool value) async {
    try {
      User? currentUser = auth.currentUser;

      if (currentUser != null) {
        String userId = currentUser.uid;
        await userCollection
            .doc(userId)
            .update({'isActive': value});
      }
    } catch (e) {
      print("Error updating availability status: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Color(0xFFE50F2A),
          title: Text(
            "Profile",
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
          automaticallyImplyLeading:
              widget.navigation == ProfilePageNavigation.sideDrawer
                  ? true
                  : false,
          leading: widget.navigation == ProfilePageNavigation.sideDrawer
              ? CupertinoNavigationBarBackButton(
                  color: Colors.white,
                  onPressed: () {
                    Navigator.popAndPushNamed(context, "/home");
                  },
                )
              : null,
          leadingWidth: 40), // Reduce space in between leading and text
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 16),

              // Profile Image
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: AssetImage("assets/images/profile.jpg"),
              ),

              SizedBox(height: 16),
              Text(
                  firstName != null && lastName != null
                      ? '$firstName $lastName'
                      : '@Username',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(contactNumber != null ? "$contactNumber" : 'Contact Number',
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 30),

              // Donation Info Row
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: Color(0xFFE50F2A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Donation Count\n02",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                        color: Color(0xFFE50F2A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Next Donation Date\nAfter 3 months",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 40),

              // Availability Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      "Availability Status",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Switch(
                    padding: EdgeInsets.only(right: 20),
                    value: isAvailable,
                    onChanged: (value) {
                      setState(() {
                        isAvailable = value;
                      });
                      _setAvailabilityStatus(value);
                    },
                    activeColor: Color(0xFFE50F2A),
                  ),
                ],
              ),

              Divider(thickness: 1.2, color: Colors.grey),

              SizedBox(height: 10),

              // Profile Options
              _buildProfileOption(Icons.edit, 'Edit Information', () {
                Navigator.popAndPushNamed(
                  context,
                  "/signup-personal-info",
                  arguments: {'screenTitle': 'profilePage'},
                );
              }),
              _buildProfileOption(Icons.vpn_key, 'Change Password', () {
                Navigator.popAndPushNamed(context, '/update-password');
              }),
              _buildProfileOption(Icons.access_time, 'Donation History', () {
                Navigator.popAndPushNamed(context, "/donation-history");
              }),
              _buildProfileOption(Icons.card_giftcard, 'View Rewards', () {
                Navigator.popAndPushNamed(context, "/view-rewards");
              }),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildProfileOption(IconData icon, String text, VoidCallback onTap) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
    padding: EdgeInsets.all(6),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 6,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: ListTile(
      leading: Icon(icon, color: Color(0xFFE50F2A)),
      title: Text(text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
      onTap: onTap,
    ),
  );
}

enum ProfilePageNavigation {
  bottomNavigation,
  sideDrawer,
}
