import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/models/donation_request_model.dart';
import 'package:lifeblood_blood_donation_app/models/notification_model.dart';
import 'package:lifeblood_blood_donation_app/providers/current_activity_provider.dart';
import 'package:lifeblood_blood_donation_app/providers/notification_provider.dart';
import 'package:lifeblood_blood_donation_app/providers/user_provider.dart';
import 'package:lifeblood_blood_donation_app/services/notification_service.dart';
import 'package:lifeblood_blood_donation_app/utils/helpers.dart';
import 'package:provider/provider.dart';

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
  BloodRequest? latestRequest;
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notificationsProvder = Provider.of<NotificationProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen:  false);
      if (userProvider.user != null) {
        notificationsProvder.fetchNotifications(userProvider.user!.userId!);
      }
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
          Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              return IconButton(
                icon: Icon(
                  Icons.mark_email_read_outlined,
                  size: 30,
                ),
                onPressed: () {
                  Provider.of<NotificationProvider>(context, listen: false)
                    .markAllAsRead(userProvider.user!.userId!);
                },
              );
            },
          ),
          SizedBox(width: 20),
        ],
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, notificationProvider, child) {
          if (notificationProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (notificationProvider.notifications.isEmpty) {
            return const Center(child: Text("No new notifications."));
          } else {
            final List<Future<Widget>> fetchedNotifications = notificationProvider.notifications.map((notification) {
              return _buildNotificationCard(notification);
            }).toList();

            return FutureBuilder<List<Widget>>(
              future: Future.wait(fetchedNotifications),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error loading notifications: ${snapshot.error}'));
                  // return Center(child: Text('Error loading notifications. Please check back later.'));
                } else if (snapshot.hasData) {
                  return SingleChildScrollView(
                    child: Column(
                      children: snapshot.data!,
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            );
          }
        },
      ),
    );
  }

  Future<Widget> _buildNotificationCard(NotificationModel notification) async {
    final request = await _notificationService.getDonationRequestDetailsId(notification.requestId);

    return GestureDetector(
      onTap: () {
        if (!notification.isRead) {
          Provider.of<NotificationProvider>(context, listen: false)
          .markAsRead(notification.notificationId!);
        }
      },
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Card(
          color: Colors.grey[200],
          elevation: notification.isRead ? 1 : 5,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: notification.isRead ? Colors.transparent : const Color.fromARGB(255, 255, 200, 200),
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.type == 'status_update'
                      ? (notification.status == 'accepted'
                        ? "Request Accepted"
                        : "Request Cancelled")
                      : "Lifesaving Alert: Donate Blood Now!",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 5),
      
                  Row(
                    children: [
                      Icon(Icons.alarm, size: 20),
                      SizedBox(width: 10),
                      Text(
                        "${notification.timestamp.hour}:${notification.timestamp.minute.toString().padLeft(2, '0')} ${notification.timestamp.hour < 12 ? 'AM' : 'PM'}",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
      
                  if (notification.type == 'new_request' && request != null) ...[
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
                              "Blood Type : ${request.requestBloodType}",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Urgency Level : ${request.urgencyLevel}",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Location : ${request.hospitalName} - \n${request.city}",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          showConfirmationPopup(context, request.requestBloodType, request.urgencyLevel, request.hospitalName, request.city, notification.requestId);
                          if (!notification.isRead) {
                            Provider.of<NotificationProvider>(context, listen: false)
                            .markAsRead(notification.notificationId!);
                          }
                        },
                        child: Text(
                          "Read More.....",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ] else if (notification.type == 'status_update') ...[
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: notification.status == 'accepted'
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            notification.status == 'accepted' ? Icons.check_circle : Icons.cancel,
                            color: notification.status == 'accepted' ? Colors.green : Colors.red,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Your donation request has been ${notification.status}.",
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showConfirmationPopup(BuildContext context, String bloodType,String urgencyLevel, String hospital, String city, String requestId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 255, 244, 244),
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
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style:
                    OutlinedButton.styleFrom(side: BorderSide(color: Colors.red)),
                child: Text("Cancel", style: TextStyle(color: Colors.red)),
              ),
              ElevatedButton(
                onPressed: () async {
                  final request = await _notificationService.getDonationRequestDetailsId(requestId);
                  final currentActivityProvider = Provider.of<CurrentActivitiesProvider>(context, listen: false);

                  if (currentActivityProvider.currentActivities.contains(request)) {
                    Helpers.showError(context, "The request has already been confirmed and added to your activities. Please view it there.");
                    return;
                  }
                  
                  currentActivityProvider..addActivity(request!);
                  Helpers.showSucess(context, "Blood donation request confirmed and added to your activities.");
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text("Confirm", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

enum NotificationPageNavigation {
  bottomNavigation,
  sideDrawer,
}
