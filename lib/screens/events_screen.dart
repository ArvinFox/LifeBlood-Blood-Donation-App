import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/components/event_container.dart';
import 'package:lifeblood_blood_donation_app/models/events_model.dart';
import 'package:lifeblood_blood_donation_app/services/events_service.dart';
//import 'package:social_sharing_plus/social_sharing_plus.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsScreen> {
  final String contentToShare =
      "Join us for the blood donation event and save lives! Event details: Be a Hero: Save Lives Through Blood Donation at Base Hospital, Homagama.";

  final EventService _eventService = EventService();

  void showJoinDialog(BuildContext context, DonationEvents event) {
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
                    event.eventName,
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
              child: Image.network(event
                  .eventPosterUrl), // Use network image for the event poster
            ),
          ],
        ),
        content: Text(
          event.description,
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
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.red)),
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
        title: const Text(
          "Events",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFE50F2A),
        leading: CupertinoNavigationBarBackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        leadingWidth: 40, // Reduce space in between leading and text
      ),
      body: StreamBuilder<List<DonationEvents>>(
        stream: _eventService.getEvents(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var events = snapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: events.map((event) {
                  return EventContainer(
                    imagePath: event.eventPosterUrl, // Use dynamic URL
                    onJoin: () => showJoinDialog(
                        context, event), // Pass event data to the dialog
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
