import 'dart:async';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:wisdom/app.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/core/db/db_helper.dart';
import 'package:wisdom/core/db/preference_helper.dart';
import 'package:wisdom/core/localization/locale_keys.g.dart';
import 'package:wisdom/core/session/manager/session_manager.dart';
import 'package:wisdom/data/model/battle/battle_user_model.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:wisdom/domain/repositories/battle_repository.dart';
import 'package:wisdom/domain/repositories/profile_repository.dart';
import 'package:wisdom/presentation/components/dialog_background.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/battle/continue_battle_dialog.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/sign_in_dialog.dart';
import 'package:wisdom/presentation/routes/routes.dart';

import '../../../../core/di/app_locator.dart';

class ContinueBattleViewmodel extends BaseViewModel {
  ContinueBattleViewmodel({required super.context});

  final battleRepository = locator<BattleRepository>();
  final profileRepository = locator<ProfileRepository>();

  final dbHelper = locator<DBHelper>();
  final sharedPref = locator<SharedPreferenceHelper>();
  final localViewModel = locator<LocalViewModel>();

  BattleUserModel? battleOpponentUser = BattleUserModel();
  Timer? _timer;
  ValueNotifier<int> seconds = ValueNotifier<int>(20);
  ValueNotifier<bool> battleUpdateStatus = ValueNotifier<bool>(false);
  ValueNotifier<bool> continueBattleProgress = ValueNotifier<bool>(false);

  final String getUserDetailsTag = "getUserDetailsTag";

  void checkHasInProgressBattle() async {
    int battleEndDate = sharedPref.getInt(Constants.KEY_USER_BATTLE_END_TIME, 0);

    if (battleEndDate != 0) {
      final dateTimeNowInMillisecont = DateTime.now().millisecondsSinceEpoch;
      battleEndDate = battleEndDate * 1000;
      if (dateTimeNowInMillisecont < battleEndDate) {
        showTopDialog();
        return;
      } else {
        await sharedPref.prefs.remove(Constants.KEY_USER_BATTLE_END_TIME);
        await sharedPref.prefs.remove(Constants.KEY_USER_BATTLE_ID);
        await sharedPref.prefs.remove(Constants.KEY_USER_BATTLE_OPPONENT_USER);
      }
    }
  }

  Future<void> userData() async {
    safeBlock(() async {
      try {
        if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
          setBusy(true, tag: getUserDetailsTag);
          await profileRepository.getUserCabinet();
          setSuccess(tag: getUserDetailsTag);
        }
      } catch (e) {
        if (e is VMException) {
          if (e.response != null) {
            if (e.response!.statusCode == 403) {
              showDialog(
                context: context!,
                builder: (context) => const DialogBackground(
                  child: SignInDialog(),
                ),
              );
            }
          }
        }
      }
    }, callFuncName: 'getUserDetailsTag', tag: getUserDetailsTag, inProgress: false);
  }

  void continueBattle() async {
    await userData();
    safeBlock(() async {
      try {
        if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
          continueBattleProgress.value = true;
          await battleRepository.getBattleData();
          continueBattleProgress.value = false;
          _resetTimer();

          Navigator.popUntil(
            navigatorKey.currentContext!,
            (route) => route.isFirst ? true : false,
          );
          Navigator.pushNamed(navigatorKey.currentContext!, Routes.battleExercisesPage);
        } else {
          setBusy(false, tag: "getBattleDataTag");
          callBackError(LocaleKeys.no_internet.tr());
        }
      } catch (e) {
        continueBattleProgress.value = false;
        if (e is VMException) {
          if (e.response != null) {
            if (e.response!.statusCode == 403) {
              showDialog(
                context: context!,
                builder: (context) => const DialogBackground(
                  child: SignInDialog(),
                ),
              );
            }
          }
        }
      }
    }, callFuncName: 'getBattleData', tag: "getBattleDataTag", inProgress: false);
  }

  void cancelStartedBattle() async {
    safeBlock(() async {
      try {
        if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
          int battleId = sharedPref.getInt(Constants.KEY_USER_BATTLE_ID, 0);
          if (battleId == 0) {
            return;
          }
          battleUpdateStatus.value = true;

          await battleRepository.rematchUpdateStatus(battleId: battleId, status: "rejected");
          await sharedPref.prefs.remove(Constants.KEY_USER_BATTLE_END_TIME);
          await sharedPref.prefs.remove(Constants.KEY_USER_BATTLE_ID);
          await sharedPref.prefs.remove(Constants.KEY_USER_BATTLE_OPPONENT_USER);
          battleUpdateStatus.value = false;
          _resetTimer();
          if (Navigator.canPop(navigatorKey.currentContext!)) {
            Navigator.pop(navigatorKey.currentContext!);
          }
        } else {
          setBusy(false, tag: "getBattleDataTag");
          callBackError(LocaleKeys.no_internet.tr());
        }
      } catch (e) {
        battleUpdateStatus.value = false;
        if (e is VMException) {
          if (e.response != null) {
            if (e.response!.statusCode == 403) {
              locator<SessionManager>().endLocalSession();
            }
          }
        }
      }
    }, callFuncName: 'getBattleData', tag: "getBattleDataTag", inProgress: false);
  }

  void showTopDialog() {
    battleOpponentUser =
        BattleUserModel.fromJson(sharedPref.getString(Constants.KEY_USER_BATTLE_OPPONENT_USER, ""));
    _resetTimer();
    _startTimer(_decrementTimer);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showGeneralDialog(
        context: navigatorKey.currentContext!,
        barrierDismissible: false,
        barrierLabel: "Top Dialog",
        pageBuilder: (context, anim1, anim2) {
          return ContinueBattleDialog(
            viewmodel: this,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      );
    });
  }

  void _startTimer(Function() onChange) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      onChange();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  _decrementTimer() {
    if (seconds.value > 0) {
      seconds.value--;
    } else if (seconds.value == 0) {
      _stopTimer();
      cancelStartedBattle();
    }
  }

  void _resetTimer() {
    _stopTimer();

    seconds.value = 20;
  }

  @override
  callBackError(String text) {
    log(text);
    showTopSnackBar(
      Overlay.of(context!),
      CustomSnackBar.error(
        message: text,
      ),
    );
  }
}
