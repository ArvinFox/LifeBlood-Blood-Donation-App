import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/components/confirmation_popup.dart';
import 'package:lifeblood_blood_donation_app/components/event_popup.dart';

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

  void _borderVisible() {
    setState(() {
      _isBorderVisible = false;
    });
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
            _buildLifeSavingAlertCard(
                "A+", "High", "Base Hospital", 'Homagama'),
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

  Widget _buildLifeSavingAlertCard(
      String bloodType, String urgencyLevel, String hospital, String city) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Card(
        child: Container(
          width: double.infinity,
          height: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            // border: _isBorderVisible
            //     ? Border.all(
            //         color: Colors.grey,
            //         width: 2,
            //       )
            //     : null,
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
                      "12:00 AM",
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
                        showConfirmationPopup(context,"A+","High","Base Hospital","Homagama");
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
