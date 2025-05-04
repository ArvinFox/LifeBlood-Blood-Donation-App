import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/components/blood_request_card.dart';
import 'package:lifeblood_blood_donation_app/components/custom_main_app_bar.dart';
import 'package:lifeblood_blood_donation_app/models/donation_request_model.dart';
import 'package:lifeblood_blood_donation_app/providers/current_activity_provider.dart';
import 'package:lifeblood_blood_donation_app/providers/user_provider.dart';
import 'package:lifeblood_blood_donation_app/services/request_service.dart';
import 'package:lifeblood_blood_donation_app/utils/helpers.dart';
import 'package:provider/provider.dart';

class BloodRequestScreen extends StatefulWidget {
  const BloodRequestScreen({super.key});

  @override
  State<BloodRequestScreen> createState() => _BloodRequestScreenState();
}

class _BloodRequestScreenState extends State<BloodRequestScreen> {
  final RequestService _requestService = RequestService();

  List<BloodRequest> bloodRequests = [];
  List<BloodRequest> filteredRequests = [];
  List<BloodRequest> displayedRequests = [];

  final Map<String, List<String>> provinceCities = {
    'Western': ['Colombo', 'Gampaha', 'Kalutara'],
    'Central': ['Kandy', 'Matale', 'Nuwara Eliya'],
    'Southern': ['Galle', 'Matara', 'Hambantota'],
    'Northern': ['Jaffna', 'Kilinochchi', 'Mannar'],
    'Eastern': ['Trincomalee', 'Batticaloa', 'Ampara'],
    'North Western': ['Kurunegala', 'Puttalam'],
    'North Central': ['Anuradhapura', 'Polonnaruwa'],
    'Uva': ['Badulla', 'Monaragala'],
    'Sabaragamuwa': ['Ratnapura', 'Kegalle'],
  };
  String? _selectedProvince;
  String? _selectedCity;
  String? _previousProvince;
  String? _previousCity;

  int itemsToLoad = 2;

  bool _isLoading = false;
  bool _canReset = false;
  bool _canFilter = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        _isLoading = true;
      });

      await _fetchBloodRequests();

      setState(() {
        _isLoading = false;
      });

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (userProvider.user != null) {
        _selectedProvince = userProvider.user!.province;
        _selectedCity = userProvider.user!.city;

        _filterRequests();
      }

      _checkResetAndFilterState();
    });
  }

  Future<void> _fetchBloodRequests() async {
    try {
      List<BloodRequest> fetchedRequests = await _requestService.getBloodRequests();

      setState(() {
        bloodRequests = fetchedRequests;
        filteredRequests = bloodRequests;
        displayedRequests = bloodRequests.take(itemsToLoad).toList();
      });
    } catch (e) {
      Helpers.debugPrintWithBorder("Error fetching blood requests: $e");
    }
  }

  void _filterRequests() {
    final String? province = _selectedProvince?.toLowerCase();
    final String? city = _selectedCity?.toLowerCase();

    setState(() {
      filteredRequests = bloodRequests.where((request) {
        final bool matchesProvince = province == null ||
            request.province.toLowerCase() == province;
        final bool matchesCity = city == null ||
            request.city.toLowerCase() == city;

        return matchesProvince && matchesCity;
      }).toList();

      displayedRequests = filteredRequests.take(itemsToLoad).toList();

      // Update the last applied filters
      _previousProvince = _selectedProvince;
      _previousCity = _selectedCity;
    });

    _checkResetAndFilterState();
  }

  void _resetFilters() {
    setState(() {
      _selectedProvince = null;
      _selectedCity = null;
      _previousProvince = null;
      _previousCity = null;
      filteredRequests = bloodRequests;
      displayedRequests = filteredRequests.take(itemsToLoad).toList();

      _checkResetAndFilterState();
    });
  }

  void loadMoreRequests() {
    setState(() {
      if (displayedRequests.length < filteredRequests.length) {
        displayedRequests.addAll(
          filteredRequests.skip(displayedRequests.length).take(itemsToLoad),
        );
      }
    });
  }

  void _checkResetAndFilterState() {
    final bool isFilterChanged = 
      _selectedProvince != _previousProvince || 
      _selectedCity != _previousCity;

    final bool isAnyFilterActive = 
        _selectedProvince != null || 
        _selectedCity != null;

    setState(() {
      _canFilter = isFilterChanged && isAnyFilterActive;
      _canReset = isAnyFilterActive;
    });
  }

  void _addToCurrentActivities(BloodRequest request) {
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
        appBar: CustomMainAppbar(
        title: 'Donate Blood',
        showLeading: true,
      ),
      body: _isLoading ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(
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
                    _buildDropdown(
                      label: "Province",
                      items: provinceCities.keys.toList(),
                      value: _selectedProvince,
                      onChanged: (val) {
                        setState(() {
                          if (_selectedProvince != val) {
                            _selectedCity = null;
                          }
                          _selectedProvince = val;
                        });
                        _checkResetAndFilterState();
                      },
                    ),
                    const SizedBox(height: 15),
                    if (_selectedProvince != null)
                      _buildDropdown(
                        label: "City",
                        items: provinceCities[_selectedProvince]!,
                        value: _selectedCity,
                        onChanged: (val) {
                          setState(() {
                            _selectedCity = val;
                          });
                          _checkResetAndFilterState();
                        },
                      ),
                    const SizedBox(height: 13),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          onPressed: _canReset ? _resetFilters : null,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            foregroundColor: _canReset ? const Color(0xFFE50F2A) : Colors.grey,
                            backgroundColor: Colors.white,
                            side: BorderSide(
                              color: _canReset ? const Color(0xFFE50F2A) : Colors.grey,
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          child: Text("Reset Filter",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: _canReset ? const Color(0xFFE50F2A) : Colors.grey,
                            ),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: _canFilter ? _filterRequests : null,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 35),
                            foregroundColor: _canFilter ? const Color(0xFFE50F2A) : Colors.grey,
                            backgroundColor: Colors.white,
                            side: BorderSide(
                              color: _canFilter ? const Color(0xFFE50F2A) : Colors.grey,
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            "Filter",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: _canFilter ? const Color(0xFFE50F2A) : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Show no request found text if no results after filter
              if (displayedRequests.isEmpty) ...[
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'No blood donation requests found',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ),
              ],

              // Show blood requests when available
              if (displayedRequests.isNotEmpty) ...[
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

                if (filteredRequests.length != displayedRequests.length)
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required List<String> items,
    required String? value,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label, 
          style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold)
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          isExpanded: true,
          value: value,
          style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16,vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          items:
            items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e, overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
