import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  String db = "db";
  String name = "waio";
  String index = "index";
  String dbVersion = "db_version";
  String isUpdated = "is_updated";
  String fontSize = "font_size";
  String isFirstTime = "is_first_time";
  String lastDialogShowTimeKey = 'lastDialogShowTime';

  late SharedPreferences prefs;

  Future<void> updateLastDialogShowTime() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt(lastDialogShowTimeKey, DateTime.now().millisecondsSinceEpoch);
  }

  Future<DateTime?> getLastDialogShowTime() async {
    final preferences = await SharedPreferences.getInstance();
    final lastShowTimeInMillis = preferences.getInt(lastDialogShowTimeKey);
    if (lastShowTimeInMillis != null) {
      return DateTime.fromMillisecondsSinceEpoch(lastShowTimeInMillis);
    }
    return null;
  }

  Future getInstance() async {
    prefs = await SharedPreferences.getInstance();
  }

  void saveDB(bool sbStatus) {
    putBoolean(db, true);
  }

  void saveDBIndex(int index) {
    putInt(this.index, index);
  }

  int getIndex() {
    return getInt(index, 1);
  }

  void saveDBVersion(int dbVersion) {
    putInt(this.dbVersion, dbVersion);
  }

  int getIDBVersion() {
    return getInt(dbVersion, 0); // because now it has this version
  }

  void putString(String key, String value) {
    prefs.setString(key, value);
  }

  String getString(String key, String defValue) {
    return prefs.getString(key) ?? defValue;
  }

  void putInt(String key, int value) {
    prefs.setInt(key, value);
  }

  int getInt(String key, int defValue) {
    return prefs.getInt(key) ?? defValue;
  }

  void putDouble(String key, double value) {
    prefs.setDouble(key, value);
  }

  double getDouble(String key, double defValue) {
    return prefs.getDouble(key) ?? defValue;
  }

  void putBoolean(String key, bool value) {
    prefs.setBool(key, value);
  }

  bool getBoolean(String key, bool defValue) {
    return prefs.getBool(key) ?? defValue;
  }

  clear() {
    prefs.clear();
  }
}
