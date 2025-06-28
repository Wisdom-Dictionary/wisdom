import 'dart:async';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:wisdom/core/db/db_helper.dart';
import 'package:wisdom/core/db/preference_helper.dart';
import 'package:wisdom/core/domain/entities/def_enum.dart';
import 'package:wisdom/core/localization/locale_keys.g.dart';
import 'package:wisdom/core/session/manager/session_manager.dart';
import 'package:wisdom/data/model/battle/battle_user_model.dart';
import 'package:wisdom/data/model/my_contacts/user_details_model.dart';
import 'package:wisdom/data/model/roadmap/level_model.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:wisdom/domain/repositories/battle_repository.dart';
import 'package:wisdom/domain/repositories/level_test_repository.dart';
import 'package:wisdom/domain/repositories/profile_repository.dart';
import 'package:wisdom/domain/repositories/roadmap_repository.dart';
import 'package:wisdom/presentation/components/dialog_background.dart';
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
          userDetailsModel = await profileRepository.getUserCabinet();
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

  bool get initialRequest => roadMapRepository.topLastPage == roadMapRepository.bottomLastPage;

  void getLevels() {
    safeBlock(() async {
      try {
        if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
          setBusy(true, tag: getLevelsTag);
          if (locator<LocalViewModel>().userLevelsSatusChanged) {
            await roadMapRepository.getLevels();
            locator<LocalViewModel>().changeRoadMapLoadingStatus(false);
          }
          setSuccess(tag: getLevelsTag);
        } else {
          setBusy(false, tag: getLevelsTag);
          callBackError(LocaleKeys.no_internet.tr());
        }
      } catch (e) {
        if (e is VMException) {
          if (e.response != null) {
            if (e.response!.statusCode == 403) {
              locator<SessionManager>().endLocalSession();
            }
          }
        }
      }
    }, callFuncName: 'getLevels', tag: getLevelsTag, inProgress: false);
  }

  void getLevelsBottomMore() {
    setBusy(true, tag: getLevelsMoreTag);
    safeBlock(() async {
      try {
        if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
          await roadMapRepository.getLevelsPaginationBottom();
          setSuccess(tag: getLevelsMoreTag);
        } else {
          setBusy(false, tag: getLevelsMoreTag);
          callBackError(LocaleKeys.no_internet.tr());
        }
      } catch (e) {
        if (e is VMException) {
          if (e.response != null) {
            if (e.response!.statusCode == 403) {
              locator<SessionManager>().endLocalSession();
            }
          }
        }
      }
    }, callFuncName: 'getLevelsMore', tag: getLevelsMoreTag, inProgress: false);
  }

  void getLevelsTopMore() {
    setBusy(true, tag: getLevelsMoreTag);
    safeBlock(() async {
      try {
        if (await localViewModel.netWorkChecker.isNetworkAvailable()) {
          await roadMapRepository.getLevelsPaginationTop();
          setSuccess(tag: getLevelsMoreTag);
        } else {
          setBusy(false, tag: getLevelsMoreTag);
          callBackError(LocaleKeys.no_internet.tr());
        }
      } catch (e) {
        if (e is VMException) {
          if (e.response != null) {
            if (e.response!.statusCode == 403) {
              // showDialog(
              //   context: context!,
              //   builder: (context) => const DialogBackground(
              //     child: SignInDialog(),
              //   ),
              // );
              locator<SessionManager>().endLocalSession();
            }
          }
        }
      }
    }, callFuncName: 'getLevelsMore', tag: getLevelsMoreTag, inProgress: false);
  }

  bool get hasUserLifes => context!.read<CountdownProvider>().hasUserLives;

  void goLevel100ExercisesPage() {
    levelTestRepository.setExerciseType(TestExerciseType.level100Exercise);
    Navigator.pushNamed(context!, Routes.wordExercisesPage);
  }

  void selectLevel(LevelModel item) async {
    final noUserLives = !context!.read<CountdownProvider>().hasUserLives;
    if (noUserLives) {
      showDialog(
        context: context!,
        builder: (context) => OutOfLivesDialog(
          showHeartIcon: true,
          title: "you_did_not_start_the_battle".tr(),
          subTitle: "you_do_not_have_enough_lives".tr(),
        ),
      );
      return;
    }
    if (item.type == LevelType.battle) {
      battleRepository.setSelectedLevelItem(item);
      showDialog(
        context: context!,
        builder: (context) => StartBattleDialog(),
      );
      locator<LocalViewModel>().changeRoadMapLoadingStatus(true);
      return;
    }
    if (item.type == LevelType.test) {
      levelTestRepository.setSelectedLevel(item);
      goLevel100ExercisesPage();
      return;
    }
    if (!(item.userCurrentLevel ?? false) && (item.star ?? 0) == 0) {
      return;
    }
    roadMapRepository.setSelectedLevel(item);
    levelTestRepository.setSelectedLevel(item);
    locator<LocalViewModel>().changePageIndex(25);
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
