import 'package:flutter/cupertino.dart';
import 'package:to_do_app/MyUser.dart';

class AuthUserProvider extends ChangeNotifier {
  MyUser? currentUser;

  void changeUser(MyUser newUser) {
    currentUser = newUser;
    notifyListeners();
  }
}
