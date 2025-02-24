import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/components/profile_option.dart';
import 'package:lifeblood_blood_donation_app/screens/donation_history_screen.dart';
import 'package:lifeblood_blood_donation_app/screens/rewards_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfileScreen> {
  bool isAvailable = true; // Availability toggle status

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFFE50F2A),
          title: Text(
            "Profile",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          leading: CupertinoNavigationBarBackButton(
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
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
                // backgroundImage: AssetImage(assetName),
              ),

              SizedBox(height: 16),
              Text("@Username",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text("07XXXXXXXX", style: TextStyle(fontSize: 16)),
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
                    },
                    activeColor: Color(0xFFE50F2A),
                  ),
                ],
              ),

              Divider(thickness: 1.2, color: Colors.grey),

              SizedBox(height: 10),

              // Profile Options
              ProfileOption(
                icon: Icons.edit,
                text: "Edit Information",
                onTap: () {},
              ),
              ProfileOption(
                icon: Icons.vpn_key,
                text: "Change Password",
                onTap: () {},
              ),
              ProfileOption(
                icon: Icons.access_time,
                text: "Donation History",
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DonationHistoryScreen()));
                },
              ),
              ProfileOption(
                icon: Icons.card_giftcard,
                text: " View Rewards",
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RewardsScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
