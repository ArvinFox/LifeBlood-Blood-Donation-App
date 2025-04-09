import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/models/donation_request_model.dart';

class NotificationScreen extends StatefulWidget {
  final NotificationPageNavigation navigation;

  const NotificationScreen({
    super.key,
    required this.navigation,
  });

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _isBorderVisible = true;
  DonationRequestDetails? latestRequest;

  @override
  void initState() {
    super.initState();
    _fetchLatestDonationRequest();
  }

  void _fetchLatestDonationRequest() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('requests')
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          latestRequest =
              DonationRequestDetails.fromFirestore(snapshot.docs.first.data());
        });
      }
    } catch (e) {
      print("Error fetching donation request: $e");
    }
  }

  void _borderVisible() {
    setState(() {
      _isBorderVisible = false;
    });
  }

  void showJoinDialog(BuildContext context,VoidCallback borderVisible) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Let's Donate Blood & Save Lives",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                "assets/images/events_banner2.png",
              ),
            ),
          ],
        ),
        content: Text(
          "You are all invited to participate in blood donation events. Join us and help save lives!",
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  //SocialSharingPlus.shareToSocialMedia(SocialPlatform.whatsapp, contentToShare);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text("Share", style: TextStyle(color: Colors.white)),
              ),
              OutlinedButton(
                onPressed: () {
                  borderVisible();
                  Navigator.pop(context);
                },
                style:
                    OutlinedButton.styleFrom(side: BorderSide(color: Colors.red)),
                child: Text("Cancel", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showConfirmationPopup(BuildContext context, String bloodType,String urgencyLevel, String hospital, String city) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Column(
          children: [
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Lifesaving Alert: Donate Blood Now!",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  "assets/images/emergency.jpg",
                  width: 120,
                  height: 140,
                ),
                SizedBox(width: 5),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Blood Type : $bloodType",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Urgency Level : $urgencyLevel",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Location : $hospital  \n$city",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        content: Text(
          "Your timely blood donation can save lives and bring hope to those in critical need. Act now to be a hero!",
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text("Confirm", style: TextStyle(color: Colors.white)),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style:
                    OutlinedButton.styleFrom(side: BorderSide(color: Colors.red)),
                child: Text("Cancel", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFE50F2A),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          " Notifications",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        automaticallyImplyLeading:
            widget.navigation == NotificationPageNavigation.sideDrawer
                ? true
                : false,
        leading: widget.navigation == NotificationPageNavigation.sideDrawer
            ? CupertinoNavigationBarBackButton(
                color: Colors.white,
                onPressed: () {
                  Navigator.popAndPushNamed(context, "/home");
                },
              )
            : null,
        leadingWidth: 40,
        actions: [
          IconButton(
            icon: Icon(
              Icons.mark_email_read_outlined,
              size: 30,
            ),
            onPressed: () {
              _borderVisible();
            },
          ),
          SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildNotificationCard(),
            latestRequest != null
                ? _buildLifeSavingAlertCard(
                    latestRequest!.requestBloodType,
                    latestRequest!.urgencyLevel,
                    latestRequest!.hospitalName,
                    latestRequest!.city,
                    latestRequest!.createdAt,
                  )
                : Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Card(
        child: Container(
          width: double.infinity,
          height: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: _isBorderVisible
                ? Border.all(
                    color: Colors.grey,
                    width: 2,
                  )
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Let's Donate Blood & Save Lives",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.alarm,
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "12:00 AM",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Image.asset("assets/images/events_banner2.png"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showJoinDialog(context, _borderVisible);
                      },
                      child: Text(
                        "Read More.....",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLifeSavingAlertCard(String bloodType, String urgencyLevel,
      String hospital, String city, DateTime createdAt) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Card(
        child: Container(
          width: double.infinity,
          height: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Lifesaving Alert: Donate Blood Now!",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.alarm,
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')} ${createdAt.hour < 12 ? 'AM' : 'PM'}",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      "assets/images/emergency.jpg",
                      width: 150,
                      height: 140,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Blood Type : $bloodType",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Urgency Level : $urgencyLevel",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Location : $hospital - \n$city",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showConfirmationPopup(context, bloodType, urgencyLevel, hospital, city);
                      },
                      child: Text(
                        "Read More.....",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum NotificationPageNavigation {
  bottomNavigation,
  sideDrawer,
}
