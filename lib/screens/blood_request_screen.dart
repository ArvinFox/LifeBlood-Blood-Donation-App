import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifeblood_blood_donation_app/components/blood_request_card.dart';
import 'package:lifeblood_blood_donation_app/models/donation_request_model.dart';
import 'package:lifeblood_blood_donation_app/providers/current_activity_provider.dart';
import 'package:provider/provider.dart';

class BloodRequestScreen extends StatefulWidget {
  const BloodRequestScreen({super.key});

  @override
  State<BloodRequestScreen> createState() => _BloodRequestScreenState();
}

class _BloodRequestScreenState extends State<BloodRequestScreen> {
  final TextEditingController _provinceController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  List<DonationRequestDetails> bloodRequests = [];
  List<DonationRequestDetails> displayedRequests = [];

  int itemsToLoad = 2;

  bool isFiltered = false;

  @override
  void initState() {
    super.initState();
    _fetchBloodRequests();
  }

  Future<void> _fetchBloodRequests() async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('requests')
          .orderBy('createdAt', descending: true)
          .get();

      List<DonationRequestDetails> fetchedRequests = querySnapshot.docs
          .map((doc) => DonationRequestDetails.fromFirestore(doc.data()))
          .toList();

      setState(() {
        bloodRequests = fetchedRequests.skip(3).toList();
        displayedRequests = bloodRequests.take(itemsToLoad).toList();
      });
    } catch (e) {
      print("Error fetching blood requests: $e");
    }
  }

  void _filterRequests() {
    String province = _provinceController.text.trim().toLowerCase();
    String city = _cityController.text.trim().toLowerCase();

    if (province.isEmpty && city.isEmpty) {
      // Show Snackbar if both province and city are empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
              "Please enter at least one of the fields (Province or City)."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      isFiltered = true;
      displayedRequests = bloodRequests.where((request) {
        bool matchesProvince = province.isEmpty ||
            request.province.toLowerCase().contains(province);
        bool matchesCity =
            city.isEmpty || request.city.toLowerCase().contains(city);
        return matchesProvince && matchesCity;
      }).toList();
    });
  }

  void _resetFilters() {
    setState(() {
      _provinceController.clear();
      _cityController.clear();
      displayedRequests = bloodRequests.take(itemsToLoad).toList();
      isFiltered = false;
    });

    // Show Snackbar on Reset Filter if no province or city is entered
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Please enter a province or city to filter."),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  void loadMoreRequests() {
    setState(() {
      if (displayedRequests.length < bloodRequests.length) {
        displayedRequests.addAll(
          bloodRequests.skip(displayedRequests.length).take(itemsToLoad),
        );
      }
    });
  }

  void _addToCurrentActivities(DonationRequestDetails request) {
    final provider =
        Provider.of<CurrentActivitiesProvider>(context, listen: false);

    // Check if the request is already in current activities
    if (provider.currentActivities.contains(request)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
              "This Request is already Added to your Current Activities. Check it out under Current Activities Section."),
          backgroundColor: Colors.redAccent,
        ),
      );
    } else {
      provider
          .addActivity(request); // Add the request to the current activities
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
              "Blood Donation Confirmed and Added to Current Activities!"),
          backgroundColor: Colors.green,
        ),
      );
    }
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
        leadingWidth: 40,
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
                margin: const EdgeInsets.symmetric(vertical: 18),
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.5),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 70, child: Text("Province")),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _provinceController,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const SizedBox(width: 70, child: Text("City")),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _cityController,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 13),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          onPressed: _filterRequests,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 35),
                            side: const BorderSide(
                                color: Color(0xFFE50F2A), width: 1),
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
                          onPressed: _resetFilters,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            side: const BorderSide(
                                color: Color(0xFFE50F2A), width: 1),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          child: const Text("Reset Filter",
                              style: TextStyle(
                                  color: Color(0xFFE50F2A), fontSize: 12)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              // Show no request found text if no results after filter
              if (displayedRequests.isEmpty && isFiltered)
                const Center(
                  child: Text(
                    'No blood donation requests found',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ),
              // Show blood requests when available
              if (displayedRequests.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displayedRequests.length,
                  itemBuilder: (context, index) {
                    return BloodRequestCard(
                      bloodRequestDetails: displayedRequests[index],
                      onConfirm: () {
                        // When 'Yes' is clicked in the dialog, add to current activities
                        _addToCurrentActivities(displayedRequests[index]);
                      },
                    );
                  },
                ),
              const SizedBox(height: 20),
              // Only show load more button if there are requests
              if (displayedRequests.isNotEmpty && !isFiltered)
                ElevatedButton(
                  onPressed: loadMoreRequests,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE50F2A),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 100, vertical: 10)),
                  child: const Text(
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
