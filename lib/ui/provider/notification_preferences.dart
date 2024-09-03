import 'package:flutter/cupertino.dart';
import 'package:restoranapp/utils/preferences.dart';

class NotificationPreferencesProvider extends ChangeNotifier {
  NotifPreferences notifPreferences;

  NotificationPreferencesProvider({required this.notifPreferences}) {
    getSaveButton();
  }

  bool? _inSave = false;
  bool? get notif => _inSave;

  void getSaveButton() async {
    _inSave = await notifPreferences.notif;
    notifyListeners();
  }

  void setSavebutton(bool status) {
    notifPreferences.setNotif(status);
    getSaveButton();
  }
}
