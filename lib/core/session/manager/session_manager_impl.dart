import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/core/db/preference_helper.dart';
import 'package:wisdom/core/di/app_locator.dart';
import 'package:wisdom/core/services/purchase_observer.dart';
import 'package:wisdom/domain/repositories/word_entity_repository.dart';

import 'session_manager.dart';

class SessionManagerImpl extends SessionManager {
  final SharedPreferenceHelper _preferences;

  // final WordEntityRepository _wordEntityRepository;

  SessionManagerImpl({
    required SharedPreferenceHelper preferences,
    // required WordEntityRepository wordEntityRepository,
  }) : _preferences = preferences;

  // _wordEntityRepository = wordEntityRepository;

  @override
  Future<void> endRemoteSession() async {
    //end remote session
  }

  @override
  Future<void> endLocalSession() async {
    await _preferences.clear();
    _preferences.putBoolean(Constants.APP_STATE, false);
    PurchasesObserver().profileState = Constants.STATE_INACTIVE;
    await locator.get<WordEntityRepository>().clearWordBank();
  }

  @override
  String get authorization => "token";

  @override
  int get timeout => 30000;

  @override
  bool validate(int code) {
    if (code >= 200 && code <= 400) {
      return true;
    } else {
      return false;
    }
  }

  @override
  String? get accessToken => _preferences.getString(Constants.KEY_TOKEN, '').isNotEmpty
      ? _preferences.getString(Constants.KEY_TOKEN, '')
      : null;
}
