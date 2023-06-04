import 'package:flutter/cupertino.dart';

class LoginCheckProvider extends ChangeNotifier {

  bool isLoggedIn = false;

  void checkIsLoggedIn(bool loggedIn) {
    isLoggedIn = loggedIn;
    notifyListeners();
  }
}