import 'package:flutter/material.dart';

class PhoneNum with ChangeNotifier {
  String _phone;

  mobileNofify(String mobile){
    _phone=mobile;
    notifyListeners();
  }
  get phone => _phone;
}