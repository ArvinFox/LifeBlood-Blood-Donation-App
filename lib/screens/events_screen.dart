import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lifeblood_blood_donation_app/components/custom_main_app_bar.dart';
import 'package:lifeblood_blood_donation_app/models/events_model.dart';
import 'package:lifeblood_blood_donation_app/providers/event_provider.dart';
import 'package:lifeblood_blood_donation_app/services/events_service.dart';
import 'package:lifeblood_blood_donation_app/utils/helpers.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
 
class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsScreen> {
  final EventService _eventService = EventService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final eventProvider = Provider.of<EventProvider>(context,listen: false);

      if(eventProvider.events.isEmpty){
        eventProvider.fetchEvent();
      }
    });
  }

  Future<void> shareEvent(DonationEvents event, String imageUrl) async{
    final date = DateFormat('yyyy-MM-dd').format(event.dateAndTime);
    final time = DateFormat('hh:mm a').format(event.dateAndTime);

    try{
      //download the image
      final response = await http.get(Uri.parse(imageUrl));
      final bytes = response.bodyBytes;

      //get temporary directory for store image
      final temp = await getTemporaryDirectory();
      final imagePath = path.join(temp.path, 'event_image.jpg');

      //save image locally
      final image = File(imagePath);
      await image.writeAsBytes(bytes);

final shareText = '''
🩸 *${event.eventName}* 

🗓️ *Date:* $date
⏰ *Time* $time
📌 *Location* Location......

${event.description}

_Be a hero. Save lives. Donate blood._
''';

      Share.shareXFiles([XFile(image.path)], text: shareText);

    }catch (e){
      Helpers.debugPrintWithBorder('Error : $e');
    }
  }

  void showJoinDialog(BuildContext context,DonationEvents event, String imageUrl) {
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
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              )
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
                  shareEvent(event,imageUrl);
                  Navigator.pop(context);
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
      appBar: CustomMainAppbar(title: 'Events', showLeading: true),
      backgroundColor: Colors.white,
      body: Consumer<EventProvider>(
      builder: (context, eventProvider, child){
        if (eventProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (eventProvider.events.isEmpty) {
          return const Center(child: Text("No events found"));
        }
      
        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: eventProvider.events.length,
          itemBuilder: (context, index) {
            final event = eventProvider.events[index];
            final imageUrl = _eventService.getImageUrl(event.eventId ?? '');
            return _eventContainer(
              imagePath: imageUrl,
              onJoin: () => showJoinDialog(context, event, imageUrl),
            );
          },
        );
      },
      ),
    );
  }

  Widget _eventContainer({required String imagePath, required VoidCallback onJoin}){
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 6,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Event Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
            child: Image.network(
              imagePath,
              width: 250, 
              height: 110, 
              fit: BoxFit.fill, 
            ),
          ),
          // Join Event Button
          Expanded(
            child: SizedBox(
              height: 110,
              child: ElevatedButton(
                onPressed: onJoin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 229, 15, 42),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15)),
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