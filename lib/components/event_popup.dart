import 'package:flutter/material.dart';

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
