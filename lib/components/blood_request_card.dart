import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/models/donation_request_model.dart';
import 'package:lifeblood_blood_donation_app/providers/user_provider.dart';
import 'package:lifeblood_blood_donation_app/services/request_service.dart';
import 'package:provider/provider.dart';

class BloodRequestCard extends StatelessWidget {
  final BloodRequest request;

  BloodRequestCard({
    super.key,
    required this.request,
  });

  final RequestService _requestService = RequestService();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return GestureDetector(
      onTap: () {
        if (userProvider.user!.isDonorVerified!) {
          if (userProvider.user!.isDonating) {
            _showInvalidActionPopup(
              context,
              title: "Donation in Progress",
              message: "You are currently fulfilling a donation request. Please complete your current donation before accepting a new one. ",
            );
          } else {
            _showRequestConfirmDialog(context, request);
          }
        } else {
          if (userProvider.user!.hasCompletedProfile!) {
            _showInvalidActionPopup(
              context,
              title: "Verification Pending",
              message:
                "Your donor profile is under review. You can accept requests once you are verified.",
            );
          } else {
            _showInvalidActionPopup(
              context,
              title: "Complete Your Profile",
              message:
                "Please complete your donor profile to start accepting blood donation requests.",
            );
          }
        }
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
          color: Colors.red.shade50.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
        ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFFE50F2A),
                radius: 30,
                child: Text(
                  request.requestBloodType,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRichText('Urgency Level: ', request.urgencyLevel),
                    const SizedBox(height: 6),
                    _buildRichText('Location: ', request.hospitalName),
                    const SizedBox(height: 4),
                    _buildRichText('City: ', request.city),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRichText(String title, String value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  void _showRequestConfirmDialog(BuildContext context, BloodRequest request) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 255, 238, 238),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.bloodtype, color: Colors.redAccent),
            SizedBox(width: 8),
            Text(
              'Confirm Donation',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to donate blood for this request?',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          OutlinedButton.icon(
            icon: Icon(Icons.cancel, color: Colors.grey),
            onPressed: () => Navigator.pop(context),
            label: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          SizedBox(width: 8),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            icon: Icon(Icons.check, color: Colors.white),
            label: Text('Confirm', style: TextStyle(color: Colors.white)),
            onPressed: () async {
              Navigator.pop(context);
              
              await userProvider.saveCurrentActivity(request.requestId!);

              final user = userProvider.user;
              await userProvider.updateStatus(user!.userId!, 'isDonating', true);
              await _requestService.updateConfirmedDonors(request.requestId!, user.userId!, 'confirmed');

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Donation confirmed! The request has been added to your Current Activity.'),
                  backgroundColor: Colors.green[600],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showInvalidActionPopup(BuildContext context, {required String title, required String message}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
