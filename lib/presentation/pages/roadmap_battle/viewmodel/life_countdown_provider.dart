import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wisdom/core/di/app_locator.dart';
import 'package:wisdom/domain/repositories/user_live_repository.dart';

class CountdownProvider with ChangeNotifier {
  final UserLiveRepository _userLiveRepository = locator<UserLiveRepository>();
  int remainingSeconds = 0;
  Timer? _timer;

  CountdownProvider() {
    getLives();
  }

  int get userLife => _userLiveRepository.userLifesModel?.lives ?? 0;

  int get maxUserLife => _userLiveRepository.userLifesModel?.maxLives ?? 3;

  DateTime? getRecoveryDateTime() {
    if (_userLiveRepository.userLifesModel == null ||
        _userLiveRepository.userLifesModel!.recoveryTimeDatetime == null) {
      return null;
    }
    return DateTime.parse(
        _userLiveRepository.userLifesModel!.recoveryTimeDatetime!.replaceAll(" ", "T"));
  }

  getLives() async {
    await _userLiveRepository.getLives();
    fetchCountdown();
  }

  fetchCountdown() async {
    DateTime? recoveryTimeDatetime = getRecoveryDateTime();
    if (recoveryTimeDatetime != null) {
      int newValueSeconds = recoveryTimeDatetime.difference(DateTime.now()).inSeconds;
      if (remainingSeconds != newValueSeconds) {
        remainingSeconds = newValueSeconds;
        notifyListeners();
        if (remainingSeconds > 0) {
          startCountdown();
        }
      }
      return;
    }
    notifyListeners();
  }

  Future<void> claimLives() async {
    await _userLiveRepository.claimLives();
    fetchCountdown();
  }

  /// **Timer boshlash**
  void startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        remainingSeconds--;
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
