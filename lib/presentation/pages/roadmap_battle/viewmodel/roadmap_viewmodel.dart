import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:jbaza/jbaza.dart';
import 'package:provider/provider.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/core/db/db_helper.dart';
import 'package:wisdom/core/db/preference_helper.dart';
import 'package:wisdom/data/model/my_contacts/user_details_model.dart';
import 'package:wisdom/data/model/roadmap/level_model.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:wisdom/domain/repositories/battle_repository.dart';
import 'package:wisdom/domain/repositories/level_test_repository.dart';
import 'package:wisdom/domain/repositories/profile_repository.dart';
import 'package:wisdom/domain/repositories/roadmap_repository.dart';
import 'package:wisdom/presentation/components/dialog_background.dart';
import 'package:wisdom/presentation/components/no_internet_connection_dialog.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/battle/out_of_lives_dialog.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/battle/start_battle_dialog.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/sign_in_dialog.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/viewmodel/life_countdown_provider.dart';

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

  final String getLevelsTag = "getLevelsTag", getUserDetailsTag = "getUserDetailsTag";
  int page = 0;
  UserDetailsModel? userDetailsModel;

  int get pathSize => (listCountCeil * 0.5).floor();

  // int get listCountCeil => (roadMapRepository.levelsList.length % 10).isOdd
  //     ? roadMapRepository.levelsList.length + 1
  //     : roadMapRepository.levelsList.length;
  int get listCountCeil => roadMapRepository.levelsList.length;

  void userData() {
    safeBlock(() async {
      try {
        if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
          setBusy(true, tag: getUserDetailsTag);
          if (profileRepository.userCabinet == null) {
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
          showDialog(
            context: context!,
            builder: (context) => const DialogBackground(
              child: NoInternetConnectionDialog(),
            ),
          );
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

  void selectLevel(LevelModel item) async {
    final noUserLives = !context!.read<CountdownProvider>().hasUserLifes;
    if (noUserLives) {
      showDialog(
        context: context!,
        builder: (context) => OutOfLivesDialog(),
      );
      return;
    }
    if (item.type == LevelType.battle) {
      int battleEndDate = sharedPref.getInt(Constants.KEY_USER_BATTLE_END_TIME, 0);

      if (battleEndDate != 0) {
        final dateTimeNowInMillisecont = DateTime.now().millisecondsSinceEpoch;
        battleEndDate = battleEndDate * 1000;
        if (dateTimeNowInMillisecont < battleEndDate) {
          await battleRepository.getBattleData();
          return;
        } else {
          await sharedPref.prefs.remove(Constants.KEY_USER_BATTLE_END_TIME);
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
}
