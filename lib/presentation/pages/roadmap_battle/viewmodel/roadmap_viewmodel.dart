import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:provider/provider.dart';
import 'package:wisdom/app.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/core/db/db_helper.dart';
import 'package:wisdom/core/db/preference_helper.dart';
import 'package:wisdom/core/localization/locale_keys.g.dart';
import 'package:wisdom/data/model/battle/battle_user_model.dart';
import 'package:wisdom/data/model/my_contacts/user_details_model.dart';
import 'package:wisdom/data/model/roadmap/level_model.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:wisdom/domain/repositories/battle_repository.dart';
import 'package:wisdom/domain/repositories/level_test_repository.dart';
import 'package:wisdom/domain/repositories/profile_repository.dart';
import 'package:wisdom/domain/repositories/roadmap_repository.dart';
import 'package:wisdom/presentation/components/dialog_background.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/battle/continue_battle_dialog.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/battle/out_of_lives_dialog.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/battle/start_battle_dialog.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/sign_in_dialog.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/viewmodel/life_countdown_provider.dart';
import 'package:wisdom/presentation/routes/routes.dart';

import '../../../../core/di/app_locator.dart';

class RoadMapViewModel extends BaseViewModel {
  RoadMapViewModel({required super.context});

  final profileRepository = locator<ProfileRepository>();
  final roadMapRepository = locator<RoadmapRepository>();
  final levelTestRepository = locator<LevelTestRepository>();
  final battleRepository = locator<BattleRepository>();
  final dbHelper = locator<DBHelper>();
  final sharedPref = locator<SharedPreferenceHelper>();
  final localViewModel = locator<LocalViewModel>();

  final String getLevelsTag = "getLevelsTag",
      getLevelsMoreTag = "getLevelsMoreTag",
      getUserDetailsTag = "getUserDetailsTag";
  int page = 0;
  UserDetailsModel? userDetailsModel;
  BattleUserModel? battleOpponentUser = BattleUserModel();
  Timer? _timer;
  ValueNotifier<int> seconds = ValueNotifier<int>(20);
  ValueNotifier<bool> battleUpdateStatus = ValueNotifier<bool>(false);
  ValueNotifier<bool> continueBattleProgress = ValueNotifier<bool>(false);

  int get pathSize => (listCountCeil * 0.5).floor();

  int get listCountCeil => roadMapRepository.levelsList.length;

  void userData() {
    safeBlock(() async {
      try {
        if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
          setBusy(true, tag: getUserDetailsTag);
          if (profileRepository.userCabinet.user == null) {
            userDetailsModel = await profileRepository.getUserCabinet();
          } else {
            userDetailsModel = profileRepository.userCabinet;
          }
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
    }, callFuncName: 'getLevels', tag: getLevelsTag, inProgress: false);
  }

  void getLevels() {
    safeBlock(() async {
      try {
        if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
          setBusy(true, tag: getLevelsTag);
          await roadMapRepository.getLevels(++page);
          setSuccess(tag: getLevelsTag);
        } else {
          setBusy(false, tag: getLevelsTag);
          callBackError(LocaleKeys.no_internet.tr());
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
    }, callFuncName: 'getLevels', tag: getLevelsTag, inProgress: false);
  }

  void getLevelsMore() {
    safeBlock(() async {
      try {
        if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
          setBusy(true, tag: getLevelsMoreTag);
          await roadMapRepository.getLevels(++page);
          setSuccess(tag: getLevelsMoreTag);
        } else {
          callBackError(LocaleKeys.no_internet.tr());
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
    }, callFuncName: 'getLevelsMore', tag: getLevelsMoreTag, inProgress: false);
  }

  void selectLevel(LevelModel item) async {
    final noUserLives = !context!.read<CountdownProvider>().hasUserLifes;
    if (noUserLives) {
      showDialog(
        context: context!,
        builder: (context) => OutOfLivesDialog(
          title: "you_did_not_start_the_battle".tr(),
          subTitle: "you_do_not_have_enough_lives".tr(),
        ),
      );
      return;
    }
    if (item.type == LevelType.battle) {
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

      battleRepository.setSelectedLevelItem(item);
      showDialog(
        context: context!,
        builder: (context) => StartBattleDialog(),
      );
      return;
    }
    if (!(item.userCurrentLevel ?? false) && (item.star ?? 0) == 0) {
      return;
    }
    roadMapRepository.setSelectedLevel(item);
    levelTestRepository.setSelectedLevel(item);
    locator<LocalViewModel>().changePageIndex(25);
  }

  void continueBattle() async {
    safeBlock(() async {
      try {
        if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
          continueBattleProgress.value = true;
          await battleRepository.getBattleData();
          continueBattleProgress.value = false;
          _resetTimer();
          if (Navigator.canPop(navigatorKey.currentContext!)) {
            Navigator.pop(navigatorKey.currentContext!);
          }
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

  void showTopDialog() {
    battleOpponentUser =
        BattleUserModel.fromJson(sharedPref.getString(Constants.KEY_USER_BATTLE_OPPONENT_USER, ""));
    _resetTimer();
    _startTimer(_decrementTimer);
    showGeneralDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: true,
      barrierLabel: "Top Dialog",
      pageBuilder: (context, anim1, anim2) {
        return ContinueBattleDialog(
          viewmodel: this,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
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
}
