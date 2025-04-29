import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
                  Helpers.debugPrintWithBorder("Error loading notifications: ${snapshot.error}");
                  return Center(child: Text('Error loading notifications. Please check back later.'));
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
    BloodRequest? request;
    if (notification.type == 'new_request') {
      request = await _notificationService.getDonationRequestDetailsId(notification.requestId!);
    }

    return GestureDetector(
      onTap: () {
        if (!notification.isRead) {
          Provider.of<NotificationProvider>(context, listen: false)
          .markAsRead(notification.notificationId!);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Card(
          color: const Color.fromARGB(255, 255, 247, 247),
          elevation: notification.isRead ? 1 : 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: notification.isRead
                ? Colors.transparent
                : (notification.type == 'verification_status' && notification.status == 'approved')
                    ? Colors.green.shade200
                    : const Color.fromARGB(255, 255, 204, 204),
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.type == 'verification_status'
                    ? (notification.status == 'approved'
                        ? "Profile Verified"
                        : "Profile Rejected")
                    : "Lifesaving Alert: Donate Blood Now!",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: notification.type == 'verification_status' && notification.status == 'approved'
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
                SizedBox(height: 8),
                
                Row(
                  children: [
                    Icon(Icons.access_time, size: 26, color: Colors.grey[600],),
                    SizedBox(width: 6),
                    Text(
                      _formatNotificationTime(notification.timestamp),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                
                if (notification.type == 'new_request' && request != null) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          "assets/images/emergency.jpg",
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _infoText("Blood Type", request.requestBloodType),
                            _infoText("Urgency", request.urgencyLevel),
                            _infoText("Location", "${request.hospitalName} - ${request.city}",
                                maxLines: 2),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        showConfirmationPopup(
                          context, 
                          request!.requestBloodType, 
                          request.urgencyLevel, 
                          request.hospitalName, 
                          request.city, 
                          notification.requestId!,
                        );
                        if (!notification.isRead) {
                          Provider.of<NotificationProvider>(context, listen: false)
                              .markAsRead(notification.notificationId!);
                        }
                      },
                      child: Text(
                        "Read More...",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                ] else if (notification.type == 'verification_status') ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: notification.status == 'approved'
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          notification.status == 'approved' ? Icons.check_circle : Icons.cancel,
                          color: notification.status == 'approved' ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            notification.status == 'approved'
                                ? "Congratulations! Your donor profile is now verified."
                                : "Your donor profile was not approved. Please review the details and try again.",
                            style: TextStyle(
                              fontSize: 14, 
                              fontWeight: FontWeight.w500,
                            ),
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
    );
  }

  Widget _infoText(String label, String value, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        "$label: $value",
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        softWrap: true,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _formatNotificationTime(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(Duration(days: 1));
    final notificationDate = DateTime(timestamp.year, timestamp.month, timestamp.day);

    if (notificationDate == today) {
      return DateFormat.jm().format(timestamp);
    } else if (notificationDate == yesterday) {
      return "Yesterday";
    } else if (timestamp.year != now.year) {
      return DateFormat('MMM d, yyyy').format(timestamp);
    } else {
      return DateFormat('MMM d').format(timestamp);
    }
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
                        "Location : $hospital - $city",
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
