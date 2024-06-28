import 'package:flutter/material.dart';

class UserIdProvider extends ChangeNotifier {
  String _userId = ''; // Initialize with an empty string

  String get userId => _userId;

  void setUserId(String userId) {
    _userId = userId;
    notifyListeners();
  }
}
