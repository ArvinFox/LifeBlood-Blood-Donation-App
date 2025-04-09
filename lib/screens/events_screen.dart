import 'package:flutter/cupertino.dart';
 import 'package:flutter/material.dart';
 
 class EventsScreen extends StatefulWidget {
   const EventsScreen({super.key});
 
   @override
   State<EventsScreen> createState() => _EventsPageState();
 }
 
 class _EventsPageState extends State<EventsScreen> {
   void showJoinDialog(BuildContext context) {
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
                     "Be a Hero: Save Lives Through Blood Donation",
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
               child: Image.asset("assets/images/events_banner1.jpg"),
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
                 onPressed: () => Navigator.pop(context),
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
         leadingWidth: 40, 
       ),
       backgroundColor: Colors.white,
       body: SingleChildScrollView(
         child: Padding(
           padding: EdgeInsets.all(20),
           child: Column(
             children: [
               _eventContainer(
                 imagePath: "assets/images/events_banner1.jpg",
                 onJoin: () => showJoinDialog(context),
               ),
               _eventContainer(
                 imagePath: "assets/images/events_banner2.png",
                 onJoin: () => showJoinDialog(context),
               ),
               _eventContainer(
                 imagePath: "assets/images/events_banner1.jpg",
                 onJoin: () => showJoinDialog(context),
               ),
               _eventContainer(
                 imagePath: "assets/images/events_banner2.png",
                 onJoin: () => showJoinDialog(context),
               ),
             ],
           ),
         ),
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
            child: Image.asset(
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