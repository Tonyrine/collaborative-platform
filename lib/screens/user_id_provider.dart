import 'package:flutter/material.dart';

class UserIdProvider extends ChangeNotifier {
  String _userId = ''; // Initialize with an empty string
  String _firstname = ''; // Initialize with an empty string

  String get userId => _userId;
  String get firstname => _firstname;

  void setUserId(String userId, String firstname) {
    _userId = userId;
    _firstname = firstname;
    notifyListeners();
  }
}
