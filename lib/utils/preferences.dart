import 'package:shared_preferences/shared_preferences.dart';

class NotifPreferences {
  final Future<SharedPreferences> sharedPreferences;

  NotifPreferences({required this.sharedPreferences});

  static const saveNotif = "Save Notif";

  Future<bool> get notif async {
    final prefs = await sharedPreferences;
    return prefs.getBool(saveNotif) ?? false;
  }

  void setNotif (bool status) async {
    final prefs = await sharedPreferences;
    prefs.setBool(saveNotif, status);
  }
  
}