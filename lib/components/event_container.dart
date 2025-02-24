import 'package:flutter/material.dart';

class EventContainer extends StatefulWidget {
  final String imagePath;
  final VoidCallback onJoin; // Function when button is clicked

  const EventContainer({
    super.key,
    required this.imagePath,
    required this.onJoin,
  });

  @override
  State<EventContainer> createState() => EventContainerState();
}

class EventContainerState extends State<EventContainer> {
  @override
  Widget build(BuildContext context) {
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
            child: Image.asset(
              widget.imagePath,
              width: 250, // Adjust image size
              height: 110, // Adjust container height
              fit: BoxFit.fill, // Fills container
            ),
          ),
          // Join Event Button
          Expanded(
            child: SizedBox(
              height: 110,
              child: ElevatedButton(
                onPressed: widget.onJoin,
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
