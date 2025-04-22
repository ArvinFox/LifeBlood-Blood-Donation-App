import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/models/events_model.dart';
import 'package:lifeblood_blood_donation_app/services/events_service.dart';
import 'package:lifeblood_blood_donation_app/utils/helpers.dart';

class EventProvider with ChangeNotifier{
  final EventService _eventService = EventService();
  List<DonationEvents> _events = [];
  bool _isLoading = false;

  List<DonationEvents> get events => _events;
  bool  get isLoading => _isLoading;

  Future<void> fetchEvent() async {
    _isLoading = true;
    notifyListeners();

    try {
      _events = await _eventService.getEvents();
      
    } catch (e) {
      Helpers.debugPrintWithBorder("Error fetching events: $e");
    }

    await Future.delayed(Duration(seconds: 1));

    _isLoading = false;
    notifyListeners();
  }
}