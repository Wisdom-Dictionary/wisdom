import 'dart:async';

import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:wisdom/core/di/app_locator.dart';
import 'package:wisdom/core/services/purchase_observer.dart';
import 'package:wisdom/domain/repositories/user_live_repository.dart';

class CountdownProvider with ChangeNotifier {
  final UserLiveRepository _userLiveRepository = locator<UserLiveRepository>();
  ValueNotifier status = ValueNotifier<FormzSubmissionStatus>(FormzSubmissionStatus.initial);

  Timer? _timer;
  DateTime? _targetTime;

  CountdownProvider() {
    getLives();
  }

  Future<void> getLives() async {
    status.value = FormzSubmissionStatus.inProgress;
    await _userLiveRepository.getLives();
    status.value = FormzSubmissionStatus.success;
    _setTargetTimeFromRepository();
    _startTimerIfNeeded();
    notifyListeners();
  }

  /// Parses recovery time from the repository
  void _setTargetTimeFromRepository() {
    final raw = _userLiveRepository.userLifesModel?.recoveryTimeDatetime;
    if (raw == null) return;

    _targetTime = DateTime.tryParse(raw.replaceAll(" ", "T"));
  }

  /// Starts periodic notifier for UI
  void _startTimerIfNeeded() {
    if (_targetTime == null || remainingSeconds <= 0) return;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remainingSeconds <= 0) {
        _timer?.cancel();
        if (PurchasesObserver().isPro()) {
          getLives();
        }
      }
      notifyListeners();
    });
  }

  /// Claiming lives resets the target
  Future<void> claimLives() async {
    status.value = FormzSubmissionStatus.inProgress;
    await _userLiveRepository.claimLives();
    _setTargetTimeFromRepository();
    _startTimerIfNeeded();
    status.value = FormzSubmissionStatus.success;
    notifyListeners();
  }

  /// Remaining seconds based on real-time
  int get remainingSeconds {
    if (_targetTime == null) return 0;
    final seconds = _targetTime!.difference(DateTime.now()).inSeconds;
    return seconds;
  }

  /// Formatted timer string like "02:30"
  static String formatTimer(int value) =>
      "${value ~/ 60}:${(value % 60).toString().padLeft(2, '0')}";

  /// Accessors
  bool get hasUserLives => userLife != 0;
  bool get fullUserLives => userLife >= maxUserLive;

  int get userLife => _userLiveRepository.userLifesModel?.lives ?? 0;
  int get maxUserLive => _userLiveRepository.userLifesModel?.maxLives ?? 3;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
