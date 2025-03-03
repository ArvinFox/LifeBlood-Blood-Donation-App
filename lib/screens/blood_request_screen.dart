import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/components/blood_request_card.dart';

class BloodRequestScreen extends StatefulWidget {
  const BloodRequestScreen({super.key});

  @override
  State<BloodRequestScreen> createState() => _BloodRequestScreenState();
}

class _BloodRequestScreenState extends State<BloodRequestScreen> {
  final TextEditingController _provinceController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  final List<BloodRequestCard> bloodRequest = [
    BloodRequestCard(
      bloodType: "AB+",
      urgencyLevel: "High",
      location: "Base Hospital - Homagama",
      contactInfo: "077XXXXXXX",
    ),
    BloodRequestCard(
      bloodType: "O-",
      urgencyLevel: "Urgent",
      location: "General Hospital - Colombo",
      contactInfo: "077XXXXXXX",
    ),
    BloodRequestCard(
      bloodType: "AB+",
      urgencyLevel: "High",
      location: "Base Hospital - Homagama",
      contactInfo: "077XXXXXXX",
    ),
    BloodRequestCard(
      bloodType: "O-",
      urgencyLevel: "Urgent",
      location: "General Hospital - Colombo",
      contactInfo: "077XXXXXXX",
    ),
  ];

  //to hold the current display blood requests
  List<BloodRequestCard> displayedCards = [];

  // no of items that load after click load more
  int itemsLoad = 2;

  @override
  void initState() {
    super.initState();
    displayedCards = bloodRequest.take(itemsLoad).toList();
  }

  //function to load more blood request cards
  void loadMoreRequests() {
    setState(() {
      if (displayedCards.length < bloodRequest.length) {
        displayedCards.addAll(
          bloodRequest.skip(displayedCards.length).take(itemsLoad),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFE50F2A),
        title: const Text(
          "Lifesaving Alerts: Donate Blood Now!",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: CupertinoNavigationBarBackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        leadingWidth: 40, // Reduce space in between leading and text
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 8),
              const Text(
                "Urgent help needed! Browse the list of blood donation requests and be a hero. Your donation can save lives and bring hope. Every drop counts!",
                textAlign: TextAlign.center,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 18),
                padding: EdgeInsets.all(13),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.5),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 70,
                          child: const Text("Province"),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            controller: _provinceController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        SizedBox(width: 70, child: const Text("City")),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            controller: _cityController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 13),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 35),
                            side:
                                BorderSide(color: Color(0xFFE50F2A), width: 1),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            "Filter",
                            style: TextStyle(
                                color: Color(0xFFE50F2A), fontSize: 12),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _provinceController.clear();
                              _cityController.clear();
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            side:
                                BorderSide(color: Color(0xFFE50F2A), width: 1),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          child: Text("Reset Filter",
                              style: TextStyle(
                                  color: Color(0xFFE50F2A), fontSize: 12)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: displayedCards.length,
                itemBuilder: (context, index) {
                  return displayedCards[index];
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: loadMoreRequests,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE50F2A),
                    padding: EdgeInsets.only(left: 100, right: 100)),
                child: Text(
                  "Load More",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
