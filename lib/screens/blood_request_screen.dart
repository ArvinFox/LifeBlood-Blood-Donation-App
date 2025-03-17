import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifeblood_blood_donation_app/components/blood_request_card.dart';
import 'package:lifeblood_blood_donation_app/models/donation_request_model.dart';

class BloodRequestScreen extends StatefulWidget {
  const BloodRequestScreen({super.key});

  @override
  State<BloodRequestScreen> createState() => _BloodRequestScreenState();
}

class _BloodRequestScreenState extends State<BloodRequestScreen> {
  final TextEditingController _provinceController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  // List to hold all fetched data
  List<DonationRequestDetails> bloodRequests = [];

  // List to hold the currently displayed cards
  List<DonationRequestDetails> displayedRequests = [];

  // Number of items to load after pressing "Load More"
  int itemsToLoad = 2;

  @override
  void initState() {
    super.initState();
    _fetchBloodRequests();
  }

  // Fetch data from Firestore and filter out the latest 3 requests
  Future<void> _fetchBloodRequests() async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('requests')
          .orderBy('createdAt', descending: true) // Order by the most recent
          .get();

      List<DonationRequestDetails> fetchedRequests = querySnapshot.docs
          .map((doc) => DonationRequestDetails.fromFirestore(doc.data()))
          .toList();

      // Exclude the latest 3 requests
      setState(() {
        bloodRequests = fetchedRequests.skip(3).toList();
        displayedRequests = bloodRequests.take(itemsToLoad).toList();
      });
    } catch (e) {
      print("Error fetching blood requests: $e");
    }
  }

  // Function to load more requests
  void loadMoreRequests() {
    setState(() {
      if (displayedRequests.length < bloodRequests.length) {
        displayedRequests.addAll(
          bloodRequests.skip(displayedRequests.length).take(itemsToLoad),
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
                itemCount: displayedRequests.length,
                itemBuilder: (context, index) {
                  return BloodRequestCard(
                    bloodRequestDetails: displayedRequests[index],
                  );
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
