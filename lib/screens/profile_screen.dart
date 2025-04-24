import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final ProfilePageNavigation navigation;

  const ProfileScreen({super.key, required this.navigation});

  @override
  State<ProfileScreen> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfileScreen> {
  bool isAvailable = true;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final User? currentUser = auth.currentUser;

      if (currentUser != null) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        if (userProvider.user == null) {
          userProvider.fetchUser(currentUser.uid);
        }
      }
    });
  }

  void showAlert(BuildContext context){
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text('Access Restricted'),
        content: Text('This feature is only accessible for registered users.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: Text('Ok')
          )
        ],
      )
    );
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
        leadingWidth: 40
      ), 
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
              Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  final user = userProvider.user;
                  if (user == null || user.isDonor == false) {
                    return Column(
                      children: [
                        Center(
                          child: Text(user?.email ?? 'No email available.',style: TextStyle(fontSize: 16)),
                        ),
                        SizedBox(height: 30),
                      ],
                    );
                  } else if (user.isDonor == true) {
                    return Column(
                      children: [
                        Text(
                          user.fullName!,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                        ),
                        SizedBox(height: 8),
                        Text(
                          user.contactNumber!,
                          style: TextStyle(fontSize: 16)
                        ),
                        SizedBox(height: 30),
                      ],
                    );
                  }
                  return SizedBox.shrink();
                },
              ),

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
                      child: Consumer<UserProvider>(
                        builder: (context, userProvider, child) {
                          final user = userProvider.user;
                          if (user!.isDonor == true) {
                            return Text(
                              "Donation Count\n${user.donationCount.toString()}",
                              style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            );
                          }
                          return Text(
                            "No Donations",
                            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          );
                        }
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
                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
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
                      style:TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Consumer<UserProvider>(
                    builder: (context, userProvider, child) {
                      final user = userProvider.user;

                      return Switch(
                        padding: EdgeInsets.only(right: 20),
                        value: isAvailable,
                        onChanged: (user != null && user.isDonor == true)
                          ? (value) async {
                              setState(() {
                                isAvailable = value;
                              });

                              final currentUser = auth.currentUser;
                              if (currentUser != null) {
                                final userProvider =
                                    Provider.of<UserProvider>(context,
                                        listen: false);
                                await userProvider.fetchUserAvailability(
                                    currentUser.uid, value);
                              }
                            }
                          : null,
                        activeColor: Color(0xFFE50F2A),
                      );
                    },
                  ),
                ],
              ),

              Divider(thickness: 1.2, color: Colors.grey),

              SizedBox(height: 10),

              // Profile Options
              Consumer<UserProvider>(builder: (context, userProvider, child) {
                final isDonor = userProvider.user?.isDonor ?? true;

                return Column(
                  children: [
                    _buildProfileOption(
                      Icons.edit,
                      'Edit Information',
                      () {
                        if(isDonor){
                          Navigator.popAndPushNamed(context, "/",arguments: {'screenTitle': 'profilePage'});
                        } else {
                          showAlert(context);
                        }
                      } ,
                      enable: isDonor
                    ),
                    _buildProfileOption(
                      Icons.vpn_key,
                      'Change Password',
                      () {
                        if(isDonor){
                          Navigator.popAndPushNamed(context, '/update-password');
                        } else {
                          showAlert(context);
                        }
                      },
                      enable: true
                    ),
                    _buildProfileOption(
                      Icons.access_time,
                      'Donation History',
                      () {
                        if(isDonor){
                          Navigator.popAndPushNamed(context, "/donation-history");
                        } else {
                          showAlert(context);
                        }
                      },
                      enable: true
                    ),
                    _buildProfileOption(
                      Icons.card_giftcard,
                      'View Rewards',
                      () {
                        if(isDonor){
                          Navigator.popAndPushNamed(context, "/view-rewards");
                        } else {
                          showAlert(context);
                        }
                      },
                      enable: true
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildProfileOption(IconData icon, String text, VoidCallback onTap,{bool enable = true}) {
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
      title: Text(
        text,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)
      ),
      onTap: onTap,
    ),
  );
}

enum ProfilePageNavigation {
  bottomNavigation,
  sideDrawer,
}
