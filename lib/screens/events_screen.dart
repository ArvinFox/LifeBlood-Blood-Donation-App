import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lifeblood_blood_donation_app/components/custom_main_app_bar.dart';
import 'package:lifeblood_blood_donation_app/models/events_model.dart';
import 'package:lifeblood_blood_donation_app/services/events_service.dart';
import 'package:lifeblood_blood_donation_app/utils/helpers.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final EventService _eventService = EventService();
  late Future<List<EventWithId>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _eventsFuture = _eventService.getEvents();
  }

  Future<void> shareEvent(DonationEvents event, String imageUrl) async {
    final date = DateFormat('yyyy-MM-dd').format(event.dateAndTime);
    final time = DateFormat('hh:mm a').format(event.dateAndTime);

    try {
      final response = await http.get(Uri.parse(imageUrl));
      final bytes = response.bodyBytes;

      final tempDir = await getTemporaryDirectory();
      final imagePath = path.join(tempDir.path, 'event_image.jpg');
      final file = File(imagePath);
      await file.writeAsBytes(bytes);

      final shareText = '''
🩸 ${event.eventName}

🗓 Date: $date
⏰ Time: $time
📍 Location: ${event.location}

📝 Details:
${event.description}

❤ Be a Hero. Save Lives. Donate Blood!  
#BloodDonation #SaveLives
''';

      Share.shareXFiles([XFile(file.path)], text: shareText);
    } catch (e) {
      Helpers.debugPrintWithBorder('Error sharing event: $e');
    }
  }

  void showJoinDialog(DonationEvents event, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        titlePadding: EdgeInsets.zero,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        actionsPadding: const EdgeInsets.only(bottom: 10),
        title: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    event.eventName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 10),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: 150,
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image, size: 80, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: const Text(
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
                  shareEvent(event, imageUrl);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Share", style: TextStyle(color: Colors.white)),
              ),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                ),
                child: const Text("Cancel", style: TextStyle(color: Colors.red)),
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
      appBar: const CustomMainAppbar(title: 'Events', showLeading: true),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<EventWithId>>(
        future: _eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.red));

          } else if (snapshot.hasError) {
            Helpers.debugPrintWithBorder("Error displaying events: ${snapshot.error}");
            return const Center(child: Text('An error occurred while loading events. Please try again.'));

          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No events found"));
            
          } else {
            final events = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final eventWithId = events[index];
                final event = eventWithId.event;
                final imageUrl =
                    'https://lwifhyarxkcqhewdboby.supabase.co/storage/v1/object/public/events/${eventWithId.id}/${event.image}';

                return _eventCard(
                  imageUrl: imageUrl,
                  onJoinTap: () => showJoinDialog(event, imageUrl),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _eventCard({required String imageUrl, required VoidCallback onJoinTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
            child: Image.network(
              imageUrl,
              width: 250,
              height: 110,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 250,
                  height: 110,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, size: 80, color: Colors.grey),
                );
              },
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 110,
              child: ElevatedButton(
                onPressed: onJoinTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE50F2A),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                ),
                child: const Text(
                  "Join Event",
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}