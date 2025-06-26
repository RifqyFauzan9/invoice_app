import 'package:flutter/widgets.dart';

import '../model/common/profile.dart';
import '../model/common/user.dart';

class ProfileProvider extends ChangeNotifier {
  Profile? _profile;
  Person? _person;

  Profile? get profile => _profile;
  Person? get person => _person;

  void setProfile(Profile profile) {
    _profile = profile;
    notifyListeners();
  }

  void setPerson(Person person) {
    _person = person;
    notifyListeners();
  }

  void reset() {
    _profile = null;
    _person = null;
    notifyListeners();
  }
}
