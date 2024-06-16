import 'package:flutter/material.dart';

class FaceIdModel extends ChangeNotifier {
  bool _isSwitched = false;
  bool get isSwitched => _isSwitched;

  void setSwitch(bool newValue) {
    _isSwitched = newValue;
    notifyListeners();
  }
}
